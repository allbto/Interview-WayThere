//
//  Wind.swift
//  WayThere
//
//  Created by Allan BARBATO on 5/17/15.
//  Copyright (c) 2015 Allan BARBATO. All rights reserved.
//

import Foundation

public class Wind : AModel
{
    public var degrees : Float
    public var speedMetric : Float
    public var speedImperial : Float
    public var direction : String
    
    public static var metricUnit = "km/h"
    public static var imperialUnit = "mph"
    
    public init(model: CD_Wind)
    {
        degrees = model.degrees?.floatValue ?? 0
        speedImperial = model.speedImperial?.floatValue ?? 0
        speedMetric = model.speedMetric?.floatValue ?? 0
        direction = model.direction ?? ""
    }
}
