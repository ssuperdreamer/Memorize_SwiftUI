//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Takeshi on 9/15/21.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    typealias Card = MemoryGame<String>.Card
    
    private static let emojis = ["🚲","🚂","🚁","🚜","🚕","🏎","🚑","🚔","🚒","✈️"
                  ,"🚀","⛵️","🛸","🛶","🚌","🏍","🛺","🚠","🛵","🚗","🚚","🚇","🛻","🚝"]
    
    private static func createMemoryGame() -> MemoryGame<String> {
        MemoryGame<String>(numberOfPairsOfCards: 12) { pairIndex in emojis[pairIndex] }
    }
    
    @Published private var model = createMemoryGame()
    
    var cards: Array<Card> {
        return model.cards
    }
    
    // MARK: - Intent(s)
    
    func choose(_ card: Card) {
        model.choose(card)
    }
    
    func shuffle() {
        model.shuffle()
    }
    
    func restart() {
        model = EmojiMemoryGame.createMemoryGame()
    }
}
