//
//  MainDataStore.swift
//  WayThere
//
//  Created by Allan BARBATO on 5/16/15.
//  Copyright (c) 2015 Allan BARBATO. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol MainDataStoreDelegate
{
    func foundWeatherConfiguration(cities : [City])
}

class MainDataStore
{
    /// Urls
    
    let BaseUrl = "http://api.openweathermap.org/data/2.5"
    let SeveralCitiesUrl = "/group"
    
    /// Vars
    
    var delegate: MainDataStoreDelegate?
    var defaultCities : [City]
    
    init()
    {
        defaultCities = [
            City(id: "3067696", name: "Prague"),
            City(id: "2990440", name: "Nice"),
            City(id: "2988507", name: "Paris")
        ]
    }
    
    func retrieveWeatherConfiguration()
    {
        // TODO: Use CoreData
        var cities = defaultCities

        Alamofire.request(.GET, BaseUrl + SeveralCitiesUrl, parameters: [
            "id" : ",".join(cities.map { $0.id }),
            "units" : "metric"
            ])
            .responseJSON { [unowned self] (req, _, json, _) in
                println(req, json)
                var json = JSON(json!)
                
                for (index, (sIndex : String, city : JSON)) in enumerate(json["list"]) {
                    cities[index].fromJson(city)
                }
                self.delegate?.foundWeatherConfiguration(cities)
        }
    }
    
    
}