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

public typealias SimpleCoordinates = (latitude: Double, longitude: Double)

@objc(Coordinates)
public class Coordinates: AModel {

    @NSManaged public var latitude: NSNumber?
    @NSManaged public var longitude: NSNumber?
    
    public override func fromJson(json: JSON)
    {
        if let lat = json["lat"].double, lon = json["lon"].double {
            latitude = lat
            longitude = lon
        }
    }

}
