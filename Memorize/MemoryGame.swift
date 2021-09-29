//
//  MemoryGame.swift
//  Memorize
//
//  Created by Takeshi on 9/15/21.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
        
    private(set) var cards: Array<Card>
    
    private var indexOfTheOneAndOnlyFaceUpCard: Int? {
        get { cards.indices.filter({ cards[$0].isFaceUp }).oneAndOnly }
        set { cards.indices.forEach { cards[$0].isFaceUp = ($0 == newValue) } }
    }
    
    init(numberOfPairsOfCards: Int, createCardContent:(Int) -> CardContent) {
        cards = []
        // add numberOfPairsOfCards x 2 cards to cards array
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = createCardContent(pairIndex)
            cards.append(Card(content: content, id: pairIndex * 2))
            cards.append(Card(content: content, id: pairIndex * 2 + 1))
        }
        cards.shuffle()
    }
    
  
   
    mutating func choose(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }),
           !cards[chosenIndex].isFaceUp,
           !cards[chosenIndex].isMatched {
            if  let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
                if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                }
                cards[chosenIndex].isFaceUp = true
            } else {
                indexOfTheOneAndOnlyFaceUpCard = chosenIndex
            }
        }
    }
    
    mutating func shuffle() {
        cards.shuffle()
    }
    
    
    struct Card: Identifiable {
        var isFaceUp = false {
            didSet {
                if isFaceUp {
                    startUsingBounsTime()
                } else {
                    stopUsingBounsTime()
                }
            }
        }
        var isMatched = false {
            didSet {
                stopUsingBounsTime()
            }
        }
        let content: CardContent
        let id: Int
        
        var bounsTimeLimit: TimeInterval = 6
        
        private var faceUpTime: TimeInterval {
            if let lastFaceUpDate = self.lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }
        
        var lastFaceUpDate: Date?
        
        var pastFaceUpTime: TimeInterval = 0
        
        var bounsTimeRemaining: TimeInterval {
            max(0, bounsTimeLimit - faceUpTime)
        }
        
        var bounsRemaining: Double {
            (bounsTimeLimit > 0 && bounsTimeRemaining > 0) ? bounsTimeRemaining/bounsTimeLimit : 0
        }
        
        var hasEarnedBouns: Bool {
            isMatched && bounsTimeRemaining > 0
        }
        
        var isConsumingBounsTime: Bool {
            isFaceUp && !isMatched && bounsTimeRemaining > 0
        }
        
        private mutating func startUsingBounsTime() {
            if isConsumingBounsTime, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }
        
        private mutating func stopUsingBounsTime() {
            pastFaceUpTime = faceUpTime
            self.lastFaceUpDate = nil
        }
    }
}

extension Array  {
    var oneAndOnly: Element? {
        if self.count == 1 {
            return first
        } else {
            return nil
        }
    }
}
