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
import MagicalRecord

protocol MainDataStoreDelegate
{
    func foundWeatherConfiguration(cities : [City])
    func unableToFindWeatherConfiguration(error : NSError?)

    func foundWeatherForCoordinates(city : City)
    func unableToFindWeatherForCoordinates(error : NSError?)
}

class MainDataStore
{
    /// Urls
    
    static let BaseUrl = "http://api.openweathermap.org/data/2.5"
    static let WeatherUrl = MainDataStore.BaseUrl + "/weather"
    let SeveralCitiesUrl = MainDataStore.BaseUrl + "/group"
    
    /// Vars
    
    var delegate: MainDataStoreDelegate?
    
    /**
    Retrieve cities stored in CoreData
    If no city is stored there, it creates some default cities
    
    :returns: List of city stored in CoreData
    */
    static func retrieveCities() -> [City]
    {
        var cities = City.MR_findAll() as? [City]

        if cities == nil || cities!.count == 0 {
            var citiesTuples = [
                ("3067696", "Prague"),
                ("2990440", "Nice"),
                ("2988507", "Paris")
            ]

            cities = []
            for (id, name) in citiesTuples {
                if var city = City.MR_createEntity() as? City {
                    city.remoteId = id
                    city.name = name
                    cities!.append(city)
                }
            }

            CoreDataHelper.saveAndWait()
        }
        return cities!
    }
    
    func retrieveWeatherConfiguration()
    {
        var cities = MainDataStore.retrieveCities()

        Alamofire.request(.GET, SeveralCitiesUrl, parameters: [
            "id" : ",".join(cities.map { $0.remoteId }),
            "units" : "metric"
            ])
            .responseJSON { [unowned self] (req, response, json, error) in
                println(req, json, error)
                
                if (error == nil && json != nil) {
                    var json = JSON(json!)
                    
                    for (index, (sIndex : String, city : JSON)) in enumerate(json["list"]) {
                        cities[index].fromJson(city)
                    }
                    CoreDataHelper.saveAndWait()
                    self.delegate?.foundWeatherConfiguration(cities)
                } else {
                    self.delegate?.unableToFindWeatherConfiguration(error)
                }
        }
    }
    
    func retrieveCurrentWeather(#coordinates: SimpleCoordinates)
    {
        Alamofire.request(.GET, MainDataStore.WeatherUrl, parameters: [
            "lat" : "\(coordinates.latitude)",
            "lon" : "\(coordinates.longitude)",
            "units" : "metric"
            ])
            .responseJSON { [unowned self] (req, _, json, error) in
                println(req, json, error)
                
                if (error == nil && json != nil) {
                    var json = JSON(json!)
                    
                    if let city = City.MR_findFirstByAttribute("isCurrentLocation", withValue: true) as? City {
                        city.fromJson(json)
                        CoreDataHelper.saveAndWait()
                        self.delegate?.foundWeatherForCoordinates(city)
                    }
                    else if let city = City.MR_createEntity() as? City {
                        city.fromJson(json)
                        city.isCurrentLocation = true
                        CoreDataHelper.saveAndWait()
                        self.delegate?.foundWeatherForCoordinates(city)
                    } else {
                        self.delegate?.unableToFindWeatherForCoordinates(nil)
                    }
                }
                else {
                    self.delegate?.unableToFindWeatherForCoordinates(error)
                }
        }
    }
    
}