//
//  UIImageView+FromUrl.swift
//  WayThere
//
//  Created by Allan BARBATO on 5/26/15.
//  Copyright (c) 2015 Allan BARBATO. All rights reserved.
//

import Foundation
import UIKit

func getDataFromUrl(url:String, completion: ((data: NSData?) -> Void)) {
    NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: url)!) { (data, response, error) in
        completion(data: NSData(data: data))
        }.resume()
}

extension UIImageView
{
    /**
    Download image from url and set image to self or send image to completion if completion not nil
    
    :param: url        to download image from
    :param: completion optional completion block
    */
    func setImageFromUrl(url:String, completion: (UIImage -> Void)? = nil){
        getDataFromUrl(url) { data in
            dispatch_async(dispatch_get_main_queue()) {
                var image = UIImage(data: data!)

                if let complete = completion, img = image {
                    complete(img)
                } else {
                    self.contentMode = UIViewContentMode.ScaleAspectFill
                    self.image = image
                }
            }
        }
    }
}