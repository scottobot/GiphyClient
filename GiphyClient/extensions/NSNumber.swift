//
//  NSNumber.swift
//  GiphyClient
//
//  Created by Scott Doerrfeld on 8/31/17.
//  Copyright © 2017 Scott Doerrfeld. All rights reserved.
//

import Foundation
import UIKit

extension Int {
    static func random(_ range:Range<Int>) -> Int {
        return range.lowerBound + Int(arc4random_uniform(UInt32(range.upperBound - range.lowerBound)))
    }
}
