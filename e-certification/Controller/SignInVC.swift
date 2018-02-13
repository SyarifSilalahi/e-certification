//
//  SignInVC.swift
//  e-certification
//
//  Created by Syarif on 1/8/18.
//  Copyright © 2018 infovesta. All rights reserved.
//

import UIKit
import Arrow

class SignInVC: UIViewController {
    
    @IBOutlet weak var backGroundImageView: UIImageView!
    @IBOutlet weak var viewBgSignIn: UIView!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnSignUp: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        //statusbar
        let app = UIApplication.shared
        app.isStatusBarHidden = false
        app.statusBarStyle = .lightContent
        
        //check if session is active, open homepage directly
        if Session.userChace.value(forKey: Session.KEY_AUTH) != nil {
            //go to homepage
            self.performSegue(withIdentifier: "showDirectHomePage", sender: self)
            return
        }
        
        self.imagesBackground()
        
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        
    }
    
    func imagesBackground(){
        let horizontalMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        horizontalMotionEffect.minimumRelativeValue = -20
        horizontalMotionEffect.maximumRelativeValue = 25
        
        let verticalMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        verticalMotionEffect.minimumRelativeValue = -20
        verticalMotionEffect.maximumRelativeValue = 25
        
        let motionEffectGroup = UIMotionEffectGroup()
        motionEffectGroup.motionEffects = [horizontalMotionEffect, verticalMotionEffect]
        
        backGroundImageView.addMotionEffect(motionEffectGroup)
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "splashscreen")?.draw(in: self.view.bounds)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.view.backgroundColor = UIColor(patternImage: image)
    }
    
    @IBAction func forgotPassword(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Informasi.", message: "Untuk mengganti kata sandi, anda diharapkan untuk menghubungi Administrasi.", preferredStyle: UIAlertControllerStyle.alert)
        
        let alertOKAction=UIAlertAction(title:"OK", style: UIAlertActionStyle.default,handler: { action in
            
        })
        alert.addAction(alertOKAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func doSignIn(_ sender: AnyObject) {
        self.view.endEditing(true)
        if (self.txtUsername.text?.isEmpty)! || (self.txtPassword.text?.isEmpty)! {
            CustomAlert().Error(message: "Silahkan isi semua kolom yang dibutuhkan.")
        }else if !isValidEmail(testStr: self.txtUsername.text!) {
            CustomAlert().Error(message: "Harap mengisi format email yang benar.")
        }else{
            let udid:String! = UIDevice.current.identifierForVendor!.uuidString
            let param = [
                "email" : "\(txtUsername.text!)",
                "password" : "\(txtPassword.text!)",
                "device_id" : "\(udid)"
            ]
            ApiManager().userAuth(param) { (response,failure, error) in
                if error != nil{
                    print("error signIn \(String(describing: error))")
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
                var dataUser = UserAuthData()
                dataUser.deserialize(JSON(response?.object(forKey: "data") as AnyObject)!)
                
                //session user
                let userAuth = dataUser.dictionary! as NSDictionary
                Session.userChace.set(userAuth, forKey: Session.KEY_AUTH)
                Session.userChace.set("\(self.txtUsername.text!)", forKey: Session.EMAIL)
                //            print("usercache \(Session.userChace.value(forKey: Session.KEY_AUTH))")
                //go to homepage
                self.performSegue(withIdentifier: "showHomePage", sender: self)
            }
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
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.viewBgSignIn.frame.origin.y = 123
        })
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

extension SignInVC:UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.viewBgSignIn.frame.origin.y = 30
        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.viewBgSignIn.frame.origin.y = 123
        })
        return textField.resignFirstResponder()
    }
}
