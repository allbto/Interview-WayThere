//
//  NSDate+Adds.swift
//  WayThere
//
//  Created by Allan BARBATO on 5/26/15.
//  Copyright (c) 2015 Allan BARBATO. All rights reserved.
//

import Foundation

extension NSDate
{
    func dateComposents(#unit: NSCalendarUnit, toDate endDate: NSDate) -> NSDateComponents
    {
        let cal = NSCalendar.currentCalendar()
        return cal.components(unit, fromDate: self, toDate: endDate, options: nil)
    }
}