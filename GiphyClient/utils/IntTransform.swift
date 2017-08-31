//
//  IntTransform.swift
//  GiphyClient
//
//  Created by Scott Doerrfeld on 8/30/17.
//  Copyright © 2017 Scott Doerrfeld. All rights reserved.
//

import Foundation
import ObjectMapper

open class IntTransform: TransformType {
    public typealias Object = Int
    public typealias JSON = String
    
    public init() {}
    
    open func transformFromJSON(_ value: Any?) -> Int? {
        if let string = value as? String {
            return Int(string)
        }
        return nil
    }
    
    open func transformToJSON(_ value: Int?) -> String? {
        guard let value = value else { return nil }
        return String(value)
    }
}
