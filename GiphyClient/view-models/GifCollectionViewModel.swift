//
//  GifCollectionViewModel.swift
//  GiphyClient
//
//  Created by Scott Doerrfeld on 8/30/17.
//  Copyright © 2017 Scott Doerrfeld. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class GifCollectionViewModel {
    private let loadDataQueue = OperationQueue()
    private var gifs: [Gif] = []
    private var pendingUrls: [String] = []
    
    var dataSize: Int {
        return self.gifs.count
    }
    
    var isLoadDataPending: Bool {
        return self.loadDataQueue.operationCount > 0
    }
    
    func loadData(amount: Int, completion: @escaping (Int) -> Void) {
        guard !self.isLoadDataPending else { return }
        
        print("=== Loading \(amount) gifs...")
        
        DispatchQueue.global(qos: .userInitiated).async {
            var operations: [LoadDataOperation] = []
            for _ in 1...amount {
                operations.append(LoadDataOperation())
            }
            self.loadDataQueue.addOperations(operations, waitUntilFinished: true)
            var delta = 0
            for operation in operations {
                if let randomGif = operation.gif, let gifUrl = randomGif.url {
                    print("   ", gifUrl)
                    self.gifs.append(randomGif)
                    delta += 1
                }
            }
            print("    Loading complete!")
            DispatchQueue.main.async {
                completion(delta)
            }
        }
    }
    
    func loadGif(index: Int, completion: @escaping (Data?, String?) -> Void) {
        let gif = self.gifs[index]
        guard let gifUrl = gif.url, !self.pendingUrls.contains(gifUrl) else {
            completion(nil, nil)
            return
        }
        if let gifData = GifCache.shared.retrieve(gifUrl) {
            //print("<<< found cache for index \(index)")
            completion(gifData, gifUrl)
            return
        }
        //print(">>> loading \(gifUrl) for index \(index)")
        self.pendingUrls.append(gifUrl)
        Alamofire.request(gifUrl).responseData { response in
            //print("<<< loading success for index \(index)")
            if let pendingIndex = self.pendingUrls.index(of: gifUrl) {
                self.pendingUrls.remove(at: pendingIndex)
            }
            GifCache.shared.store(gifUrl, data: response.data)
            DispatchQueue.main.async {
                completion(response.data, gifUrl)
            }
        }
    }
    
    func getHeight(for width: CGFloat, index: Int) -> CGFloat {
        let gif = self.gifs[index]
        guard let gifWidth = gif.width else { return width }
        guard let gifHeight = gif.height else { return width }
        return width * (gifHeight / gifWidth)
    }
    
    func url(index: Int) -> String? {
        guard self.dataSize > index else { return nil }
        return self.gifs[index].url
    }
    
    func reset() {
        self.loadDataQueue.cancelAllOperations()
        self.gifs.removeAll()
        GifCache.shared.purge()
    }
}
