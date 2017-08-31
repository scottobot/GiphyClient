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
}

struct GiphyGif: Gif, Mappable {
    var url: String?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        url         <- map["data.image_url"]
    }
}
