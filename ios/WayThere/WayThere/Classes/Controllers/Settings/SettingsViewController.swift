//
//  SettingsViewController.swift
//  WayThere
//
//  Created by Allan BARBATO on 5/17/15.
//  Copyright (c) 2015 Allan BARBATO. All rights reserved.
//

import UIKit
import UIActionSheet_Blocks

class SettingsViewController: UITableViewController
{
//    var dataStore = SettingsDataStore()
    
    var sections = [Section]()
    
    // MARK: - UIViewController
    
    private func _initSections()
    {
        sections = [
            Section(title: "General", cells:[
                Cell(title: "Unit of lenght", key: SettingKey.UnitOfLenght.rawValue, value: SettingsDataStore.settingValueForKey(.UnitOfLenght), type:.SelectCell, data: SettingUnitOfLenght.allRawValues),
                Cell(title: "Unit of temperature", key: SettingKey.UnitOfTemperature.rawValue, value: SettingsDataStore.settingValueForKey(.UnitOfTemperature), type:.SelectCell, data: SettingUnitOfTemperature.allRawValues)
                ]),
            Section(title: "Bonus", cells:[
                Cell(title: "STRV mode (no background)", key: SettingKey.STRVMode.rawValue, value: SettingsDataStore.settingValueForKey(.STRVMode), type:.SwitchCell, data: nil),
                Cell(title: "GIF mode", key: SettingKey.GIFMode.rawValue, value: SettingsDataStore.settingValueForKey(.GIFMode), type:.SwitchCell, data: nil)
                ])
        ]
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        // Configure tableView sections
        _initSections()
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: UITableViewDataSource
extension SettingsViewController
{
    /// Sections
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return sections.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return section < sections.count ? sections[section].title : nil
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel.textColor = UIColor(red:0.184, green:0.569, blue:1, alpha:1) /*#2f91ff*/
        }
    }
    
    /// Rows
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return section < sections.count ? sections[section].cells.count : 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        if let cell = sections.get(indexPath.section)?.cells.get(indexPath.row) {
            switch cell.type {
            case .SwitchCell:
                var switchCell = self.tableView.dequeueReusableCellWithIdentifier(cell.type.rawValue) as! SwitchTableViewCell
                switchCell.leftLabel?.text = cell.title
                switchCell.switchAccessory.on = (cell.value as? Bool) ?? false
                switchCell.delegate = self
                
                return switchCell
            case .SelectCell:
                var selectCell = self.tableView.dequeueReusableCellWithIdentifier(cell.type.rawValue) as! SelectMenuTableViewCell
                selectCell.leftLabel?.text = cell.title
                selectCell.rightLabel?.text = (cell.value as? String) ?? ""
                
                return selectCell
            default:
                break
            }
        }
        return UITableViewCell()
    }
}

// MARK: SwitchTableViewCellDelegate
extension SettingsViewController : SwitchTableViewCellDelegate
{
    func switchCell(switchCell: SwitchTableViewCell, didChangeValue value: Bool)
    {
        if let indexPath = self.tableView.indexPathForCell(switchCell),
            cell = sections.get(indexPath.section)?.cells.get(indexPath.row) where cell.type == .SwitchCell {
                
            sections[indexPath.section].cells[indexPath.row].value = value
            SettingsDataStore.setSettingValue(value, forKey: SettingKey(rawValue: cell.key)!)
        }
    }
}

// MARK: UITableViewDelegate
extension SettingsViewController
{
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if let cell = sections.get(indexPath.section)?.cells.get(indexPath.row) where cell.type == .SelectCell {
            UIActionSheet.showInView(self.view, withTitle: nil, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: cell.data) { [unowned self] (actionSheet : UIActionSheet, index : Int) -> Void in

                if index != actionSheet.cancelButtonIndex && cell.data != nil && index < cell.data!.count {
                    
                    self.sections[indexPath.section].cells[indexPath.row].value = cell.data![index]
                    SettingsDataStore.setSettingValue(cell.data![index], forKey: SettingKey(rawValue: cell.key)!)
                    self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                }
            }
        }
    }
}

