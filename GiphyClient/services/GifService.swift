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
    let serviceUrl = "https://api.giphy.com/v1/gifs/random?api_key=9d7dbfe707004b9798b7815c5642d002"
    
    func getRandomGif(completion: @escaping (Gif?) -> Void) {
        Alamofire.request(serviceUrl).responseJSON { response in
            //print("Request: \(String(describing: response.request))")   // original url request
            //print("Response: \(String(describing: response.response))") // http url response
            //print("Result: \(response.result)")                         // response serialization result
            
            var gif: GiphyGif? = nil
            
            if let json = response.result.value {
                //print("JSON: \(json)") // serialized json response
                gif = Mapper<GiphyGif>().map(JSONObject: json)
            }
            
            completion(gif)
        }
    }
}

class TestGifService: GifService {
    func getRandomGif(completion: @escaping (Gif?) -> Void) {
        var gif = TestGif()
        gif.frames = 1
        gif.width = CGFloat(Int.random(200..<400))
        gif.height = CGFloat(Int.random(200..<400))
        completion(gif)
    }
}
