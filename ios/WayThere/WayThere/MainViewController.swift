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
        // Do any additional setup after loading the view, typically from a nib.
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
    private func viewControllerWithPreviousViewController(viewController: UIViewController) -> UIViewController?
    {
        let index : Int
        
        if let vc = viewController as? TodayViewController {
            index = vc.index
        } else {
            index = 0
        }
        
        if index == 0 || index == (weathers.count - 1) {
            return nil
        }
        
        return _viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
    {
        return viewControllerWithPreviousViewController(viewController)
    }

    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?
    {
        return viewControllerWithPreviousViewController(viewController)
    }
}

