//
//  Weather.swift
//  WayThere
//
//  Created by Allan BARBATO on 5/16/15.
//  Copyright (c) 2015 Allan BARBATO. All rights reserved.
//

import Foundation
import SwiftyJSON

typealias Coordinates = (latitude: Double, longitude: Double)
typealias Weather = (temp: Int, pressure: Int, humidity: Int, rainAmount: Float, title: String, description : String)

class Wind {
    var degrees : Float
    var speedMetric : Float
    var speedImperial : Float
    var direction : String
    
    static var metricUnit = "km/h"
    static var imperialUnit = "mph"
    
    static let windDirections = ["N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE",
    "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW"]
    
    init(degrees : Float, speed: Float)
    {
        self.degrees = degrees
        self.speedMetric = speed
        self.speedImperial = speed / 1.609 // 1 mph = 1.609 km/h

        // http://stackoverflow.com/questions/13220367/cardinal-wind-direction-from-degrees
        var i = (degrees + 11.25) / 22.5;
        self.direction = Wind.windDirections[Int(i % 16)]
    }
}

class City
{
    var id : String
    var name : String?
    var country : String?
    var isCurrentLocation : Bool = false
    var coordinates : Coordinates?
    var wind : Wind?
    var todayWeather : Weather?
    
    init(id: String, name: String)
    {
        self.id = id
        self.name = name
    }
    
    init(id: String, json: JSON)
    {
        self.id = id
        self.fromJson(json)
    }
    
    func fromJson(json: JSON)
    {
        name = json["name"].string
        country = json["sys"]["country"].string
        
        if let lat = json["coord"]["lat"].double, lon = json["coord"]["lon"].double {
            coordinates = Coordinates(latitude: lat, longitude: lon)
        }
        if let deg = json["wind"]["deg"].float, speed = json["wind"]["speed"].float {
            wind = Wind(degrees: deg, speed: speed)
        }
        
        // Not using if let to use default values
        var temp = json["main"]["temp"].int ?? 0
        var pressure = json["main"]["pressure"].int ?? 0
        var humidity = json["main"]["humidity"].int ?? 0
        var rainAmount = json["rain"]["3h"].float ?? 0
        var title = json["weather"][0]["main"].string ?? ""
        var description = json["weather"][0]["description"].string ?? ""
        todayWeather = Weather(temp: temp, pressure: pressure, humidity: humidity, rainAmount: rainAmount, title: title, description: description)
    }
}

