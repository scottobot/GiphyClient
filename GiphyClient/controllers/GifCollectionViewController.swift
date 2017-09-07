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

class GifCollectionViewController: UICollectionViewController {
    fileprivate let initialPageSize = 12
    fileprivate let pageSize = 4
    fileprivate let numColumns = 2
    fileprivate let cellPadding = CGFloat(4)
    fileprivate var appColors = AppColors()
    
    var viewModel: GifCollectionViewModel = GifCollectionViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView!.register(GifCollectionViewCell.self, forCellWithReuseIdentifier: gifViewCellIdentifier)
        
        self.setupNavBar()
        self.setupLayout()
        self.setupPullToRefresh()

        self.loadMore(amount: self.initialPageSize)
    }
    
    private func setupNavBar() {
        if let image = UIImage(named: "GiphyLogoWithTitle"), let navBar = self.navigationController?.navigationBar {
            let imageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: navBar.frame.size.width, height: navBar.frame.size.height * 0.7))
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            self.navigationItem.titleView = imageView
        }
    }
    
    private func setupLayout() {
        let layout = self.collectionView!.collectionViewLayout as! CHTCollectionViewWaterfallLayout
        layout.columnCount = numColumns
        layout.sectionInset = UIEdgeInsets(top: cellPadding, left: cellPadding, bottom: self.view.frame.size.height * 0.5, right: cellPadding)
        layout.minimumColumnSpacing = cellPadding
        layout.minimumInteritemSpacing = cellPadding
        
        self.collectionView!.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.collectionView!.alwaysBounceVertical = true
    }
    
    private func setupPullToRefresh() {
        if #available(iOS 10.0, *) {
            let refreshControl = UIRefreshControl()
            self.collectionView!.refreshControl = refreshControl
            refreshControl.addTarget(self, action: #selector(refreshGifs(sender:)), for: .valueChanged)
        }
    }
    
    @objc private func refreshGifs(sender: UIRefreshControl) {
        sender.endRefreshing()
        self.viewModel.reset()
        // fade out to make the refresh feel less abrupt
        UIView.animate(withDuration: 0.2, animations: {
            self.view.alpha = 0.0
        }) { (finished) in
            self.view.alpha = 1.0
            self.collectionView!.reloadData()
            self.loadMore(amount: self.initialPageSize)
        }
    }
    
    private func loadMore(amount: Int) {
        self.viewModel.loadData(amount: amount) { delta in
            guard delta > 0 else {
                self.showConnectionError()
                return
            }
            self.collectionView!.performBatchUpdates({ () -> Void in
                var indexPaths: [IndexPath] = []
                let startIndex = self.collectionView!.numberOfItems(inSection: 0)
                let endIndex = startIndex + delta
                for i in startIndex..<endIndex {
                    let indexPath = IndexPath(item: i, section: 0)
                    indexPaths.append(indexPath)
                }
                self.collectionView!.insertItems(at: indexPaths)
                
            }, completion: nil)
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.dataSize
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: gifViewCellIdentifier, for: indexPath) as! GifCollectionViewCell
        cell.backgroundColor = self.appColors.getRandomColor()
        if indexPath.item == self.viewModel.dataSize - 1 {
            self.loadMore(amount: self.pageSize)
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let url = self.viewModel.url(index: indexPath.item) {
            if let cacheData = GifCache.shared.retrieve(url) {
                (cell as! GifCollectionViewCell).displayGif(data: cacheData)
            }
            else {
                self.viewModel.loadGif(index: indexPath.item) { (data) in
                    if let data = data, let cellToUpdate = collectionView.cellForItem(at: indexPath) as? GifCollectionViewCell {
                        cellToUpdate.displayGif(data: data)
                    }
                }
            }
        }
    }
    
    func showConnectionError() {
        let alert = UIAlertController(title: AppText.connectionErrorTitle, message: AppText.connectionErrorBody, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: AppText.ok, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension GifCollectionViewController: CHTCollectionViewDelegateWaterfallLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        let padding = cellPadding * (CGFloat(numColumns) + 1)
        let itemWidth = (self.view.frame.width - padding) / CGFloat(numColumns)
        let itemHeight = self.viewModel.getHeight(for: itemWidth, index: indexPath.item)
        return CGSize(width: itemWidth, height: itemHeight)
    }
}
