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
    
    init(gifService: GifService) {
        self.gifService = gifService
    }
    
    func loadData(amount: Int, completion: @escaping () -> Void) {
        guard self.loadState == .idle else { return }
        self.loadState = .loading
        
        var count = 0
        for _ in 1...amount {
            gifService.getRandomGif() { (gif) in
                if let randomGif = gif {
                    print("===", randomGif.url ?? "FAIL")
                    self.gifs.append(randomGif)
                }
                count += 1
                if count == amount {
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
        Alamofire.request(gifUrl).responseData { response in
            debugPrint(response)
            
            print(response.request)
            print(response.response)
            debugPrint(response.result)
           
            completion(response.data)
        }
    }
    
    func getHeight(width: CGFloat, index: Int) -> CGFloat {
        let gif = self.gifs[index]
        guard let gifWidth = gif.width else { return width }
        guard let gifHeight = gif.height else { return width }
        return width * (gifHeight / gifWidth)
    }
    
    func gif(at index: Int) -> Gif {
        return self.gifs[index]
    }
    
}
