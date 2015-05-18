//
//  CoreDataHelper.swift
//  Printic v2
//
//  Created by Allan Barbato on 11/19/14.
//  Copyright (c) 2014 Printic. All rights reserved.
//

import Foundation
import CoreData

public class CoreDataHelper
{
    public static func saveWithSuccessBlock(success : Void -> Void, failure : Void -> Void)
    {
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreWithCompletion({(successBlock : Bool, error : NSError!) in
            
                if error == nil
                {
                    success()
                }
                else
                {
                    failure()
                }
            }
        )
    }

    public static func saveAndWait()
    {
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
    }
}