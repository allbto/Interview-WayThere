//
//  MainViewController.swift
//  WayThere
//
//  Created by Allan BARBATO on 5/16/15.
//  Copyright (c) 2015 Allan BARBATO. All rights reserved.
//

import UIKit
import CoreLocation

class MainViewController: UIPageViewController
{
    let TodayViewControllerIdentifier = "TodayViewControllerIdentifier"
    let SettingsViewControllerIdentifier = "SettingsViewControllerIdentifier"
    let CitiesViewControllerIdentifier = "CitiesViewControllerIdentifier"
    let LocationAccuracy : Double = 100
    
    /// Views
    var settingsNavigationViewController : UINavigationController?
    var citiesNavigationViewController : UINavigationController?
    var activityIndicator: UIActivityIndicatorView?
    var viewImage: UIImageView?

    /// Objects
    var dataStore = MainDataStore()
    var locationManager = CLLocationManager()
    var cities = [City]()
    var currentCity: City?
    
    // MARK: - UIViewController
    
    private func _retrieveUserCoordinates()
    {
        if Device.isVersionOrLater(.Eight) {
            self.locationManager.requestAlwaysAuthorization()
            
            // For use in foreground
            self.locationManager.requestWhenInUseAuthorization()
        }
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.distanceFilter = LocationAccuracy // Will notify the LocationManager every LocationAccuracy meters
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    private func _showActivityIndicator()
    {
        if activityIndicator == nil {
            activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
            activityIndicator!.frame = CGRectMake(0, 0, 24, 24)
            activityIndicator!.center = self.view.center
            self.view.addSubview(activityIndicator!)
        }
        activityIndicator!.hidden = false
        activityIndicator!.startAnimating()
    }
    
    private func _hideActivityIndicator()
    {
        activityIndicator?.stopAnimating()
        activityIndicator?.hidden = true
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Configure PageViewController
        self.dataSource = self
        self.view.backgroundColor = UIColor.whiteColor()

        // Get user coordinates
        _retrieveUserCoordinates()
        
        // Show activity indicator while waiting for weather data
        _showActivityIndicator()

        // Configure DataStore
        dataStore.delegate = self
        dataStore.retrieveWeatherConfiguration()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func menuAction(sender: AnyObject)
    {
        if settingsNavigationViewController == nil {
            var vc = self.storyboard?.instantiateViewControllerWithIdentifier(SettingsViewControllerIdentifier) as! SettingsViewController
            
            vc.delegate = self
            settingsNavigationViewController = UINavigationController(rootViewController: vc)
        }
        
        if let settingsNVC = settingsNavigationViewController {
            self.presentViewController(settingsNVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func citiesMenuAction(sender: AnyObject)
    {
        if citiesNavigationViewController == nil {
            var vc = self.storyboard?.instantiateViewControllerWithIdentifier(CitiesViewControllerIdentifier) as! CitiesViewController
            
            vc.delegate = self
            citiesNavigationViewController = UINavigationController(rootViewController: vc)
        }
        
        if let citiesNVC = citiesNavigationViewController {
            self.presentViewController(citiesNVC, animated: true, completion: nil)
        }
    }
    
    // MARK: - Page view controller content
    
    private func _viewControllerAtIndex(index : Int) -> TodayViewController
    {
        if index < 0 || index >= cities.count {
            return TodayViewController()
        }
        
        var todayVC = self.storyboard?.instantiateViewControllerWithIdentifier(TodayViewControllerIdentifier) as! TodayViewController
        
        todayVC.view.frame = self.view.bounds
        todayVC.index = index
        
        if index < cities.count {
            todayVC.city = cities[index]
        }

        return todayVC
    }
}

// MARK: - SettingsViewControllerDelegate
extension MainViewController: SettingsViewControllerDelegate
{
    func didFinishEditingSettings()
    {
    }
}

// MARK: - CitiesViewControllerDelegate
extension MainViewController: CitiesViewControllerDelegate
{
    func didFinishEditingCities()
    {
    }
}

// MARK: - MainDataStoreDelegate
extension MainViewController: MainDataStoreDelegate
{
    func _updateViewControllers()
    {
        if let city = currentCity {
            if cities.count > 0 && cities[0].isCurrentLocation?.boolValue == true {
                cities[0] = city
            } else {
                cities.insert(city, atIndex: 0)
            }
        }
        
        self.setViewControllers([_viewControllerAtIndex(0)], direction: .Forward, animated: false) { [unowned self] (complete:Bool) -> Void in
            self._hideActivityIndicator()
        }
    }
    
    func foundWeatherConfiguration(cities : [City])
    {
        self.cities = cities
        _updateViewControllers()
    }
    
    func unableToFindWeatherConfiguration(error : NSError?)
    {
        _hideActivityIndicator()
        UIAlertView(title: "Oups !", message: "Seems like a giant thunderstorm prevent the app from getting forecasts", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "Retry").show()
    }
    
    func foundWeatherForCoordinates(city : City)
    {
        city.isCurrentLocation = true
        currentCity = city
        _updateViewControllers()
    }

    func unableToFindWeatherForCoordinates(error : NSError?)
    {
        // Do nothing
    }
}

// MARK: - UIAlertViewDelegate
extension MainViewController: UIAlertViewDelegate
{
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int)
    {
        if buttonIndex != alertView.cancelButtonIndex {
            // Show activity indicator while waiting for weather data
            _showActivityIndicator()
            
            // Fetch weather data
            dataStore.retrieveWeatherConfiguration()
        }
    }
}

// MARK: - UIPageViewControllerDataSource
extension MainViewController: UIPageViewControllerDataSource
{
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
    {
        let index : Int
        
        if let vc = viewController as? TodayViewController {
            index = vc.index
        } else {
            return nil
        }
        
        if index <= 0 {
            return nil
        }
        
        return _viewControllerAtIndex(index - 1)
    }

    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?
    {
        let index : Int
        
        if let vc = viewController as? TodayViewController {
            index = vc.index
        } else {
            return nil
        }
        
        if index >= (cities.count - 1) {
            return nil
        }
        
        return _viewControllerAtIndex(index + 1)
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return cities.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return 0
    }
}

// MARK: - CLLocationManagerDelegate
extension MainViewController: CLLocationManagerDelegate
{
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!)
    {
        var locValue : CLLocationCoordinate2D = manager.location.coordinate;

        if manager.location.horizontalAccuracy < LocationAccuracy {
            locationManager.stopUpdatingLocation()
            dataStore.retrieveCurrentWeather(coordinates:SimpleCoordinates(latitude: locValue.latitude, longitude: locValue.longitude))
        }
    }
}

