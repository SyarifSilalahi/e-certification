//
//  UjianVC.swift
//  e-certification
//
//  Created by Syarif on 1/20/18.
//  Copyright © 2018 infovesta. All rights reserved.
//

import UIKit

//exam atatus
//1 sudah diassign
//2 lulus
//3 gagal
//4 belum di assign
//5 on progress

class UjianVC: UIViewController {
    
    @IBOutlet weak var imgBg: UIImageView!
    @IBOutlet weak var viewAccessDenied: UIView!
    @IBOutlet weak var viewLulus: UIView!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblInfo: UILabel!
    @IBOutlet weak var btnMulai: UIButton!
    
    var examStatus:StatusExam! = StatusExam()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.hideComponentFirst()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.getStatus()
    }
    
    func getStatus(){
        ApiManager().getExamStatus { (response,failure, error) in
            if error != nil{
                print("error get \(String(describing: error))")
                return
            }
            if failure != nil{
                var fail = Failure()
                fail.deserialize(failure!)
                print("failure message \(fail.message)")
                CustomAlert().Error(message: fail.message)
                //do action failure here
                return
            }
            
            //json data model
            self.examStatus.deserialize(response!)
            self.setViewStatusExam(status: self.examStatus)
            
        }
    }
    
    func hideComponentFirst(){
        self.lblTitle.alpha = 0
        self.lblDate.alpha = 0
        self.lblInfo.alpha = 0
        self.btnMulai.alpha = 0
    }
    
    func showComponent(){
        self.lblTitle.alpha = 1
        self.lblDate.alpha = 1
        self.lblInfo.alpha = 1
        self.btnMulai.alpha = 1
    }
    
    func setViewStatusExam(status:StatusExam!){
        
        switch status.status_exam {
        case ExamStatus.SudahDiAssign.rawValue:
            self.showComponent()
            self.lblTitle.text = status.message_exam
            break
        case ExamStatus.Lulus.rawValue:
            self.viewLulus.frame = self.imgBg.frame
            self.view.addSubview(self.viewLulus)
            break
        case ExamStatus.Gagal.rawValue:
            break
        case ExamStatus.BelumDiAssign.rawValue:
            self.viewAccessDenied.frame = self.imgBg.frame
            self.view.addSubview(self.viewAccessDenied)
            break
        case ExamStatus.OnProgress.rawValue:
            break
        default:
            break
        }
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
