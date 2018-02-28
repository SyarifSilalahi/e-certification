//
//  ChangePasswordVC.swift
//  e-certification
//
//  Created by Syarif on 3/1/18.
//  Copyright © 2018 infovesta. All rights reserved.
//

import UIKit

class ChangePasswordVC: UIViewController {

    @IBOutlet weak var backGroundImageView: UIImageView!
    @IBOutlet weak var txtOldPass: UITextField!
    @IBOutlet weak var txtNewPass: UITextField!
    @IBOutlet weak var txtConfPass: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = true
        //statusbar
//        let app = UIApplication.shared
//        app.isStatusBarHidden = false
//        app.statusBarStyle = .lightContent
        
    }
    
    @IBAction func back(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func changePassword(_ sender: AnyObject) {
        self.view.endEditing(true)
        if (self.txtOldPass.text?.isEmpty)! || (self.txtNewPass.text?.isEmpty)! || (self.txtConfPass.text?.isEmpty)! {
            CustomAlert().Error(message: Wording.EMPTY_FIELD)
        }else if self.txtConfPass.text! != self.txtNewPass.text! {
            CustomAlert().Error(message: Wording.NEW_PASS_VALIDATION)
        }else{
            let param = [
                "password" : "\(self.txtOldPass.text!)",
                "new_password" : "\(self.txtNewPass.text!)",
                "new_password_confirmation" : "\(self.txtConfPass.text!)"
            ]
            //change password here
            ApiManager().changePassword(param, completionHandler: { (response,failure, error) in
                
                if error != nil{
                    print("error changePassword \(String(describing: error))")
                    CustomAlert().Error(message: Wording.OLD_PASS_VALIDATION)
                    return
                }
                if failure != nil{
                    var fail = Failure()
                    fail.deserialize(failure!)
//                    CustomAlert().Error(message: fail.message)
                    CustomAlert().Error(message: Wording.OLD_PASS_VALIDATION)
                    //do action failure here
                    return
                }
                
                //json data model
                var status = Status()
                status.deserialize(response!)
                if status.status != "1"{
                    CustomAlert().Error(message: Wording.OLD_PASS_VALIDATION)
                }else{
                    CustomAlert().Success(message: Wording.OLD_SUCCESS_CHANGE_PASSWORD)
                    self.navigationController?.popViewController(animated: true)
                }
                
            })
        }
        
        
    }
    
    func isValidEmail(testStr:String) -> Bool {
        // println("validate calendar: \(testStr)")
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ChangePasswordVC:UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}
