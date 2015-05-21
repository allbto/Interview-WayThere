//
//  SwitchTableViewCell.swift
//  WayThere
//
//  Created by Allan BARBATO on 5/19/15.
//  Copyright (c) 2015 Allan BARBATO. All rights reserved.
//

import UIKit

protocol SwitchTableViewCellDelegate
{
    func switchCell(cell: SwitchTableViewCell, didChangeValue: Bool)
}

class SwitchTableViewCell: UITableViewCell
{
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var switchAccessory: UISwitch!
    
    var delegate : SwitchTableViewCellDelegate?
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func switchAccessoryValueChanged(sender: AnyObject)
    {
        delegate?.switchCell(self, didChangeValue: switchAccessory.on)
    }
}
