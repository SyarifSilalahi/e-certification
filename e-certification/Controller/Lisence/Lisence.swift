//
//  Lisence.swift
//  e-certification
//
//  Created by Syarif on 2/18/18.
//  Copyright © 2018 infovesta. All rights reserved.
//

import UIKit

class Lisence: UIView {
    @IBOutlet var viewBaseLisensiData: UIView!
    @IBOutlet var imgUserAvatar: UIImageView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblSubtitle: UILabel!
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var lblNoLisence: UILabel!
    @IBOutlet var lblDateLisence: UILabel!
    
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "Lisence", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
