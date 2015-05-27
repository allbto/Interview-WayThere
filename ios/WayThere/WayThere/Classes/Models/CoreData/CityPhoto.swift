//
//  CityPhoto.swift
//  
//
//  Created by Allan BARBATO on 5/26/15.
//
//

import Foundation
import CoreData

@objc(CityPhoto)
public class CityPhoto: AModel {

    @NSManaged public var url: String?
    @NSManaged public var cityId: String?

}
