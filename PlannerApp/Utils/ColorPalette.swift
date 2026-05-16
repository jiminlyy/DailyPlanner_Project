//
//  ColorPalette.swift
//  PlannerApp
//
//  Created by 이지민 on 5/17/26.
//

import Foundation

enum ColorPalette {
    /// #A8D8EA 베이스. lightness 95% → 25%로 24단계 그라데이션.
    static let todoColors: [String] = (0..<24).map { i in
        let l = 0.95 - Double(i) * (0.95 - 0.25) / 23.0
        return hslToHex(h: 196, s: 0.61, l: l)
    }

    private static func hslToHex(h: Double, s: Double, l: Double) -> String {
        let c = (1 - abs(2 * l - 1)) * s
        let h2 = h / 60
        let x = c * (1 - abs(h2.truncatingRemainder(dividingBy: 2) - 1))
        let m = l - c / 2
        let (r1, g1, b1): (Double, Double, Double)
        switch h2 {
        case 0..<1: (r1, g1, b1) = (c, x, 0)
        case 1..<2: (r1, g1, b1) = (x, c, 0)
        case 2..<3: (r1, g1, b1) = (0, c, x)
        case 3..<4: (r1, g1, b1) = (0, x, c)
        case 4..<5: (r1, g1, b1) = (x, 0, c)
        default:    (r1, g1, b1) = (c, 0, x)
        }
        let r = Int(((r1 + m) * 255).rounded())
        let g = Int(((g1 + m) * 255).rounded())
        let b = Int(((b1 + m) * 255).rounded())
        return String(format: "#%02X%02X%02X", r, g, b)
    }
}
