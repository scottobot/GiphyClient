//
//  GiphyService.swift
//  GiphyClient
//
//  Created by Scott Doerrfeld on 8/29/17.
//  Copyright © 2017 Scott Doerrfeld. All rights reserved.
//

import Foundation
import Alamofire

protocol GifService {
    func getRandomGif(completion: @escaping (String) -> Void)
}

class GiphyService: GifService {
    let serviceUrl = "https://api.giphy.com/v1/gifs/random?api_key=9d7dbfe707004b9798b7815c5642d002"
    
    func getRandomGif(completion: @escaping (String) -> Void) {
        Alamofire.request(serviceUrl).responseJSON { response in
            //print("Request: \(String(describing: response.request))")   // original url request
            //print("Response: \(String(describing: response.response))") // http url response
            //print("Result: \(response.result)")                         // response serialization result
            
            if let json = response.result.value {
                //print("JSON: \(json)") // serialized json response
            }
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                //print("Data: \(utf8Text)") // original server data as UTF8 string
            }
            
            completion("https://gif/random.gif")
        }
    }
}
