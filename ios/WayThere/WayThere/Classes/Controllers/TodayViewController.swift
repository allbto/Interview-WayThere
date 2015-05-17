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
    
    var city : City? {
        didSet
        {
            if let sCity = city {
                locationLabel.text = "\(sCity.name!), \(sCity.country!)"
                
                if sCity.isCurrentLocation {
                    // Icon positioning
                    var f = locationLabel.sizeThatFits(locationLabel.frame.size)
                    currentIconImageView.frame.origin.x += f.width + 4;
                    currentIconImageView.center.y = locationLabel.center.y
                } else {
                    currentIconImageView.hidden = true
                }
                
                if let weather = sCity.todayWeather {
                    conditionLabel.text = "\(weather.temp)°C | \(weather.title)"
                    infoRainPercentLabel.text = "\(weather.humidity)%"
                    infoRainPressureLabel.text = "\(weather.pressure) hPa"
                    infoRainQuantityLabel.text = "\(weather.rainAmount ?? 0) mm"
                }

                if let wind = sCity.wind {
                    infoWindSpeedLabel.text = "\(wind.speedMetric) \(Wind.metricUnit)"
                    infoWindDirectionLabel.text = wind.direction
                }
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
        
        //New Excluded Activities Code
        activityVC.excludedActivityTypes = [UIActivityTypeAddToReadingList]
        //
        
        self.presentViewController(activityVC, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
