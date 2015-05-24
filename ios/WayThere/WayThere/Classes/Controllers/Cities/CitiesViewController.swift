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

@IBDesignable class CitiesViewController: UITableViewController
{
    let DefaultCellIdentifier = "DefaultCellIdentifier"
    
    @IBInspectable weak var isForecast: NSNumber!
    weak var forecastCity: City? {
        didSet {
            if let city = forecastCity {
                dataStore.delegate = self
                dataStore.retrieveWeatherForecastForCity(city)
                self.title = city.name
            }
        }
    }
    
    var activityIndicator: UIActivityIndicatorView?
    @IBOutlet weak var addCityButton: UIButton!

    var delegate: CitiesViewControllerDelegate?
    var dataStore = CitiesDataStore()

    // Cities manager
    var cities = [City]()
    var searchingCities = [SimpleCity]()
    
    // Forecast
    var weathers = [SimpleWeather]()
    
    // MARK: - UIViewController
    
    private func _showActivityIndicator()
    {
        if activityIndicator == nil {
            activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
            activityIndicator!.frame = CGRectMake(0, 0, 24, 24)
            activityIndicator!.center = self.tableView.center
            activityIndicator!.frame.origin.y = 53
            self.view.addSubview(activityIndicator!)
        }
        self.view.bringSubviewToFront(activityIndicator!)
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
        
        // Configure DataStore
        dataStore.delegate = self
        
        if isForecast.boolValue == true {
            self.navigationItem.leftBarButtonItem = nil
            self.navigationItem.rightBarButtonItem = nil
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        _hideSearchBar()
        
        if cities.count > 0 {
            self.tableView.reloadData()
        }
        
        _showActivityIndicator()
        if isForecast.boolValue ==  false {
            // Fetch cities data
            dataStore.retrieveWeatherConfiguration()
        } else {
            _hideActivityIndicator()
        }
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
        delegate?.didFinishEditingCities()
        self.dismissViewControllerAnimated(true, completion: nil)
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
        UIAlertView(title: "Oups !", message: "Seems like the cities just disappeared", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "Retry").show()
    }
    
    func foundCitiesForQuery(cities: [SimpleCity])
    {
        _hideActivityIndicator()

        searchingCities = cities
        
        self.searchDisplayController?.searchResultsTableView.reloadData()
    }
    
    func unableToFindCitiesForQuery(error: NSError?)
    {
        _hideActivityIndicator()
//        UIAlertView(title: "Cannot find cities", message: "Seems like it's broken, Johnny !", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "Retry").show()
    }
    
    func didSaveNewCity(city: City)
    {
        cities.append(city)
        self.tableView.reloadSections(NSIndexSet(index:0), withRowAnimation: .Automatic)
    }
    
    func didRemoveCity(city: City)
    {
        if let index = cities.remove(city) {
            self.tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: 0)], withRowAnimation: .Automatic)
        }
    }
    
    func foundWeatherForecastForCity(weathers: [SimpleWeather])
    {
        _hideActivityIndicator()
        self.weathers = weathers
        self.tableView.reloadData()
    }
    
    func unableToFindForecastForCity(error: NSError?)
    {
        UIAlertView(title: "Oups !", message: "Seems like the forecasts are unreachable", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "Retry").show()
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
            
            if isForecast.boolValue == true && forecastCity != nil {
                // Fetch weather forecasts
                dataStore.retrieveWeatherForecastForCity(forecastCity!)
            } else if isForecast.boolValue ==  false {
                // Fetch cities data
                dataStore.retrieveWeatherConfiguration()
            }
        }
    }
}

// MARK: UITableViewDataSource
extension CitiesViewController
{
    /// Rows
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        if  tableView == self.searchDisplayController?.searchResultsTableView ||
            isForecast.boolValue == true ||
            cities.get(indexPath.row)?.isCurrentLocation?.boolValue == true {
            return false
        }

        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        if editingStyle == .Delete {
            if let city = cities.get(indexPath.row) {
                dataStore.removeCity(city)
            }
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
        } else if isForecast.boolValue == true {
            return weathers.count
        }
        
        return cities.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        if tableView == self.searchDisplayController?.searchResultsTableView {
            if let city = searchingCities.get(indexPath.row) {
                var cell = tableView.dequeueReusableCellWithIdentifier(DefaultCellIdentifier) as? UITableViewCell
                
                if cell == nil {
                    cell = UITableViewCell(style: .Default, reuseIdentifier: DefaultCellIdentifier)
                }
                
                cell!.textLabel?.text = "\(city.name), \(city.country)"
                return cell!
            }
        } else if isForecast.boolValue == true {
            if let weather = weathers.get(indexPath.row), weatherCell = tableView.dequeueReusableCellWithIdentifier(CellType.CityWeatherCell.rawValue) as? CityWeatherTableViewCell {
                weatherCell.mainLabel.text = weather.day
                weatherCell.subtitleLabel.text = weather.title
                if SettingsDataStore.settingValueForKey(.UnitOfTemperature) as? String == SettingUnitOfTemperature.Celcius.rawValue {
                    weatherCell.temperatureLabel.text = "\(weather.temp)°C"
                } else {
                    weatherCell.temperatureLabel.text = "\(weather.temp)°F"
                }
                weatherCell.weatherImageView.image = Weather.weatherImage(weather.title)
                
                return weatherCell
            }
        } else {
            if let city = cities.get(indexPath.row), weatherCell = tableView.dequeueReusableCellWithIdentifier(CellType.CityWeatherCell.rawValue) as? CityWeatherTableViewCell {
                weatherCell.mainLabel.text = city.name
                weatherCell.subtitleLabel.text = city.todayWeather?.title
                if SettingsDataStore.settingValueForKey(.UnitOfTemperature) as? String == SettingUnitOfTemperature.Celcius.rawValue {
                    weatherCell.temperatureLabel.text = "\(String(city.todayWeather?.tempCelcius as? Int))°C"
                } else {
                    weatherCell.temperatureLabel.text = "\(String(city.todayWeather?.tempFahrenheit as? Int))°F"
                }
                weatherCell.weatherImageView.image = city.todayWeather?.weatherImage()
                
                return weatherCell
            }
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
            if let city = searchingCities.get(indexPath.row) {
                _hideSearchBar(active: true)
                dataStore.saveCity(city)
            }
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
        searchingCities = []
        self.searchDisplayController?.searchResultsTableView.reloadData()
    }
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String!) -> Bool
    {
        if count(searchString) >= 3 {
            _showActivityIndicator()
            dataStore.retrieveCitiesForQuery(searchString)
        }
        return false
    }
}

