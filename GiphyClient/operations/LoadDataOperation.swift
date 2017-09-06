//
//  LoadDataOperation.swift
//  GiphyClient
//
//  Created by Scott Doerrfeld on 9/5/17.
//  Copyright © 2017 Scott Doerrfeld. All rights reserved.
//

import Foundation

class LoadDataOperation: AsyncOperation {
    var gif: Gif?
    
    override func execute() {
        guard !self.isCancelled else { return }
        Services.gifService.getRandomGif() { (gif) in
            guard !self.isCancelled else { return }
            self.gif = gif
            self.finish()
        }
    }
}
