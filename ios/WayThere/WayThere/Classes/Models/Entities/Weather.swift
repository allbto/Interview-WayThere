//
//  Weather.swift
//  WayThere
//
//  Created by Allan BARBATO on 5/16/15.
//  Copyright (c) 2015 Allan BARBATO. All rights reserved.
//

import Foundation
import SwiftyJSON

public class Weather: AModel
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
}