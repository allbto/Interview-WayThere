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
    
    /// Views
    var activityIndicator: UIActivityIndicatorView?

    /// Objects
    var dataStore = MainDataStore()
    var locationManager = CLLocationManager()
    var cities = [City]()
    
    // MARK: - UIViewController
    
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

// MARK: - MainDataStoreDelegate
extension MainViewController: MainDataStoreDelegate
{
    func foundWeatherConfiguration(cities : [City])
    {
        self.cities = cities
        self.setViewControllers([_viewControllerAtIndex(0)], direction: .Forward, animated: false) { [unowned self] (complete:Bool) -> Void in
            self._hideActivityIndicator()
        }
    }
    
    func unableToFindWeatherConfiguration(error : NSError?)
    {
        _hideActivityIndicator()
        UIAlertView(title: "Oups !", message: "Something went wrong while loading weathers. Please try again later.", delegate: nil, cancelButtonTitle: "OK").show()
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

