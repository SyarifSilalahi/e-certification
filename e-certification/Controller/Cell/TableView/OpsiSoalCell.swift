//
//  OpsiSoalCell.swift
//  e-certification
//
//  Created by Syarif on 1/30/18.
//  Copyright © 2018 infovesta. All rights reserved.
//

import UIKit

class OpsiSoalCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var viewBgOpsi: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.isSelected = false
    }
    
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//        // Configure the view for the selected state
//        _ = selected ? self.modeSelect() : self.modeNormal()
//    }
    
    func modeNormal(){
        self.viewBgOpsi.layer.borderColor = Theme.NavigationColor.cgColor
        self.viewBgOpsi.backgroundColor = UIColor.white
        self.lblTitle.textColor = Theme.NavigationColor
        self.lblDetail.textColor = Theme.NavigationColor
    }
    
    func modeSelect(){
        self.viewBgOpsi.layer.borderColor = Theme.NavigationColor.cgColor
        self.viewBgOpsi.backgroundColor = Theme.NavigationColor
        self.lblTitle.textColor = UIColor.white
        self.lblDetail.textColor = UIColor.white
    }
    
    func modeTrue(){
        self.viewBgOpsi.layer.borderColor = UIColor.clear.cgColor
        self.viewBgOpsi.backgroundColor = Theme.successColor
        self.lblTitle.textColor = UIColor.white
        self.lblDetail.textColor = UIColor.white
    }
    
    func modeFalse(){
        self.viewBgOpsi.layer.borderColor = UIColor.clear.cgColor
        self.viewBgOpsi.backgroundColor = Theme.errorColor
        self.lblTitle.textColor = UIColor.white
        self.lblDetail.textColor = UIColor.white
    }
    
}
