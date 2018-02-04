//
//  LatihanInfoVC.swift
//  e-certification
//
//  Created by Syarif on 1/18/18.
//  Copyright © 2018 infovesta. All rights reserved.
//

import UIKit

class LatihanInfoVC: UIViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblInfo: UILabel!

    var modul:ModulLatihan!
    var listSoal:ListQuestionLatihan! = ListQuestionLatihan()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //statusbar
        let app = UIApplication.shared
        app.statusBarStyle = .lightContent
        // Do any additional setup after loading the view.
        self.lblTitle.text = self.modul.module_title
        
    }
    
    @IBAction func back(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func start(_ sender: AnyObject) {
        ApiManager().getQuestionsLatihan(self.modul.sub_module_id) { (response,failure, error) in
            if error != nil{
                print("error load Question Latihan \(String(describing: error))")
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
            
            self.listSoal.deserialize(response!)
            LatihanAnswer.arrAnswer = []
            LatihanAnswer.isFinished = false
            for _ in 0..<self.listSoal.data.count{
                let tempAnswer = [
                    "choosed" : "",
                    "status" : "notAnswered"
                ]
                LatihanAnswer.arrAnswer.append(tempAnswer)
            }
            self.performSegue(withIdentifier: "openListSoalLatihan", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "openListSoalLatihan") {
            let vc = segue.destination as! LatihanListSoalVC
            vc.listSoal = self.listSoal
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
