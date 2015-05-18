//
//  CD_Coordinates.swift
//  
//
//  Created by Allan BARBATO on 5/18/15.
//
//

import Foundation
import SwiftyJSON
import CoreData

@objc(CD_Coordinates)
public class CD_Coordinates: CD_AModel {

    @NSManaged public var latitude: NSNumber?
    @NSManaged public var longitude: NSNumber?
    
    public func fromJson(json: JSON)
    {
        if let lat = json["lat"].double, lon = json["lon"].double {
            latitude = lat
            longitude = lon
        }
    }

}
