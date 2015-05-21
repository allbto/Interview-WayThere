//
//  CityWeatherTableViewCell.swift
//  WayThere
//
//  Created by Allan BARBATO on 5/20/15.
//  Copyright (c) 2015 Allan BARBATO. All rights reserved.
//

import Foundation
import UIKit

class CityWeatherTableViewCell: UITableViewCell
{
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!

    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
