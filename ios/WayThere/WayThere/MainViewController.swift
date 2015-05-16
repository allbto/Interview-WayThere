//
//  MainViewController.swift
//  WayThere
//
//  Created by Allan BARBATO on 5/16/15.
//  Copyright (c) 2015 Allan BARBATO. All rights reserved.
//

import UIKit

class MainViewController: UIPageViewController
{
    let TodayViewControllerIdentifier = "TodayViewControllerIdentifier"
    
    var weathers = [Weather]()
    
    // MARK: UIViewController
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.dataSource = self
        self.setViewControllers([_viewControllerAtIndex(0)], direction: .Forward, animated: false) { (complete : Bool) -> Void in
            // Did set view controllers
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Page view controller content
    
    private func _mainStoryboard() -> UIStoryboard
    {
        return UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
    }
    
    private func _viewControllerAtIndex(index : Int) -> TodayViewController
    {
        var todayVC = _mainStoryboard().instantiateViewControllerWithIdentifier(TodayViewControllerIdentifier) as! TodayViewController
        
        todayVC.index = index
        
        if index < weathers.count {
            todayVC.weather = weathers[index]
        }

        return todayVC
    }
}

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
        
        if index >= (weathers.count - 1) {
            return nil
        }
        
        return _viewControllerAtIndex(index + 1)
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return weathers.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return 0
    }
}

