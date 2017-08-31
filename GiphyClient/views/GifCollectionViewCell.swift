//
//  GifCollectionViewCell.swift
//  GiphyClient
//
//  Created by Scott Doerrfeld on 8/30/17.
//  Copyright © 2017 Scott Doerrfeld. All rights reserved.
//

import UIKit
import Gifu

class GifCollectionViewCell: UICollectionViewCell {
    var imageView: GIFImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.imageView = GIFImageView()
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
        self.imageView.prepareForAnimation(withGIFData: data)
        self.imageView.startAnimatingGIF()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.prepareForReuse()
    }
}
