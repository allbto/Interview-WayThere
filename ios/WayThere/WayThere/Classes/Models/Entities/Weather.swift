//
//  Weather.swift
//  WayThere
//
//  Created by Allan BARBATO on 5/16/15.
//  Copyright (c) 2015 Allan BARBATO. All rights reserved.
//

import Foundation
import SwiftyJSON

public class Weather: AEntity
{
    public var title: String
    public var descriptionText: String
    public var tempCelcius: Int
    public var tempFahrenheit : Int
    public var pressure: Int
    public var humidity: Int
    public var rainAmount: Float

    public init(model: CD_Weather)
    {
        title = model.title ?? ""
        descriptionText = model.descriptionText ?? ""
        tempCelcius = model.tempCelcius?.integerValue ?? 0
        tempFahrenheit = model.tempFahrenheit?.integerValue ?? 0
        pressure = model.pressure?.integerValue ?? 0
        humidity = model.humidity?.integerValue ?? 0
        rainAmount = model.rainAmount?.floatValue ?? 0
    }
    
    public func weatherImage() -> UIImage?
    {
        let formatedTitle : String
        
        switch title {
        case "Clouds":
            formatedTitle = "Cloudy"
        case "Clear":
            formatedTitle = "Sunny"
        case "Rain", "Drizzle":
            formatedTitle = "Rainy"
        case "Extreme":
            formatedTitle = "Thunderstorm"
        case "Atmosphere":
            formatedTitle = "Windy"
        default:
            formatedTitle = title
        }

        var image = UIImage(named: formatedTitle)
        
        if image == nil {
            image = UIImage(named: "Unknown")
        }
        
        return image
    }
}