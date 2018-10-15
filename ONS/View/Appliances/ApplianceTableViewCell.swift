//
//  ApplianceTableViewCell.swift
//  ONS
//
//  Created by ashika kalmady on 02/05/18.
//  Copyright © 2018 ashika kalmady. All rights reserved.
//

import UIKit

class ApplianceTableViewCell: UITableViewCell {


    @IBOutlet weak var applianceCount: UILabel!
    @IBOutlet weak var applianceName: UILabel!
    @IBOutlet weak var applianceImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
