//
//  Cardify.swift
//  Memorize
//
//  Created by Takeshi on 9/22/21.
//

import SwiftUI

struct Cardify: AnimatableModifier {
    init(isFaceUp: Bool) {
        rotation = isFaceUp ? 0 : 180
    }
    
    var rotation: Double // in degrees
    
    var animatableData: Double {
        get { rotation }
        set { rotation = newValue }
    }

    func body(content: Content) -> some View {
//        print(rotation)
        ZStack {
            let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
            if rotation < 90 {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: DrawingConstants.lineWidth)
            } else {
                shape.fill()
            }
            content.opacity(rotation < 90 ? 1 : 0)
        }.rotation3DEffect(Angle(degrees: rotation) , axis: (x: 0, y: 1, z: 0))
    }
    
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 10.0
        static let lineWidth: CGFloat = 3
    }
}


extension View {
    func cardify(isFaceUp: Bool) -> some View {
        self.modifier(Cardify(isFaceUp: isFaceUp))
    }
}
