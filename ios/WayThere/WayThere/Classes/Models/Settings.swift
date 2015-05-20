//
//  Settings.swift
//  WayThere
//
//  Created by Allan BARBATO on 5/20/15.
//  Copyright (c) 2015 Allan BARBATO. All rights reserved.
//

import Foundation

enum SettingKey : String
{
    case UnitOfLenght = "unit_of_lenght"
    case UnitOfTemperature = "unit_of_temperature"
    case STRVMode = "strv_mode"
    case GIFMode = "gif_mode"
    
    static let defaults : [String : AnyObject] = [
            SettingKey.UnitOfLenght.rawValue : SettingUnitOfLenght.Meters.rawValue,
            SettingKey.UnitOfTemperature.rawValue : SettingUnitOfTemperature.Celcius.rawValue,
            SettingKey.STRVMode.rawValue : false,
            SettingKey.GIFMode.rawValue : false,
        ]
}

enum SettingUnitOfLenght : String
{
    case Meters = "Meters"
    case Imperial = "Imperial"
    
    static let allRawValues = [Meters, Imperial].map({ $0.rawValue })
}

enum SettingUnitOfTemperature : String
{
    case Celcius = "Celcius"
    case Fahrenheit = "Fahrenheit"

    static let allRawValues = [Celcius, Fahrenheit].map({ $0.rawValue })
}