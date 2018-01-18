//
//  NotifCell.swift
//  e-certification
//
//  Created by Syarif on 1/9/18.
//  Copyright © 2018 infovesta. All rights reserved.
//

import UIKit

class NotifCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var imgDot: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
