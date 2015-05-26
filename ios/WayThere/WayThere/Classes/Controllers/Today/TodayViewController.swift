//
//  TodayViewController.swift
//  WayThere
//
//  Created by Allan BARBATO on 5/16/15.
//  Copyright (c) 2015 Allan BARBATO. All rights reserved.
//

import UIKit

class TodayViewController: UIViewController
{
    var index : Int = 0

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var topImageView: UIImageView!
    @IBOutlet weak var currentIconImageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var infoRainPercentLabel: UILabel!
    @IBOutlet weak var infoRainQuantityLabel: UILabel!
    @IBOutlet weak var infoRainPressureLabel: UILabel!
    @IBOutlet weak var infoWindSpeedLabel: UILabel!
    @IBOutlet weak var infoWindDirectionLabel: UILabel!
    @IBOutlet weak var shareSmallScreenButton: UIButton!
    @IBOutlet weak var shareBiggerScreenButton: UIButton!
    
    var dataStore = TodayDataStore()
    
    private func _setLabelsColor(#initial: Bool)
    {
        var color = initial ? UIColor(red:0.2, green:0.2, blue:0.2, alpha:1) /*#333333*/ : UIColor.whiteColor()
        
        self.locationLabel.textColor = color
        self.conditionLabel.textColor = initial ? UIColor(red:0.184, green:0.569, blue:1, alpha:1) /*#2f91ff*/ : color
        self.infoRainPercentLabel.textColor = color
        self.infoRainQuantityLabel.textColor = color
        self.infoRainPressureLabel.textColor = color
        self.infoWindSpeedLabel.textColor = color
        self.infoWindDirectionLabel.textColor = color
    }
    
    private func _setWeatherLabels(#city: City)
    {
        if let weather = city.todayWeather {
            if SettingsDataStore.settingValueForKey(.UnitOfTemperature) as? String == SettingUnitOfTemperature.Celcius.rawValue {
                conditionLabel.text = "\(String(weather.tempCelcius as? Int))°C"
            } else {
                conditionLabel.text = "\(String(weather.tempFahrenheit as? Int))°F"
            }
            conditionLabel.text! += " | \(String(weather.title))"
            infoRainPercentLabel.text = "\(weather.humidity ?? 0)%"
            infoRainPressureLabel.text = "\(weather.pressure ?? 0) hPa"
            infoRainQuantityLabel.text = "\(weather.rainAmount ?? 0) mm"
            topImageView.image = weather.weatherImage()
        }
    }

    private func _setWindLabels(#city: City)
    {
        if let wind = city.wind {
            if SettingsDataStore.settingValueForKey(.UnitOfLenght) as? String == SettingUnitOfLenght.Meters.rawValue {
                infoWindSpeedLabel.text = "\(String(wind.speedMetric)) \(Wind.metricUnit)"
            } else {
                var speed = String(format: "%.2f", wind.speedImperial?.floatValue ?? 0)
                infoWindSpeedLabel.text = "\(speed) \(Wind.imperialUnit)"
            }
            infoWindDirectionLabel.text = wind.direction
        }
    }
    
    var city : City? {
        didSet
        {
            if let sCity = city {
                // Check is allowed to display a backgroundImageView
                if backgroundImageView.image == nil && (SettingsDataStore.settingValueForKey(SettingKey.ClassicMode) as! Bool) == false {
                    backgroundImageView.hidden = false
                    
                    // Check city background image has already been downloaded
                    if let image = self.city?.backgroundImage {
                        self._setLabelsColor(initial: false)
                        self.backgroundImageView.image = image
                    } else {
                        dataStore.retrieveRandomImageUrlFromCity(sCity)
                    }
                } else {
                    self._setLabelsColor(initial: true)
                    backgroundImageView.hidden = true
                }
                
                // Location
                locationLabel.text = "\(String(sCity.name)), \(String(sCity.country))"
                
                // Current location icon
                if sCity.isCurrentLocation?.boolValue == true {
                    currentIconImageView.hidden = false
                } else {
                    currentIconImageView.hidden = true
                }
                
                // Other labels
                _setWeatherLabels(city: sCity)
                _setWindLabels(city: sCity)
            }
        }
    }

    // MARK: - UIViewController

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        shareSmallScreenButton.hidden = !Device.IS_3_5_INCHES_OR_SMALLER()
        shareBiggerScreenButton.hidden = !shareSmallScreenButton.hidden

        // Reset label (I like to see them full when I edit the view)
        locationLabel.text = ""
        conditionLabel.text = ""
        infoRainPercentLabel.text = ""
        infoRainQuantityLabel.text = ""
        infoRainPressureLabel.text = ""
        infoWindSpeedLabel.text = ""
        infoWindDirectionLabel.text = ""
        
        // Config data store
        dataStore.delegate = self
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions

    @IBAction func shareWeatherAction(sender: AnyObject)
    {
        let opening = "Check out today's weather in \(locationLabel.text!) !"
        let weatherStatus = conditionLabel.text!
        
        let activityVC = UIActivityViewController(activityItems: [opening, weatherStatus], applicationActivities: nil)
        
        // New Excluded Activities Code
        activityVC.excludedActivityTypes = [UIActivityTypeAddToReadingList]
        
        self.presentViewController(activityVC, animated: true, completion: nil)
    }
}

extension TodayViewController : TodayDataStoreDelegate
{
    /**
    DataStore delegate method to receive a random image url
    - Checks if it's allowed to display a background image (Settings screen)
    - Fetch the image online with UIImageView.setImageFromUrl()
        - Once found dark effect is applied to image and is assinged to backgroundImageView
        - It is also assign to the city model (not saved to core data of course), just as a way to get the image faster on next load (see top of this class)
        - Labels are put to white to increase the beautyness
    
    :param: imageUrl to download
    */
    func foundRandomImageUrl(imageUrl: String)
    {
        if backgroundImageView.image == nil && (SettingsDataStore.settingValueForKey(SettingKey.ClassicMode) as! Bool) == false {
            backgroundImageView.setImageFromUrl(imageUrl) { [unowned self] (image) in
                self.backgroundImageView.image = image.applyDarkEffect()
                self.city?.backgroundImage = self.backgroundImageView.image
                
                self.backgroundImageView.alpha = 0
                UIView.animateWithDuration(0.2) {
                    self._setLabelsColor(initial: false)
                    self.backgroundImageView.alpha = 1
                }
            }
        }
    }
    
    func unableToFindRandomImageUrl(error: NSError?)
    {
        // Do nothing, it's ok to not have a background image
    }
}

