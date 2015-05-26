//
//  String+Utils.swift
//  WayThere
//
//  Created by Allan BARBATO on 5/23/15.
//  Copyright (c) 2015 Allan BARBATO. All rights reserved.
//

import Foundation

func unwrap(any:Any) -> Any? {
    // http://stackoverflow.com/questions/27989094/how-to-unwrap-an-optional-value-from-any-type
    let mi:MirrorType = reflect(any)
    if mi.disposition != .Optional {
        return any
    }
    if mi.count == 0 { return nil } // Optional.None
    let (name,some) = mi[0]
    return some.value
}

extension String
{
    /**
    Creates a string from any optional value, to avoid the "Optional(toto)" in a displayable text label for example
    If :optional has a value self will be the description of that value otherwise self will be "nil"
    
    :param: optional Any optional value
    */
    init(_ optional: Any?)
    {
        if let value = unwrap(optional) {
            self = "\(value)"
        } else {
            self = "nil"
        }
    }
    
    /**
    Replace every :strFrom by :strTo
    So "I am a potato".replace("potato", "couch potato") -> "I am a couch potato"
    
    :param: strFrom to be replaced
    :param: strTo   to replace
    
    :returns: String from self with :str replaced
    */
    func replace(strFrom: String, withString strTo: String) -> String
    {
        return self.stringByReplacingOccurrencesOfString(strFrom, withString: strTo)
    }
}