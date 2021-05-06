//
//  ImageDownloader.swift
//  interview
//
//  Created by macbook on 6.05.2021.
//

import Foundation
import UIKit

class ImageDownloader: NSObject {
    
    private static var imageQueue = OperationQueue()
    private static var imageCache = NSCache<AnyObject, AnyObject>()
    
    class func downloadImageWithUrl(imageUrl: String, cacheKey: String, completionBlock: @escaping (_ image: UIImage?)-> Void) {
        
        let downloadedImage = imageCache.object(forKey: cacheKey as AnyObject)
        if let  _ = downloadedImage as? UIImage {
            print("Image get from cache \(cacheKey)")
            completionBlock(downloadedImage as? UIImage)
        } else {
            let blockOperation = BlockOperation()
            blockOperation.addExecutionBlock({
                let url = URL(string: imageUrl)
                do {
                    let data = try Data(contentsOf: url!)
                    let newImage = UIImage(data: data)
                    if newImage != nil {
                        self.imageCache.setObject(newImage!, forKey: cacheKey as AnyObject)
                        self.runOnMainThread {
                            completionBlock(newImage)
                        }
                    } else {
                        completionBlock(nil)
                    }
                } catch {
                    completionBlock(nil)
                }
            })
            self.imageQueue.addOperation(blockOperation)
            blockOperation.completionBlock = {
                print("Image downloaded \(cacheKey)")
            }
        }
    }
}

extension ImageDownloader {
    fileprivate class func runOnMainThread(block:@escaping ()->Void) {
        if Thread.isMainThread {
            block()
        } else {
            let mainQueue = OperationQueue.main
            mainQueue.addOperation({
                block()
            })
        }
    }
}
