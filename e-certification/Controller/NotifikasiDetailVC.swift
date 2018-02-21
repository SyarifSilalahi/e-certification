//
//  NotifikasiDetailVC.swift
//  e-certification
//
//  Created by Syarif on 1/20/18.
//  Copyright © 2018 infovesta. All rights reserved.
//

import UIKit

class NotifikasiDetailVC: UIViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var viewContent: UIView!
    
    var detailNotifikasi:DataNotification = DataNotification()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.lblTitle.text = self.detailNotifikasi.title
        self.lblDetail.text = self.detailNotifikasi.created_at
        
        let height:CGFloat = Helper().heightForView(self.detailNotifikasi.description, font: self.lblContent.font, width: self.lblContent.frame.size.width)
        self.viewContent.frame.size.height = height + 20
        self.lblContent.text = self.detailNotifikasi.description
    }
    
    @IBAction func back(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
