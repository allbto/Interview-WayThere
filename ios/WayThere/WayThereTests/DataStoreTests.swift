//
//  DataStoreTests.swift
//  WayThere
//
//  Created by Allan BARBATO on 5/27/15.
//  Copyright (c) 2015 Allan BARBATO. All rights reserved.
//

import UIKit
import XCTest
import MagicalRecord
import WayThere
import Nimble

class DataStoreTests: XCTestCase
{
    var mainDataStore = MainDataStore()

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // Setup the default model from the current class' bundle
        MagicalRecord.setDefaultModelFromClass(DataStoreTests.self)
        
        // Setup a default store
        MagicalRecord.setupCoreDataStackWithInMemoryStore()

        MagicalRecord.saveUsingCurrentThreadContextWithBlockAndWait { (context:NSManagedObjectContext!) -> Void in
            City.MR_truncateAllInContext(context)
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testRetrieveCities()
    {
        MainDataStore.retrieveCities()
        
        var cities = City.MR_findAllSortedBy("creationDate", ascending: true, inContext: NSManagedObjectContext.MR_contextForCurrentThread()) as! [City]
        var citiesTuples = [
            ("3067696", "Prague"),
            ("2988507", "Paris"),
            ("2990440", "Nice")
        ]
        
        expect(cities.count).to(equal(citiesTuples.count))
        for (index, city) in enumerate(cities) {
            expect(city.remoteId).to(equal(citiesTuples[index].0))
            expect(city.name).to(equal(citiesTuples[index].1))
        }
    }
    
    func testWeatherConfiguration()
    {
        var citiesTuples = [
            ("3067696", "Prague"),
            ("2988507", "Paris"),
            ("2990440", "Nice")
        ]
        
        mainDataStore.retrieveWeatherConfiguration()
        
        NSRunLoop.currentRunLoop().runUntilDate(NSDate(timeIntervalSinceNow: 3)) // 3 seconds for the request to finish, may need more time
        
        var cities = City.MR_findAllSortedBy("creationDate", ascending: true, inContext: NSManagedObjectContext.MR_contextForCurrentThread()) as! [City]
        expect(cities.count).to(equal(citiesTuples.count))
        for (index, city) in enumerate(cities) {
            expect(city.remoteId).to(equal(citiesTuples[index].0))
            expect(city.name).to(equal(citiesTuples[index].1))
            expect(city.country).toNot(beNil())
            expect(count(city.country!)).to(beGreaterThanOrEqualTo(2))
            expect(city.todayWeather).toNot(beNil())
            expect(city.todayWeather!.title).toNot(beNil())
            expect(city.todayWeather!.weatherImage()).toNot(beNil())
            expect(city.coordinates).toNot(beNil())
            expect(city.coordinates!.latitude).toNot(beNil())
            expect(city.wind).toNot(beNil())
            expect(city.wind!.speedImperial).toNot(beNil())
            expect(city.wind!.speedMetric).toNot(beNil())
            expect(city.wind!.degrees).toNot(beNil())
            expect(city.wind!.direction).toNot(beNil())
        }
    }
    
    func testCurrentWeather()
    {
        var coord = SimpleCoordinates(latitude: 48.85, longitude: 2.35)
        
        mainDataStore.retrieveCurrentWeather(coordinates: coord)
        
        NSRunLoop.currentRunLoop().runUntilDate(NSDate(timeIntervalSinceNow: 3)) // 3 seconds for the request to finish, may need more time

        var city = City.MR_findFirstByAttribute("isCurrentLocation", withValue: true, inContext: NSManagedObjectContext.MR_contextForCurrentThread()) as? City

        expect(city).toNot(beNil())
        expect(city?.name).to(equal("Paris"))
        expect(city?.remoteId).to(equal("2988507"))
    }
}
