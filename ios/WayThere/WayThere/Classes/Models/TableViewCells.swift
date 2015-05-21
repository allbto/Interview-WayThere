//
//  TableViewCells.swift
//  WayThere
//
//  Created by Allan BARBATO on 5/20/15.
//  Copyright (c) 2015 Allan BARBATO. All rights reserved.
//

import Foundation

enum CellType : String
{
    case SwitchCell = "SwitchCellIdentifier"
    case SelectCell = "SelectCellIdentifier"
    case CityWeatherCell = "CityWeatherCellIdentifier"
}

typealias Cell = (title: String, key: String, value: AnyObject?, type: CellType, data: [AnyObject]?)
typealias Section = (title: String, cells: [Cell])

