//
//  GifCollectionViewCell.swift
//  GiphyClient
//
//  Created by Scott Doerrfeld on 8/30/17.
//  Copyright © 2017 Scott Doerrfeld. All rights reserved.
//

import UIKit
import SwiftyGif

class GifCollectionViewCell: UICollectionViewCell {
    let gifManager = SwiftyGifManager(memoryLimit:20)
    
    var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.imageView = UIImageView()
        self.contentView.addSubview(self.imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.imageView.frame = self.contentView.frame
    }
    
    func displayGif(data: Data) {
        let gifImage = UIImage(gifData: data)
        self.imageView.setGifImage(gifImage, manager: self.gifManager)
    }
}
