//
//  SweetCurtainOtherPropertiesCell.swift
//  SweetCurtainPlayground
//
//  Created by Ihor Malovanyi on 28.12.2019.
//  Copyright © 2019 Ihor Malovanyi. All rights reserved.
//

import UIKit

class SweetCurtainOtherPropertiesCell: UITableViewCell {

    @IBOutlet private weak var indicatorSwitcher: UISwitch!
   
    var changeHandler: ((Bool) -> ())?
    @IBAction private func switchIndicator(_ sender: UISwitch) {
        changeHandler?(sender.isOn)
    }
    
}
