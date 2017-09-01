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
    private let gifService: GifService
    private var isLoadDataPending = false
    private var gifs: [Gif] = []
    private var pendingUrls: [String] = []
    private var cache: [String: Data] = [:]
    private var resetFlag = false
    private var onReset: (() -> Void)?
    
    var dataSize: Int {
        return self.gifs.count
    }
    
    init(gifService: GifService) {
        self.gifService = gifService
    }
    
    func loadData(amount: Int, completion: @escaping (Bool) -> Void) {
        guard !self.isLoadDataPending else {
            completion(false)
            return
        }
        self.isLoadDataPending = true
        
        print("=== Loading \(amount) gifs...")
        
        DispatchQueue.global(qos: .userInitiated).async {
            let loadGroup = DispatchGroup()
            for _ in 1...amount {
                loadGroup.enter()
                self.gifService.getRandomGif() { (gif) in
                    if let randomGif = gif {
                        print("   ", randomGif.url ?? "Gif data failed to load")
                        self.gifs.append(randomGif)
                    }
                    loadGroup.leave()
                }
            }
            loadGroup.wait()
            print("    Loading complete!")
            self.isLoadDataPending = false
            DispatchQueue.main.async {
                if self.resetFlag {
                    completion(false)
                    self.performReset()
                }
                else {
                    completion(true)
                }
            }
        }
    }
    
    func loadGif(index: Int, completion: @escaping (Data?, String?) -> Void) {
        let gif = self.gifs[index]
        guard let gifUrl = gif.url, !self.pendingUrls.contains(gifUrl) else {
            completion(nil, nil)
            return
        }
        if let gifData = self.cache[gifUrl] {
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
            self.cache[gifUrl] = response.data
            completion(response.data, gifUrl)
        }
    }
    
    func getHeight(width: CGFloat, index: Int) -> CGFloat {
        let gif = self.gifs[index]
        guard let gifWidth = gif.width else { return width }
        guard let gifHeight = gif.height else { return width }
        return width * (gifHeight / gifWidth)
    }
    
    func url(index: Int) -> String? {
        guard self.dataSize > index else { return nil }
        return self.gifs[index].url
    }
    
    func reset(completion: @escaping () -> Void) {
        guard !self.resetFlag else { return }
        self.onReset = completion
        if self.isLoadDataPending {
            self.resetFlag = true
        }
        else {
            self.performReset()
        }
    }
    
    private func performReset() {
        self.resetFlag = false
        self.gifs.removeAll()
        self.onReset?()
    }
}
