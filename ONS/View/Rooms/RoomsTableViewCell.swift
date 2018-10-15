//
//  RoomsTableViewCell.swift
//  ONS
//
//  Created by ashika kalmady on 02/05/18.
//  Copyright © 2018 ashika kalmady. All rights reserved.
//

import UIKit

class RoomsTableViewCell: UITableViewCell {

    @IBOutlet weak var roomName: UILabel!
    @IBOutlet weak var roomImage: UIImageView!
    @IBOutlet weak var roomButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
