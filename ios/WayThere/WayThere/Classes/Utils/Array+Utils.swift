//
//  Array+Utils.swift
//  WayThere
//
//  Created by Allan BARBATO on 5/20/15.
//  Copyright (c) 2015 Allan BARBATO. All rights reserved.
//

import Foundation

extension Array
{
    /**
    Add a func to Array allowing to fetch object optionally
    There is a big debate for whether or not Array subscript should return optional values
    For me I think it's perfect like it is, but I'm still missing this func for the special cases
    
    :param: index to fetch
    
    :returns: Element of Array or nil if out of bounds
    */
    func get(index: Int) -> T?
    {
        if index < self.count {
            return self[index]
        }
        return nil
    }
    
    mutating func remove<U: Equatable>(object: U) -> Int?
    {
        for (index, objectToCompare) in enumerate(self) {
            if let to = objectToCompare as? U {
                if object == to {
                    self.removeAtIndex(index)
                    return index
                }
            }
        }
        return nil
    }
}