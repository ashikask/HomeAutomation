//
//  MoodsTableViewCell.swift
//  ONS
//
//  Created by ashika kalmady on 03/05/18.
//  Copyright © 2018 ashika kalmady. All rights reserved.
//

import UIKit

class MoodsTableViewCell: UITableViewCell {

    @IBOutlet var moodsSwitch: UISwitch!
    @IBOutlet weak var moodsButton: UIButton!
    @IBOutlet weak var moodsImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
