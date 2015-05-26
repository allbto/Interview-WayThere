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
class CityPhoto: AModel {

    @NSManaged var url: String?
    @NSManaged var cityId: String?

}
