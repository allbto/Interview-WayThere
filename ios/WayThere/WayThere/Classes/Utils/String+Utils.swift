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
    init(_ optional: Any?)
    {
        if let value = unwrap(optional) {
            self = "\(value)"
        } else {
            self = "nil"
        }
    }
}