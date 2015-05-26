//
//  Int+Random.swift
//  WayThere
//
//  Created by Allan BARBATO on 5/26/15.
//  Copyright (c) 2015 Allan BARBATO. All rights reserved.
//

import Foundation

extension Int {
    /**
    Generates random number according to min and max
    
    :param: min number from which randomize
    :param: max number to randomize to

    :returns: random int
    */
    static func random(min: Int = min, max: Int = max) -> Int {
        return Int(arc4random_uniform(UInt32(max - min))) + min
    }
}