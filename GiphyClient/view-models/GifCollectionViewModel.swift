//
//  GifCollectionViewModel.swift
//  GiphyClient
//
//  Created by Scott Doerrfeld on 8/30/17.
//  Copyright © 2017 Scott Doerrfeld. All rights reserved.
//

import Foundation

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
    
    func loadGifs(amount: Int, completion: @escaping () -> Void) {
        guard self.loadState == .idle else { return }
        self.loadState = .loading
        
        var count = 0
        for _ in 1...amount {
            gifService.getRandomGif() { (gif) in
                if let randomGif = gif {
                    print("===", randomGif.url!)
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
    
    func url(for index: Int) -> String? {
        return self.gifs[index].url
    }
}
