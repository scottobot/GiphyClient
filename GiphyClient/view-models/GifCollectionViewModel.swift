//
//  GifCollectionViewModel.swift
//  GiphyClient
//
//  Created by Scott Doerrfeld on 8/30/17.
//  Copyright © 2017 Scott Doerrfeld. All rights reserved.
//

import Foundation

class GifCollectionViewModel {
    let gifService: GifService
    
    var gifs: [String] = []
    
    init(gifService: GifService) {
        self.gifService = gifService
    }
    
    func loadGifs(amount: Int, completion: @escaping () -> Void) {
        var count = 0
        for _ in 1...amount {
            gifService.getRandomGif() { (url) in
                print("===", url)
                self.gifs.append(url)
                count += 1
                if count == amount {
                    completion()
                }
            }
        }
    }
}
