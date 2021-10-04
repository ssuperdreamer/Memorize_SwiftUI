//
//  EmojiArtDocument.swift
//  Memorize
//
//  Created by Takeshi on 9/29/21.
//

import SwiftUI


class EmojiArtDocument: ObservableObject {
    
    @Published private(set) var emojiArt: EmojiArtModel {
        didSet {
            autosave()
//            try? FileManager.default.removeItem(at: Autosave.url!)
            if emojiArt.background != oldValue.background {
                fetchBackgroundImageDataIfNecessary()
            }
        }
    }
    
    private struct Autosave {
        static let filename = "Autosaved.emojiart"
        static var url: URL? {
            let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            return documentDirectory?.appendingPathComponent(filename)
        }
    }
    
    private func autosave() {
        if let url = Autosave.url {
            save(to: url)
        }
    }
    
    private func save(to url: URL) {
        let thisFunction = "\(String(describing:self)).\(#function)"
        do {
            let data:Data = try emojiArt.json()
            
            print("\(thisFunction) json= \(String(data:data, encoding: .utf8) ?? "nil")")
            try data.write(to:url)
            print("\(thisFunction) success!")
        
        } catch let encodingError where encodingError is EncodingError {
            print("\(thisFunction) coudn't encode EmojiArt as JSON because \(encodingError.localizedDescription)")
        } catch {
//            print("EmojiArtDocument.save(to:) error = \(error)")
            print("\(thisFunction) error = \(error)")
        }
      
    }
    
    init() {
        if let url = Autosave.url, let autosavedEmojiArt = try? EmojiArtModel(url: url) {
            emojiArt = autosavedEmojiArt
            fetchBackgroundImageDataIfNecessary()
        } else {
            emojiArt = EmojiArtModel()
        }
        
        
//        emojiArt.addEmoji("😀", at: (-100, -100), size: 80)
//        emojiArt.addEmoji("😷", at: (100, 100), size: 40)
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
    
    private func fetchBackgroundImageDataIfNecessary() {
        backgroundImage = nil
        switch emojiArt.background {
        case .url(let url):
            //fetch the url
            backgroundImageFetchStatus = .fetching
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                let imageData = try? Data(contentsOf: url)
//                //  background threads is not allowed to change the UI
//                if imageData != nil {
//                    self?.backgroundImage = UIImage(data: imageData!)
//                }
                //so we use main thread
                DispatchQueue.main.async {
                    if self?.emojiArt.background == EmojiArtModel.Background.url(url) {
                        self?.backgroundImageFetchStatus = .idle
                        if imageData != nil {
                            self?.backgroundImage = UIImage(data: imageData!)
                        }
                        if self?.backgroundImage == nil {
                            self?.backgroundImageFetchStatus = .failed(url)
                        }
                    }
                }
            }
        case .imageData(let data):
            backgroundImage = UIImage(data: data)
        case .blank:
            break
        }
    }

    
    
    // MARK: Intent(s)
    
    func setBackground(_ background: EmojiArtModel.Background) {
        emojiArt.background = background
    }
    
    func addEmoji(_ emoji: String, at location:(x: Int, y: Int), size: CGFloat) {
        emojiArt.addEmoji( emoji, at: location, size: Int(size))
    }
    
    func moveEmoji(_ emoji: EmojiArtModel.Emoji, by offset: CGSize) {
        if let index = emojiArt.emojis.index(matching: emoji) {
            emojiArt.emojis[index].x += Int(offset.width)
            emojiArt.emojis[index].y += Int(offset.height)
        }
    }
    
    func scaleEmoji(_ emoji: EmojiArtModel.Emoji, by scale: CGFloat) {
        if let index = emojiArt.emojis.index(matching: emoji) {
            emojiArt.emojis[index].size = Int((CGFloat(emojiArt.emojis[index].size) * scale).rounded(.toNearestOrAwayFromZero))
        }
    }
    
}
