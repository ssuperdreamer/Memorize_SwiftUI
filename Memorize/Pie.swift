//
//  Pie.swift
//  Memorize
//
//  Created by Takeshi on 9/21/21.
//

import SwiftUI

struct Pie: Shape {
    
    var startAngel: Angle
    var endAngel: Angle
    var clockwise: Bool = false
    
    var animatableData: AnimatablePair<Double, Double> {
        get {
            AnimatableData(startAngel.radians, endAngel.radians)
        }
        set {
            startAngel = Angle.radians(newValue.first)
            endAngel = Angle.radians(newValue.second)
        }
    }
    
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        let start = CGPoint(
            x: center.x + radius * CGFloat(cos(startAngel.radians)),
            y: center.y + radius * CGFloat(sin(startAngel.radians))
        )
    
        var p = Path()
        p.move(to: center)
        p.addLine(to: start)
        p.addArc(
            center: center,
            radius: radius,
            startAngle: startAngel,
            endAngle: endAngel,
            clockwise: !clockwise
        )
        p.addLine(to: center)
        return p
    }
}
