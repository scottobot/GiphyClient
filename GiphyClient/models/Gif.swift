//
//  Gif.swift
//  GiphyClient
//
//  Created by Scott Doerrfeld on 8/29/17.
//  Copyright © 2017 Scott Doerrfeld. All rights reserved.
//

import Foundation
import ObjectMapper

protocol Gif {
    var url: String? { get }
    var frames: Int? { get }
    var width: CGFloat? { get }
    var height: CGFloat? { get }
}

struct GiphyGif: Gif, Mappable {
    var url: String?
    var frames: Int?
    var width: CGFloat?
    var height: CGFloat?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        url         <- map["data.image_url"]
        frames      <- (map["data.image_frames"], IntTransform())
        width       <- (map["data.image_width"], CGFloatTransform())
        height      <- (map["data.image_height"], CGFloatTransform())
    }
}
