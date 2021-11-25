//
//  ImageCacheService.swift
//  The Photo App
//
//  Created by Aman on 25/11/21.
//

import Foundation
import UIKit

class ImageCacheService{
    
    static var imageCache = [String:UIImage]()
    
    
    static func saveImage(url:String?, image:UIImage?) {
//        Check against nill
        if url == nil || image == nil {
            return
        }
        
//        Save the image
        imageCache[url!] = image!
    }
    
    
    static func getImage(url:String?) -> UIImage? {
//        Check that url isn't nil
        if url == nil {
            return nil
        }
//        Check the image cache for the url
        return imageCache[url!]
    }
    
}
