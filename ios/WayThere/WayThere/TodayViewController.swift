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
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var infoRainPercentLabel: UILabel!
    @IBOutlet weak var infoRainQuantityLabel: UILabel!
    @IBOutlet weak var infoRainPressureLabel: UILabel!
    @IBOutlet weak var infoWindSpeedLabel: UILabel!
    @IBOutlet weak var infoWindDirectionLabel: UILabel!
    
    var weather : Weather? {
        didSet
        {
            if let sWeather = weather {
                // Do view changes here
            }
        }
    }

    // MARK: - UIViewController

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions

    @IBAction func shareWeatherAction(sender: AnyObject)
    {
        
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
