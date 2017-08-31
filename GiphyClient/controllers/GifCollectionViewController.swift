//
//  GifCollectionViewController.swift
//  GiphyClient
//
//  Created by Scott Doerrfeld on 8/29/17.
//  Copyright © 2017 Scott Doerrfeld. All rights reserved.
//

import UIKit
import CHTCollectionViewWaterfallLayout

private let gifViewCellIdentifier = "GifViewCell"
private let loadingCellIdentifier = "LoadingCell"

class GifCollectionViewController: UICollectionViewController {

    let initialPageSize = 12
    let pageSize = 4
    let numColumns = 2
    let sectionInsets = UIEdgeInsets(top: 4.0, left: 4.0, bottom: 4.0, right: 4.0)
    var appColors = AppColors()
    
    var viewModel: GifCollectionViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView!.register(GifCollectionViewCell.self, forCellWithReuseIdentifier: gifViewCellIdentifier)
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: loadingCellIdentifier)
        
        self.setupNavBar()
        self.setupLayout()

        self.loadMore(amount: self.initialPageSize)
    }
    
    func setupNavBar() {
        if let image = UIImage(named: "GiphyLogoWithTitle"), let navBar = self.navigationController?.navigationBar {
            let imageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: navBar.frame.size.width, height: navBar.frame.size.height * 0.8))
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            self.navigationItem.titleView = imageView
        }
    }
    
    func setupLayout() {
        // Create a waterfall layout
        let layout = CHTCollectionViewWaterfallLayout()
        
        // Change individual layout attributes for the spacing between cells
        layout.columnCount = numColumns
        layout.sectionInset = sectionInsets
        layout.minimumColumnSpacing = sectionInsets.left
        layout.minimumInteritemSpacing = sectionInsets.left
        
        // Collection view attributes
        self.collectionView!.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.collectionView!.alwaysBounceVertical = true
        
        // Add the waterfall layout to your collection view
        self.collectionView!.collectionViewLayout = layout
    }
    
    func loadMore(amount: Int) {
        let startIndex = self.viewModel.dataSize
        self.viewModel.loadData(amount: amount) { success in
            guard success else { return }
            if startIndex == 0 {
                self.collectionView!.reloadData()
            }
            else {
                self.collectionView!.performBatchUpdates({ () -> Void in
                    var indexPaths: [IndexPath] = []
                    let endIndex = startIndex + amount
                    for i in startIndex..<endIndex {
                        let indexPath = IndexPath(item: i, section: 0)
                        indexPaths.append(indexPath)
                    }
                    self.collectionView!.insertItems(at: indexPaths)
                    
                }, completion: nil)
            }
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // plus on to trigger data fetch
        return self.viewModel.dataSize
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: gifViewCellIdentifier, for: indexPath) as! GifCollectionViewCell
        cell.backgroundColor = self.appColors.getRandomColor()
        viewModel.loadGif(index: indexPath.item) { (data) in
            if let data = data {
                cell.backgroundColor = UIColor.black
                cell.displayGif(data: data)
            }
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == self.viewModel.dataSize - 1 {
            self.loadMore(amount: self.pageSize)
        }
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}

extension GifCollectionViewController : CHTCollectionViewDelegateWaterfallLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        let padding = sectionInsets.left * (CGFloat(numColumns) + 1)
        let itemWidth = (self.view.frame.width - padding) / CGFloat(numColumns)
        let itemHeight = self.viewModel.getHeight(width: itemWidth, index: indexPath.item)
        return CGSize(width: itemWidth, height: itemHeight)
    }
}
