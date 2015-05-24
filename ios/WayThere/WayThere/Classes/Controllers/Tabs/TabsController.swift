//
//  TabsController.swift
//  WayThere
//
//  Created by Allan BARBATO on 5/24/15.
//  Copyright (c) 2015 Allan BARBATO. All rights reserved.
//

import UIKit

class TabsController: UITabBarController
{
    weak var mainViewController: MainViewController?
    weak var forecastViewController: CitiesViewController?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if let viewControllers = self.viewControllers as? [UIViewController] {
            
            for viewController in viewControllers {
                
                if let navVC = viewController as? UINavigationController, vc = navVC.viewControllers.get(0) as? UIViewController {
                    if vc is MainViewController {
                        mainViewController = (vc as! MainViewController)
                    } else if vc is CitiesViewController {
                        forecastViewController  = (vc as! CitiesViewController)
                    }
                }
            }
        }
        
        mainViewController?.mainViewDelegate = self
    }
}

extension TabsController : MainViewDelegate
{
    func didChangeCity(city: City)
    {
        forecastViewController?.forecastCity = city
    }
}

