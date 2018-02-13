//
//  MenuCVCellCollectionViewCell.swift
//  e-certification
//
//  Created by Syarif on 1/13/18.
//  Copyright © 2018 infovesta. All rights reserved.
//

import UIKit

class MenuCVCell: UICollectionViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    
    func setModeCorrect(){
        self.backgroundColor = Theme.primaryGreenColor
        self.layer.borderColor = UIColor.clear.cgColor
        self.lblTitle.textColor = UIColor.white
    }
    
    func setModeInCorrect(){
        self.backgroundColor = Theme.errorColor
        self.layer.borderColor = UIColor.clear.cgColor
        self.lblTitle.textColor = UIColor.white
    }
    
    func setModeNormal(){
        self.backgroundColor = UIColor.lightGray
        self.layer.borderColor = UIColor.clear.cgColor
        self.lblTitle.textColor = UIColor.white
    }
    
    func setModeSelected(){
        self.backgroundColor = UIColor.clear
        self.layer.borderColor = Theme.primaryGreenColor.cgColor
        self.lblTitle.textColor = Theme.primaryGreenColor
    }
}
