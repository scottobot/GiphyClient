//
//  AppColors.swift
//  GiphyClient
//
//  Created by Scott Doerrfeld on 8/30/17.
//  Copyright © 2017 Scott Doerrfeld. All rights reserved.
//

import Foundation
import UIKit

struct AppColors {
    static let green = UIColor(hex: 0x2AFD9C)
    static let yellow = UIColor(hex: 0xFEFE9F)
    static let orange = UIColor(hex: 0xFC6869)
    static let purple = UIColor(hex: 0x9840FB)
    static let blue = UIColor(hex: 0x23CDFD)
    static let colorPalette = [green, yellow, orange, purple, blue]
    
    var rotatingColors: [UIColor] = []
    
    mutating func getRandomColor() -> UIColor {
        if self.rotatingColors.count == 0 {
            self.rotatingColors = AppColors.colorPalette.shuffle()
        }
        return self.rotatingColors.popLast()!
    }
}
