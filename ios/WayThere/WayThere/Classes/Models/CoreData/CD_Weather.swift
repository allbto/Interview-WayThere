//
//  CD_Weather.swift
//  
//
//  Created by Allan BARBATO on 5/18/15.
//
//

import Foundation
import SwiftyJSON
import CoreData

@objc(CD_Weather)
public class CD_Weather: CD_AModel {

    @NSManaged public var title: String?
    @NSManaged public var descriptionText: String?
    @NSManaged public var humidity: NSNumber?
    @NSManaged public var pressure: NSNumber?
    @NSManaged public var rainAmount: NSNumber?
    @NSManaged public var tempCelcius: NSNumber?
    @NSManaged public var tempFahrenheit: NSNumber?
    
    public var temp : Float {
        get { return tempCelcius?.floatValue ?? 0 }
        set {
            tempCelcius = newValue
            tempFahrenheit = newValue * (9 / 5) + 32 // °C  x  9/5 + 32 = °F
        }
    }

    public func fromJson(json: JSON)
    {
        self.temp = json["main"]["temp"].float ?? 0
        self.pressure = json["main"]["pressure"].float
        self.humidity = json["main"]["humidity"].float
        self.rainAmount = json["rain"]["3h"].float
        self.title = json["weather"][0]["main"].string
        self.descriptionText = json["weather"][0]["description"].string
    }
}
