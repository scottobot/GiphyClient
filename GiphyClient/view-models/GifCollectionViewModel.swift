//
//  GifCollectionViewModel.swift
//  GiphyClient
//
//  Created by Scott Doerrfeld on 8/30/17.
//  Copyright © 2017 Scott Doerrfeld. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage

class GifCollectionViewModel {
    let gifService: GifService
    
    var isLoading = false
    var gifs: [Gif] = []
    
    var dataSize: Int {
        return self.gifs.count
    }
    
    init(gifService: GifService) {
        self.gifService = gifService
    }
    
    func loadData(amount: Int, completion: @escaping (Bool) -> Void) {
        guard !self.isLoading else {
            completion(false)
            return
        }
        self.isLoading = true
        
        //print("=== Loading \(amount) gifs...")
        
        var count = 0
        for _ in 1...amount {
            gifService.getRandomGif() { (gif) in
                if let randomGif = gif {
                    //print("   ", randomGif.url ?? "Gif data failed to load")
                    self.gifs.append(randomGif)
                }
                count += 1
                if count == amount {
                    //print("    Loading complete!")
                    self.isLoading = false
                    completion(true)
                }
            }
        }
    }
    
    func loadGif(index: Int, completion: @escaping (Data?, String?) -> Void) {
        var gif = self.gifs[index]
        guard let gifUrl = gif.url, !gif.isLoading else {
            completion(nil, nil)
            return
        }
        if let gifData = gif.cachedData {
            //print("<<< found cache for index \(index)")
            completion(gifData, gifUrl)
            return
        }
        //print(">>> loading \(gifUrl) for index \(index)")
        gif.isLoading = true
        let gifIndex = index
        Alamofire.request(gifUrl).responseData { response in
            //debugPrint(response)
            //print(response.request)
            //print(response.response)
            //debugPrint(response.result)
            //print("<<< loading success for index \(index)")
            self.gifs[gifIndex].isLoading = false
            self.gifs[gifIndex].cachedData = response.data
            completion(response.data, gifUrl)
        }
    }
    
    func getHeight(width: CGFloat, index: Int) -> CGFloat {
        let gif = self.gifs[index]
        guard let gifWidth = gif.width else { return width }
        guard let gifHeight = gif.height else { return width }
        return width * (gifHeight / gifWidth)
    }
    
    func url(index: Int) -> String? {
        return self.gifs[index].url
    }
}
