//
//  RoutineTableViewCell.swift
//  ONS
//
//  Created by ashika kalmady on 02/05/18.
//  Copyright © 2018 ashika kalmady. All rights reserved.
//

import UIKit

class RoutineTableViewCell: UITableViewCell {

    @IBOutlet weak var routineTime: UILabel!
    @IBOutlet weak var routineName: UILabel!
    @IBOutlet weak var routineSwitch: UISwitch!
    @IBOutlet weak var routineButton: UIButton!
    @IBOutlet weak var routineImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
