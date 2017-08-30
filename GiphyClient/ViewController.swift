//
//  ViewController.swift
//  GiphyClient
//
//  Created by Scott Doerrfeld on 8/29/17.
//  Copyright © 2017 Scott Doerrfeld. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var gifService: GifService!

    override func viewDidLoad() {
        super.viewDidLoad()
        gifService.getRandomGif()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

