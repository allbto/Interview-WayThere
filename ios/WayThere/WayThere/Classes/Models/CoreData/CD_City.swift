//
//  CD_City.swift
//  
//
//  Created by Allan BARBATO on 5/18/15.
//
//

import Foundation
import CoreData
import SwiftyJSON

@objc(CD_City)
public class CD_City: CD_AModel {

    @NSManaged public var remoteId: String
    @NSManaged public var country: String?
    @NSManaged public var isCurrentLocation: NSNumber?
    @NSManaged public var name: String?
    @NSManaged public var coordinates: CD_Coordinates?
    @NSManaged public var wind: CD_Wind?
    @NSManaged public var todayWeather: CD_Weather?
    
    public func fromJson(json: JSON)
    {
        name = json["name"].string
        country = json["sys"]["country"].string
        
        coordinates = CD_Coordinates.MR_createEntity() as? CD_Coordinates
        coordinates?.fromJson(json["coord"])

        wind = CD_Wind.MR_createEntity() as? CD_Wind
        wind?.fromJson(json["wind"])
        
        todayWeather = CD_Weather.MR_createEntity() as? CD_Weather
        todayWeather?.fromJson(json)
    }
}
