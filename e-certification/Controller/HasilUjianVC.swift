//
//  HasilUjianVC.swift
//  e-certification
//
//  Created by Syarif on 2/5/18.
//  Copyright © 2018 infovesta. All rights reserved.
//

import UIKit

class HasilUjianVC: UIViewController {

    @IBOutlet weak var lblTitleStatus: UILabel!
    @IBOutlet weak var lblDetailStatus: UILabel!
    @IBOutlet weak var lblNilai: UILabel!
    @IBOutlet weak var lblNilaiAnda: UILabel!
    @IBOutlet weak var lblJawabanBenar: UILabel!
    @IBOutlet weak var lblJawabanSalah: UILabel!
    @IBOutlet weak var lblTanggalPengerjaan: UILabel!
    @IBOutlet weak var lblWaktupengerjaan: UILabel!
    
    var nilai:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.lblNilai.text = "\(nilai)"
        self.lblJawabanBenar.text = "\(nilai)"
        self.lblJawabanSalah.text = "\(UjianAnswer.arrAnswer.count - nilai)"
        
        if nilai >= UjianAnswer.arrAnswer.count/2 {
            self.lblNilai.textColor = Theme.successColor
            self.lblNilaiAnda.textColor = Theme.successColor
            self.lblTitleStatus.text = "SELAMAT"
            self.lblTitleStatus.textColor = Theme.successColor
            self.lblDetailStatus.text = "Anda Telah Lulus"
            self.lblDetailStatus.textColor = Theme.successColor
        }else{
            self.lblNilai.textColor = Theme.errorColor
            self.lblNilaiAnda.textColor = Theme.errorColor
            self.lblTitleStatus.text = "MAAF"
            self.lblTitleStatus.textColor = Theme.errorColor
            self.lblDetailStatus.text = "Anda Tidak Lulus"
            self.lblDetailStatus.textColor = Theme.errorColor
        }
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
