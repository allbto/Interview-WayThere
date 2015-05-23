//
//  SettingsDataStore.swift
//  WayThere
//
//  Created by Allan BARBATO on 5/17/15.
//  Copyright (c) 2015 Allan BARBATO. All rights reserved.
//

import Foundation

class SettingsDataStore
{
    /**
    Set setting for key
    
    :param: value value of the setting to store
    :param: key   key of the setting to store
    */
    static func setSettingValue(value: AnyObject?, forKey key: SettingKey)
    {
        NSUserDefaults.standardUserDefaults().setObject(value, forKey: key.rawValue)
    }
    
    /**
    Get setting with key
    
    :param: key   key of the setting to get
    */
    static func settingValueForKey(key: SettingKey) -> AnyObject?
    {
        return NSUserDefaults.standardUserDefaults().objectForKey(key.rawValue)
    }
}