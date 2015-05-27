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

public protocol MainDataStoreDelegate
{
    func foundWeatherConfiguration(cities : [City])
    func unableToFindWeatherConfiguration(error : NSError?)

    func foundWeatherForCoordinates(city : City)
    func unableToFindWeatherForCoordinates(error : NSError?)
}

public class MainDataStore
{
    /// Urls
    
    static let BaseUrl = "http://api.openweathermap.org/data/2.5"
    static let WeatherUrl = MainDataStore.BaseUrl + "/weather"
    let SeveralCitiesUrl = MainDataStore.BaseUrl + "/group"
    
    let WunderGeoLookupUrl = "http://api.wunderground.com/api/ce4f06b766a604d5/geolookup/q/:coordinates.json"
    
    /// Vars
    
    public var delegate: MainDataStoreDelegate?
    
    /// Funcs
    
    public init() {}
    
    /**
    Retrieve cities stored in CoreData
    If no city is stored there, it creates some default cities
    
    :returns: List of city stored in CoreData
    */
    static public func retrieveCities() -> [City]
    {
        var cities = City.MR_findByAttribute("isCurrentLocation", withValue: false, andOrderBy: "creationDate", ascending: true) as? [City]

        if cities == nil || cities!.count == 0 {
            var citiesTuples = [
                ("3067696", "Prague"),
                ("2988507", "Paris"),
                ("2990440", "Nice")
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
    
    /**
    Retrieve cities to put on the main screen
    First get them localy and then update the current weather of each cities
    */
    public func retrieveWeatherConfiguration()
    {
        var cities = MainDataStore.retrieveCities()

        Alamofire.request(.GET, SeveralCitiesUrl, parameters: [
            "id" : ",".join(cities.map { $0.remoteId }),
            "units" : "metric"
            ])
            .responseJSON { [unowned self] (req, response, json, error) in
                
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
    
    /**
    Updates of creates a city in Core Data for the current location city of user

    :param: json of the city
    */
    private func _didFindCityWeatherWithCoordinates(json: JSON)
    {
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

    /**
    Find city from Openweathermap API with found city and country
    
    :param: json to parse into city, country
    */
    private func _didFindCityWithCoordinates(json: JSON)
    {
        if let city = json["location"]["city"].string, country = json["location"]["country"].string {
            
            Alamofire.request(.GET, MainDataStore.WeatherUrl, parameters: [
                "q" : "\(city),\(country)",
                "units" : "metric"
                ])
            .responseJSON { [unowned self] (req, _, json, error) in
                
                if (error == nil && json != nil) {
                    var json = JSON(json!)
                    self._didFindCityWeatherWithCoordinates(json)
                }
                else {
                    self.delegate?.unableToFindWeatherForCoordinates(error)
                }
            }
        }
    }
    
    /**
    Finds place from coordinates
    - Check Wundergroup API to get the city and country of the coordinates
    - Request Openweathermap API to get the correct id and weather for the found place
    - Save it all in Core Data
    
    :param: coordinates to find city from
    */
    public func retrieveCurrentWeather(#coordinates: SimpleCoordinates)
    {
        // Using wunderground API to look for the city using coordinates because openweathermap API sucks for this
        Alamofire.request(.GET, WunderGeoLookupUrl.replace(":coordinates", withString: String(format: "%.2f,%.2f", coordinates.latitude, coordinates.longitude)), parameters: nil)
        .responseJSON { [unowned self] (req, _, json, error) in
            
            if (error == nil && json != nil) {
                self._didFindCityWithCoordinates(JSON(json!))
            } else {
                self.delegate?.unableToFindWeatherForCoordinates(error)
            }
        }
    }
}