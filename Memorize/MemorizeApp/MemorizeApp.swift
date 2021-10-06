//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Takeshi on 9/9/21.
//

import SwiftUI

@main
struct MemorizeApp: App {
    //    private let game = EmojiMemoryGame()
    //
    //    var body: some Scene {
    //        WindowGroup {
    //            EmojiMemoryGameView(game: game)
    //        }
    //    }
    
    
//    @StateObject var document = EmojiArtDocument()
    @StateObject var paletteStore = PaletteStore(named: "Default")
    
    var body: some Scene {
        
        DocumentGroup(newDocument: {EmojiArtDocument() }) { config in
            EmojiArtDocumentView(document: config.document)
                .environmentObject(paletteStore)
        }
        
        //        WindowGroup {
        //            EmojiArtDocumentView(document: document)
        //                .environmentObject(paletteStore)
        //        }
    }
}
