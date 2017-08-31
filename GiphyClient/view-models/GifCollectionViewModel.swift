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

enum LoadState {
    case idle
    case loading
}

class GifCollectionViewModel {
    let gifService: GifService
    
    var loadState = LoadState.idle
    var gifs: [Gif] = []
    
    var dataSize: Int {
        return self.gifs.count
    }
    
    init(gifService: GifService) {
        self.gifService = gifService
    }
    
    func loadData(amount: Int, completion: @escaping () -> Void) {
        guard self.loadState == .idle else { return }
        self.loadState = .loading
        
        print("=== Loading \(amount) gifs...")
        
        var count = 0
        for _ in 1...amount {
            gifService.getRandomGif() { (gif) in
                if let randomGif = gif {
                    print("   ", randomGif.url ?? "Gif data failed to load")
                    self.gifs.append(randomGif)
                }
                count += 1
                if count == amount {
                    print("    Loading complete!")
                    self.loadState = .idle
                    completion()
                }
            }
        }
    }
    
    func loadGif(index: Int, completion: @escaping (Data?) -> Void) {
        let gif = self.gifs[index]
        guard let gifUrl = gif.url else {
            completion(nil)
            return
        }
        if let gifData = gif.cachedData {
            completion(gifData)
            return
        }
        let gifIndex = index
        Alamofire.request(gifUrl).responseData { response in
            //debugPrint(response)
            //print(response.request)
            //print(response.response)
            //debugPrint(response.result)
            if let data = response.data {
                self.gifs[gifIndex].cachedData = data
            }
            completion(response.data)
        }
    }
    
    func getHeight(width: CGFloat, index: Int) -> CGFloat {
        let gif = self.gifs[index]
        guard let gifWidth = gif.width else { return width }
        guard let gifHeight = gif.height else { return width }
        return width * (gifHeight / gifWidth)
    }
}
