//
//  CitiesDataStore.swift
//  WayThere
//
//  Created by Allan BARBATO on 5/17/15.
//  Copyright (c) 2015 Allan BARBATO. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol CitiesDataStoreDelegate
{
    func foundWeatherConfiguration(cities : [City])
    func unableToFindWeatherConfiguration(error: NSError)
    func foundCitiesForQuery(cities : [SimpleCity])
    func unableToFindCitiesForQuery(error: NSError?)
    
    func didSaveNewCity(city: City)
    func didRemoveCity(city: City)
    
    func foundWeatherForecastForCity(weathers: [Weather])
    func unableToFindForecastForCity(error: NSError?)
}

class CitiesDataStore
{
    /// Vars
    
    let CountOfQueryResult = 5
    let NumberOfDaysToFetch = 7
    
    var delegate: CitiesDataStoreDelegate?
    var isQuerying = false
    var lastQuery : String?
    
    // Url
    
    let FindCitiesUrl = MainDataStore.BaseUrl + "/find"
    let FetchCityUrl = MainDataStore.BaseUrl + "/forecast/daily"
    
    /// Funcs
    
    func retrieveWeatherConfiguration()
    {
        delegate?.foundWeatherConfiguration(MainDataStore.retrieveCities())
    }
    
    /**
    Fetch api to find list of cities for given query string
    Has a block system allowing to delay the requests if one is already running
    For example, an user will write the name of the city, with a mistake, go back fix it then write the rest of name.
    To prevent a request to be sent everytime a letter is written, the func doesn't a request to be launched if there is already one in process
    In addition, the lastest query is saved and a request is sent when the first one is complete
    
    :param: query E.g. "Prag" if you want to look for Prague or similar (there is nothing similar to Prague ;) )
    */
    func retrieveCitiesForQuery(query : String)
    {
        if isQuerying {
            lastQuery = query
            return
        }

        isQuerying = true
        Alamofire.request(.GET, FindCitiesUrl, parameters: [
            "q" : query,
            "type" : "like",
            "sort" : "population",
            "cnt" : String(CountOfQueryResult)
            ])
            .responseJSON { [unowned self] (req, response, json, error) in

                // Call another query if there is a 'waiting list'
                if let query = self.lastQuery {
                    self.lastQuery = nil
                    self.isQuerying = false
                    self.retrieveCitiesForQuery(query)
                }
                else if (error == nil && json != nil) {
                    var json = JSON(json!)
                    var cities = [SimpleCity]()
                    
                    for (index, (sIndex : String, cityJSON : JSON)) in enumerate(json["list"]) {
                        if let id = cityJSON["id"].int, name = cityJSON["name"].string, country = cityJSON["sys"]["country"].string {
                            cities.append(SimpleCity(String(id), name, country))
                        }
                    }
                    self.delegate?.foundCitiesForQuery(cities)
                } else {
                    self.delegate?.unableToFindCitiesForQuery(error)
                }
                self.isQuerying = false
            }
    }
    
    /**
    Save city to CoreData
    Fetch the latest weather report for the city before saving it to CoreData
    If request fails the city is still saved, the forecast can be retrieved later on
    
    :param: city to save
    */
    func saveCity(city : SimpleCity)
    {
        // Preventing user from including 2 times the same city
        if let cityEntity = City.MR_findFirstByAttribute("remoteId", withValue: city.id) as? City {
            return
        }

        Alamofire.request(.GET, MainDataStore.WeatherUrl, parameters: [
            "id" : city.id,
            "units" : "metric"
            ])
            .responseJSON { [unowned self] (req, response, json, error) in
                
                if let cityEntity = City.MR_createEntity() as? City {

                    cityEntity.remoteId = city.id

                    if (error == nil && json != nil) {
                        var json = JSON(json!)
                    
                        cityEntity.fromJson(json)
                    } else {
                        
                        cityEntity.name = city.name
                        cityEntity.country = city.country
                    }
                    CoreDataHelper.saveAndWait()
                    self.delegate?.didSaveNewCity(cityEntity)
                }
            }
    }

    /**
    Remove city from CoreData
    Also remove related photo (CityPhoto, see TodayDataStore)
    Also remove related weathers (see under)
    
    :param: city to remove
    */
    func removeCity(city : City)
    {
        var cityId = city.remoteId
        
        CityPhoto.MR_findByAttribute("cityId", withValue: cityId).map { $0.MR_deleteEntity() }
        Weather.MR_findByAttribute("cityId", withValue: cityId).map { $0.MR_deleteEntity() }
        city.MR_deleteEntity()
        
        CoreDataHelper.saveAndWait()
        self.delegate?.didRemoveCity(city)
    }
    
    /**
    Get local stored weather for city only if weathers were saved on the same day (after 1 day needs to be reloaded)
    Otherwise they are deleted from Core Data
    
    :param: city to get weathers from
    
    :returns: A weathers array corresponding to the latest weathers for the city or nil
    */
    private func _getWeatherForCity(city: City) -> [Weather]?
    {
        if let localWeathers = Weather.MR_findByAttribute("cityId", withValue: city.remoteId, andOrderBy: "creationDate", ascending: true) as? [Weather] where localWeathers.count > 0 {
            if localWeathers[0].creationDate.dateComposents(unit: .CalendarUnitDay, toDate: NSDate()).day == 0 {
                return localWeathers
            } else {
                localWeathers.map { $0.MR_deleteEntity() }
                CoreDataHelper.saveAndWait()
            }
        }
        return nil

    }
    
    private func _saveWeathersJSON(weathers: JSON, forCity city: City)
    {
        for (index, (sIndex : String, cityJSON : JSON)) in enumerate(weathers) {
            if let title = cityJSON["weather"][0]["main"].string, timeStamp = cityJSON["dt"].int, temp = cityJSON["temp"]["day"].double {
                var date = NSDate(timeIntervalSince1970: Double(timeStamp))
                var formater = NSDateFormatter()
                
                formater.dateFormat = "EEEE"

                if let weather = Weather.MR_createEntity() as? Weather {
                    weather.title = title
                    weather.day = formater.stringFromDate(date)
                    weather.temp = Float(temp)
                    weather.cityId = city.remoteId
                }
            }
        }
        CoreDataHelper.saveAndWait()
    }
    
    /**
    Retrieve weather forecast for NumberOfDaysToFetch days
    
    :param: city to fetch weather from
    */
    func retrieveWeatherForecastForCity(city: City)
    {
        // Try to get local weathers for this city
        if let weathers = _getWeatherForCity(city) {
            delegate?.foundWeatherForecastForCity(weathers)
            return
        }
        
        // Not found requesting API
        Alamofire.request(.GET, FetchCityUrl, parameters: [
            "id"  : city.remoteId,
            "cnt" : NumberOfDaysToFetch,
            "units": "metric"
            ])
            .responseJSON { [unowned self] (req, response, json, error) in
                
                if (error == nil && json != nil) {
                    var json = JSON(json!)
                    
                    self._saveWeathersJSON(json["list"], forCity: city)
                    self.delegate?.foundWeatherForecastForCity(self._getWeatherForCity(city) ?? [])
                } else {
                    self.delegate?.unableToFindForecastForCity(error)
                }
            }
    }
}


