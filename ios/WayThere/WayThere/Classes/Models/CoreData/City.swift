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

public typealias SimpleCity = (id: String, name:String, country: String)

@objc(City)
public class City: AModel {

    @NSManaged public var remoteId: String
    @NSManaged public var country: String?
    @NSManaged public var isCurrentLocation: NSNumber?
    @NSManaged public var name: String?
    @NSManaged public var coordinates: Coordinates?
    @NSManaged public var wind: Wind?
    @NSManaged public var todayWeather: Weather?
    
    public override func fromJson(json: JSON)
    {
        if let id = json["id"].int {
            remoteId = String(id)
        } else {
            remoteId = remoteId ?? ""
        }

        name = json["name"].string
        country = json["sys"]["country"].string
        
        coordinates = Coordinates.MR_createInContext(self.managedObjectContext) as? Coordinates
        coordinates?.fromJson(json["coord"])

        wind = Wind.MR_createEntity() as? Wind
        wind?.fromJson(json["wind"])
        
        todayWeather = Weather.MR_createInContext(self.managedObjectContext) as? Weather
        todayWeather?.fromJson(json)
    }
}
