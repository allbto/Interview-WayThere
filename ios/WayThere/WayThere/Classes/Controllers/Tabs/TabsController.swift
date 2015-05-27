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
    weak var settingsViewController: SettingsViewController?
    
    private var _updateMainViewController = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.delegate = self
        
        if let viewControllers = self.viewControllers as? [UIViewController] {
            
            for viewController in viewControllers {
                
                if let navVC = viewController as? UINavigationController, vc = navVC.viewControllers.get(0) as? UIViewController {
                    if vc is MainViewController {
                        mainViewController = (vc as! MainViewController)
                    } else if vc is CitiesViewController {
                        forecastViewController = (vc as! CitiesViewController)
                    } else if vc is SettingsViewController {
                        settingsViewController = (vc as! SettingsViewController)
                    }
                }
            }
        }
        
        mainViewController?.mainViewDelegate = self
    }
}

// MARK: UITabBarControllerDelegate
extension TabsController : UITabBarControllerDelegate
{
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController)
    {
        if let navVC = viewController as? UINavigationController, vc = navVC.viewControllers.get(0) as? UIViewController {
            if vc == settingsViewController {
                _updateMainViewController = true
            } else if vc == mainViewController && _updateMainViewController {
                _updateMainViewController = false
                mainViewController?.updateViewControllers()
            }
        }
    }
}

// MARK: MainViewDelegate
extension TabsController : MainViewDelegate
{
    func didChangeCity(city: City)
    {
        forecastViewController?.forecastCity = city
    }
}

