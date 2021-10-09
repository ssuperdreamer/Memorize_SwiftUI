//
//  EmojiArtDocument.swift
//  Memorize
//
//  Created by Takeshi on 9/29/21.
//

import SwiftUI
import Combine
import UniformTypeIdentifiers

extension UTType {
    static let emojiart = UTType(exportedAs: "axag.fun.memorize")
}

class EmojiArtDocument: ReferenceFileDocument {
    static var readableContentTypes = [UTType.emojiart]
    static var writableContentTypes = [UTType.emojiart]
    
    required init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            emojiArt = try EmojiArtModel(json: data)
            fetchBackgroundImageDataIfNecessary()
        } else {
            throw CocoaError(.fileReadCorruptFile)
        }
    }
    
    func snapshot(contentType: UTType) throws -> Data {
        try emojiArt.json()
    }
    
    func fileWrapper(snapshot: Data, configuration: WriteConfiguration) throws -> FileWrapper {
        FileWrapper(regularFileWithContents: snapshot)
    }
    
    typealias Snapshot = Data
    
    @Published private(set) var emojiArt: EmojiArtModel {
        didSet {
            if emojiArt.background != oldValue.background {
                fetchBackgroundImageDataIfNecessary()
            }
        }
    }
    
    init() {
        emojiArt = EmojiArtModel()
    }
    
    var emojis: [EmojiArtModel.Emoji] { emojiArt.emojis }
    
    var background: EmojiArtModel.Background { emojiArt.background }
    
    @Published var backgroundImage: UIImage?
    @Published var backgroundImageFetchStatus:BackgroundImageFetchStatus = .idle
    
    enum BackgroundImageFetchStatus: Equatable {
        case idle
        case fetching
        case failed(URL)
    }
    
    private var backgroundImageFetchCancellable: AnyCancellable?
    
    private func fetchBackgroundImageDataIfNecessary() {
        backgroundImage = nil
        switch emojiArt.background {
        case .url(let url):
            //fetch the url
            backgroundImageFetchStatus = .fetching
            backgroundImageFetchCancellable?.cancel()
            //            let session = URLSession.shared
            //            let publisher = session.dataTaskPublisher(for: url)
            //                .map{ (data, URLResponse) in UIImage(data: data) }
            //                .replaceError(with: nil)
            //            backgroundImageFetchCancellable = publisher
            //                .assign(to: \EmojiArtDocument.backgroundImage, on: self)
            
//            // with replaceError
//            let session = URLSession.shared
//            let publisher = session.dataTaskPublisher(for: url)
//                .map{ (data, URLResponse) in UIImage(data: data) }
//                .replaceError(with: nil)
//            backgroundImageFetchCancellable = publisher.sink {[weak self] image in
//                self?.backgroundImage = image
//                self?.backgroundImageFetchStatus = (image != nil) ? .idle : .failed(url)
//            }
            
            // without replaceError
            let session = URLSession.shared
            let publisher = session.dataTaskPublisher(for: url)
                .map{ (data, URLResponse) in UIImage(data: data) }
                .receive(on: DispatchQueue.main)
            backgroundImageFetchCancellable = publisher.sink(receiveCompletion: { result in
                switch result {
                case .finished:
                    print("success!")
                case .failure(let error):
                    print("failed: error = \(error)")
                }
            },
                                                             receiveValue: { [weak self] image in
                self?.backgroundImage = image
                self?.backgroundImageFetchStatus = (image != nil) ? .idle : .failed(url)
            })
            
            //            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            //                let imageData = try? Data(contentsOf: url)
            ////                //  background threads is not allowed to change the UI
            ////                if imageData != nil {
            ////                    self?.backgroundImage = UIImage(data: imageData!)
            ////                }
            //                //so we use main thread
            //                DispatchQueue.main.async {
            //                    if self?.emojiArt.background == EmojiArtModel.Background.url(url) {
            //                        self?.backgroundImageFetchStatus = .idle
            //                        if imageData != nil {
            //                            self?.backgroundImage = UIImage(data: imageData!)
            //                        }
            //                        if self?.backgroundImage == nil {
            //                            self?.backgroundImageFetchStatus = .failed(url)
            //                        }
            //                    }
            //                }
            //            }
        case .imageData(let data):
            backgroundImage = UIImage(data: data)
        case .blank:
            break
        }
    }
    
    
    
    // MARK: Intent(s)
    
    func setBackground(_ background: EmojiArtModel.Background, undoManager: UndoManager?) {
        undoablyPerform(operation: "Set Background", with: undoManager) {
            emojiArt.background = background
        }
    }
    
    func addEmoji(_ emoji: String, at location:(x: Int, y: Int), size: CGFloat, undoManager: UndoManager?) {
        
        undoablyPerform(operation: "Add \(emoji)", with: undoManager) {
            emojiArt.addEmoji( emoji, at: location, size: Int(size))
        }
        
    }
    
    func moveEmoji(_ emoji: EmojiArtModel.Emoji, by offset: CGSize, undoManager: UndoManager?) {
        if let index = emojiArt.emojis.index(matching: emoji) {
            undoablyPerform(operation: "Move", with: undoManager) {
                emojiArt.emojis[index].x += Int(offset.width)
                emojiArt.emojis[index].y += Int(offset.height)
            }
        }
    }
    
    func scaleEmoji(_ emoji: EmojiArtModel.Emoji, by scale: CGFloat, undoManager: UndoManager?) {
        if let index = emojiArt.emojis.index(matching: emoji) {
            undoablyPerform(operation: "Scale", with: undoManager) {
                emojiArt.emojis[index].size = Int((CGFloat(emojiArt.emojis[index].size) * scale).rounded(.toNearestOrAwayFromZero))
            }
        }
    }
    
    
    // MARK: - Undo
    
    private func undoablyPerform(operation: String, with undoManager: UndoManager? = nil, doit: () -> Void) {
        let oldEmojiArt = emojiArt
        doit()
        undoManager?.registerUndo(withTarget: self) { myself in
            myself.undoablyPerform(operation: operation, with: undoManager) {
                myself.emojiArt = oldEmojiArt
            }
        }
        undoManager?.setActionName(operation)
    }
}
