//
//  GiphyService.swift
//  GiphyClient
//
//  Created by Scott Doerrfeld on 8/29/17.
//  Copyright © 2017 Scott Doerrfeld. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

protocol GifService {
    func getRandomGif(completion: @escaping (Gif?) -> Void)
}

class GiphyService: GifService {
    static let serviceUrl = "https://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC"
    
    func getRandomGif(completion: @escaping (Gif?) -> Void) {
        Alamofire.request(GiphyService.serviceUrl).responseJSON { response in
            //debugPrint(response)
            if let json = response.result.value {
                //print("JSON: \(json)") // serialized json response
                let gif = Mapper<GiphyGif>().map(JSONObject: json)
                completion(gif)
            }
            else {
                completion(nil)
            }
        }
    }
}

class TestGifService: GifService {
    func getRandomGif(completion: @escaping (Gif?) -> Void) {
        let gif = TestGif()
        gif.frames = 1
        gif.width = CGFloat(Int.random(200..<400))
        gif.height = CGFloat(Int.random(200..<400))
        completion(gif)
    }
}
