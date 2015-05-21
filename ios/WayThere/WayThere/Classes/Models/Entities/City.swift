//
//  City.swift
//  WayThere
//
//  Created by Allan BARBATO on 5/17/15.
//  Copyright (c) 2015 Allan BARBATO. All rights reserved.
//

import Foundation
import SwiftyJSON

public class City : AEntity
{
    public var remoteId: String
    public var country: String?
    public var isCurrentLocation: Bool
    public var name: String?
    public var coordinates: Coordinates?
    public var wind: Wind?
    public var todayWeather: Weather?
    
    public init(id: String)
    {
        self.remoteId = id
        self.isCurrentLocation = false
        
        super.init()
    }
    
    public init(model: CD_City)
    {
        remoteId = model.remoteId
        country = model.country
        isCurrentLocation = model.isCurrentLocation?.boolValue ?? false
        name = model.name
        
        if let coordinates = model.coordinates {
            self.coordinates = Coordinates(model: coordinates)
        }
        if let wind = model.wind {
            self.wind = Wind(model: wind)
        }
        if let weather = model.todayWeather {
            self.todayWeather = Weather(model: weather)
        }
    }
}
