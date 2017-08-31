//
//  AppInitViewController.swift
//  GiphyClient
//
//  Created by Scott Doerrfeld on 8/30/17.
//  Copyright © 2017 Scott Doerrfeld. All rights reserved.
//

import UIKit

class AppInitViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.switchToHomeView()
    }

    func switchToHomeView() {
        guard let navController = self.storyboard?.instantiateViewController(withIdentifier: "Home") as? UINavigationController else {
             fatalError("Could not instantiate Home view controller from storyboard")
        }
        guard let viewController = navController.topViewController as? GifCollectionViewController else {
            fatalError("Could not get view controller of type GifCollectionViewController")
        }
        let service = GiphyService()
        let viewModel = GifCollectionViewModel(gifService: service)
        viewController.viewModel = viewModel
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = navController
    }

}
