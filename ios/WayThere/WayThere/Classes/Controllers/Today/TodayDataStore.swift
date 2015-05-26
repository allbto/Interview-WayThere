//
//  TodayDataStore.swift
//  WayThere
//
//  Created by Allan BARBATO on 5/25/15.
//  Copyright (c) 2015 Allan BARBATO. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol TodayDataStoreDelegate
{
    func foundRandomImageUrl(imageUrl: String)
    func unableToFindRandomImageUrl(error : NSError?)
}

public class TodayDataStore
{
    /// Vars
    
    var delegate: TodayDataStoreDelegate?
    
    let FlickrApiKey = "3aaa020c958965016924a8b0c4bed415"
    
    // Url
    
    let FindImagesUrl = "https://api.flickr.com/services/rest/"
    
    /// Funcs
    
    public init() {}
    
    private func _getRandomUrlFromLocalImages(#city: City) -> String?
    {
        if let localImages = CityPhoto.MR_findByAttribute("cityId", withValue: city.remoteId) as? [CityPhoto] where localImages.count > 0 {
            var random = Int.random(min: 0, max: localImages.count - 1)
            
            if let url = localImages[random].url {
                return url
            }
        }
        return nil
    }
    
    private func _saveLocalImagesJSON(images: JSON, forCity: City)
    {
        for (index, (sIndex : String, photoJson : JSON)) in enumerate(images) {
            let farm = photoJson["farm"].stringValue, server = photoJson["server"].stringValue, id = photoJson["id"].stringValue, secret = photoJson["secret"].stringValue
            var imageUrl = "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_b.jpg"
            
            if let cityPhoto = CityPhoto.MR_createEntity() as? CityPhoto {
                cityPhoto.url = imageUrl
                cityPhoto.cityId = forCity.remoteId
            }
        }
        CoreDataHelper.saveAndWait()
    }

    public func retrieveRandomImageUrlFromCity(city: City)
    {
        // Try to get local images url
        if let url = _getRandomUrlFromLocalImages(city: city) {
            delegate?.foundRandomImageUrl(url)
            return
        }
        
        // Not found request Flickr
        Alamofire.request(.POST, FindImagesUrl, parameters: [
            "method" : "flickr.photos.search",
            "api_key" : FlickrApiKey,
            "text" : String(city.name),
            "sort" : "relevance",
            "accuracy" : "11",
            "safe_search" : "1",
            "content_type": "1",
            "format" : "json",
            "nojsoncallback" : "1"
            ])
            .responseJSON { [unowned self] (request, response, json, error) -> Void in
                
                if (error == nil && json != nil) {
                    var json = JSON(json!)
                    
                    self._saveLocalImagesJSON(json["photos"]["photo"], forCity: city)
                    self.delegate?.foundRandomImageUrl(self._getRandomUrlFromLocalImages(city: city) ?? "")
                } else {
                    self.delegate?.unableToFindRandomImageUrl(error)
                }
        }
    }
}

