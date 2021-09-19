//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Takeshi on 9/9/21.
//

import SwiftUI

@main
struct MemorizeApp: App {
    private let game = EmojiMemoryGame()
    
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(game: game)
        }
    }
}
