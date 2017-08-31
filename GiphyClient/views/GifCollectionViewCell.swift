//
//  GifCollectionViewCell.swift
//  GiphyClient
//
//  Created by Scott Doerrfeld on 8/30/17.
//  Copyright © 2017 Scott Doerrfeld. All rights reserved.
//

import Foundation
import UIKit
import SwiftyGif

class GifCollectionViewCell: UICollectionViewCell {
    var imageView: UIImageView!
    var url: String?
    
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
        DispatchQueue.global(qos: .userInteractive).async {
            let gifImage = UIImage(gifData: data)
            let gifManager = SwiftyGifManager(memoryLimit: 20)
            DispatchQueue.main.async {
                self.imageView.setGifImage(gifImage, manager: gifManager)
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.removeFromSuperview()
        self.imageView = UIImageView()
        self.contentView.addSubview(self.imageView)
        self.imageView.frame = self.contentView.frame
    }
}
