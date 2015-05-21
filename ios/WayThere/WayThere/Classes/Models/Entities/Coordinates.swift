//
//  Coordinates.swift
//  WayThere
//
//  Created by Allan BARBATO on 5/17/15.
//  Copyright (c) 2015 Allan BARBATO. All rights reserved.
//

import Foundation

public class Coordinates: AEntity
{
    public var latitude: Double
    public var longitude: Double
    
    public init(latitude: Double, longitude: Double)
    {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    public init(model: CD_Coordinates)
    {
        latitude = model.latitude?.doubleValue ?? 0
        longitude = model.longitude?.doubleValue ?? 0
    }
}