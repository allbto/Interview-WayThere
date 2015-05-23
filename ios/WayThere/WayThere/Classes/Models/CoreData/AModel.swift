//
//  CD_AModel.swift
//  
//
//  Created by Allan BARBATO on 5/18/15.
//
//

import Foundation
import CoreData
import SwiftyJSON

protocol AModelSerialization
{
    /**
    Is supposed to unserialize a Model from a json object
    
    :usage: self.name = json["name"].string
    
    :param: json object
    */
    func fromJson(json: JSON)
}

@objc(AModel)
public class AModel: NSManagedObject, AModelSerialization
{
    public func fromJson(json: JSON)
    {
        fatalError("Must be override")
    }
}
