//
//  AEntity.swift
//  WayThere
//
//  Created by Allan BARBATO on 5/17/15.
//  Copyright (c) 2015 Allan BARBATO. All rights reserved.
//

import Foundation
import ObjectMapper

/**
*  Entity to use as native Swift object.
*  The purpose for creating an Entity for each model is to be able
*  to use an Entity anywhere in the code, not only when you want to save it to CoreData.
*  (even when using different contexts/database, it will always be saved somewhere or another)
*  In addition you can use native Swift object in an Entity (Int, Float, ...) but not in a CoreData Model (e.g. NSNumber for a float)
*  In addition 2, if I decide to change my database to use pure SQLite for example, all my view controllers will still work without edit
*
*  AEntity is just a base for any entity
*/
public class AEntity
{
}