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

@objc(Weather)
public class Weather: AModel {

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

    public override func fromJson(json: JSON)
    {
        self.temp = json["main"]["temp"].float ?? 0
        self.pressure = json["main"]["pressure"].float
        self.humidity = json["main"]["humidity"].float
        self.rainAmount = json["rain"]["3h"].float
        self.title = json["weather"][0]["main"].string
        self.descriptionText = json["weather"][0]["description"].string
    }
    
    public func weatherImage() -> UIImage?
    {
        var image : UIImage? = nil
        
        if let title = self.title {
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

            image = UIImage(named: formatedTitle)
        }
        
        if image == nil {
            image = UIImage(named: "Unknown")
        }
        
        return image
    }
}
