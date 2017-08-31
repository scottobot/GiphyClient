//
//  CGFloatTransform.swift
//  GiphyClient
//
//  Created by Scott Doerrfeld on 8/30/17.
//  Copyright © 2017 Scott Doerrfeld. All rights reserved.
//

import Foundation
import ObjectMapper

open class CGFloatTransform: TransformType {
    public typealias Object = CGFloat
    public typealias JSON = String
    
    public init() {}
    
    open func transformFromJSON(_ value: Any?) -> CGFloat? {
        if let string = value as? String {
            return CGFloat((string as NSString).floatValue)
        }
        return nil
    }
    
    open func transformToJSON(_ value: CGFloat?) -> String? {
        guard let value = value else { return nil }
        return String(format: "%.2f", value)
    }
}
