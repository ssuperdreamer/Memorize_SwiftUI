//
//  ContentView.swift
//  Memorize
//
//  Created by Takeshi on 9/9/21.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    
    @ObservedObject var game: EmojiMemoryGame
    
    var body: some View {
        VStack{
            ScrollView {
                LazyVGrid(columns:[GridItem(.adaptive(minimum: 60))]) {
                    ForEach(game.cards) { card in
                        CardView(card: card).aspectRatio(2/3, contentMode: .fit).onTapGesture {
                            game.choose(card)
                        }
                    }
                }
            }.foregroundColor(.red)
        }.padding(.horizontal)
    }
}

struct CardView: View {
    
    let card: EmojiMemoryGame.Card
    
    var body: some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: 20)
            if card.isFaceUp {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: 3)
                Text(card.content).font(Font.system(size: 100))
            } else if(card.isMatched) {
                shape.opacity(0)
            } else {
                shape.fill()
            }
        }
        
//        GeometryReader(content: { geometry
//
//        })
    }
}










struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        EmojiMemoryGameView(game: game).preferredColorScheme(.light)
        EmojiMemoryGameView(game: game).preferredColorScheme(.dark)
    }
}
