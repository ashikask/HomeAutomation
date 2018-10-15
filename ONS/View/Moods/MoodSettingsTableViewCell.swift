//
//  MoodSettingsTableViewCell.swift
//  ONS
//
//  Created by ashika kalmady on 03/05/18.
//  Copyright © 2018 ashika kalmady. All rights reserved.
//

import UIKit

class MoodSettingsTableViewCell: UITableViewCell {

    @IBOutlet weak var moodApplianceSwitch: UISwitch!
    @IBOutlet weak var moodApplianceSubName: UILabel!
    @IBOutlet weak var moodSettingsAppliance: UILabel!
    @IBOutlet weak var moodSettingsImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

   
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
