//
//  LatihanCell.swift
//  e-certification
//
//  Created by Syarif on 1/18/18.
//  Copyright © 2018 infovesta. All rights reserved.
//

import UIKit

class LatihanCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var btnStart: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
