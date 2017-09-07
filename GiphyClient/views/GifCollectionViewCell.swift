//
//  GifCollectionViewCell.swift
//  GiphyClient
//
//  Created by Scott Doerrfeld on 8/30/17.
//  Copyright © 2017 Scott Doerrfeld. All rights reserved.
//

import Foundation
import UIKit
import FLAnimatedImage

class GifCollectionViewCell: UICollectionViewCell {
    var imageView: FLAnimatedImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.imageView = FLAnimatedImageView()
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
        DispatchQueue.global(qos: .userInteractive).async {
            let gifImage = FLAnimatedImage(animatedGIFData: data)
            DispatchQueue.main.async {
                self.imageView.animatedImage = gifImage
                self.backgroundColor = UIColor.black
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.animatedImage = nil
    }
}
