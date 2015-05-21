//
//  CitiesViewController.swift
//  WayThere
//
//  Created by Allan BARBATO on 5/17/15.
//  Copyright (c) 2015 Allan BARBATO. All rights reserved.
//

import UIKit

protocol CitiesViewControllerDelegate
{
    func didFinishEditingCities()
}

class CitiesViewController: UITableViewController
{
    let DefaultCellIdentifier = "DefaultCellIdentifier"
    
    var activityIndicator: UIActivityIndicatorView?
    @IBOutlet weak var addCityButton: UIButton!

    var delegate: CitiesViewControllerDelegate?
    var dataStore = CitiesDataStore()
    
    var cities = [City]()
    var searchingCities = [City]()
    
    // MARK: - UIViewController
    
    private func _showActivityIndicator()
    {
        if activityIndicator == nil {
            activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
            activityIndicator!.frame = CGRectMake(0, 0, 24, 24)
            activityIndicator!.center = self.tableView.center
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
    
    private func _hideSearchBar(active: Bool = false)
    {
        self.searchDisplayController?.searchBar.hidden = true
        
        if active {
            self.searchDisplayController?.setActive(false, animated: true)
            self.searchDisplayController?.searchBar.resignFirstResponder()
        }
//        self.tableView.contentInset.top = 20
    }
    
    private func _showSearchBar(active: Bool = true)
    {
        self.searchDisplayController?.searchBar.hidden = false
//        self.tableView.contentInset.top = 64
        
        if active {
            self.searchDisplayController?.setActive(true, animated: true)
            self.searchDisplayController?.searchBar.becomeFirstResponder()
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        _showActivityIndicator()
        
        // Configure DataStore
        dataStore.delegate = self
        dataStore.retrieveWeatherConfiguration()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        _hideSearchBar()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addCityAction(sender: AnyObject)
    {
        _showSearchBar()
    }
    
    @IBAction func cancelAction(sender: AnyObject)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
        delegate?.didFinishEditingCities()
    }
}

// MARK: CitiesDataStoreDelegate
extension CitiesViewController : CitiesDataStoreDelegate
{
    func foundWeatherConfiguration(cities : [City])
    {
        _hideActivityIndicator()
        self.cities = cities
        self.tableView.reloadData()
    }
    
    func unableToFindWeatherConfiguration(error : NSError)
    {
        _hideActivityIndicator()
        UIAlertView(title: "Oups !", message: "Seems like the cities just disappeared from planet earth", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "Retry").show()
    }
    
    func foundCitiesForQuery(cities: [City])
    {
        println("Found cities : \(cities)")
        searchingCities = cities
        
        self.searchDisplayController?.searchResultsTableView.reloadData()
    }
    
    func unableToFindCitiesForQuery(error: NSError?)
    {
        UIAlertView(title: "Cannot find cities", message: "Seems like it's broken, Johnny !", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "Retry").show()
    }
}

// MARK: - UIAlertViewDelegate
extension CitiesViewController: UIAlertViewDelegate
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

// MARK: UITableViewDataSource
extension CitiesViewController
{
    /// Rows
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        if tableView == self.searchDisplayController?.searchResultsTableView {
            return false
        }

        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        if editingStyle == .Delete {
            
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        if tableView == self.searchDisplayController?.searchResultsTableView {
            return 44
        }

        return 85
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView == self.searchDisplayController?.searchResultsTableView {
            return searchingCities.count
        }
        
        return cities.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        if tableView == self.searchDisplayController?.searchResultsTableView {
            if let city = searchingCities.get(indexPath.row), cityName = city.name, cityCountry = city.country {
                var cell = tableView.dequeueReusableCellWithIdentifier(DefaultCellIdentifier) as? UITableViewCell
                
                if cell == nil {
                    cell = UITableViewCell(style: .Default, reuseIdentifier: DefaultCellIdentifier)
                }
                
                cell!.textLabel?.text = "\(cityName), \(cityCountry)"
                return cell!
            }
        }
        else if let city = cities.get(indexPath.row), weatherCell = tableView.dequeueReusableCellWithIdentifier(CellType.CityWeatherCell.rawValue) as? CityWeatherTableViewCell {
            weatherCell.mainLabel.text = city.name
            weatherCell.subtitleLabel.text = city.todayWeather?.title
            weatherCell.temperatureLabel.text = city.todayWeather != nil ? String(city.todayWeather!.tempCelcius) : ""
            weatherCell.weatherImageView.image = city.todayWeather?.weatherImage()
            
            return weatherCell
        }
        return UITableViewCell()
    }
}

// MARK: UITableViewDelegate
extension CitiesViewController
{
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if tableView == self.searchDisplayController?.searchResultsTableView {
            _hideSearchBar(active: true)
        }
    }
}

// MARK: UISearchDisplayDelegate
extension CitiesViewController : UISearchDisplayDelegate
{
    func searchDisplayControllerWillBeginSearch(controller: UISearchDisplayController)
    {
        self.searchDisplayController?.searchBar.hidden = false
    }

    func searchDisplayControllerWillEndSearch(controller: UISearchDisplayController)
    {
        self.searchDisplayController?.searchBar.hidden = true
    }
    
    func searchDisplayControllerDidBeginSearch(controller: UISearchDisplayController) {
    }
    
    func searchDisplayControllerDidEndSearch(controller: UISearchDisplayController)
    {
        _hideSearchBar()
    }
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String!) -> Bool
    {
        if count(searchString) >= 3 {
            dataStore.retrieveCitiesForQuery(searchString)
        }
        return false
    }
}

