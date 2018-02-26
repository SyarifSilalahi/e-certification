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
    @IBOutlet weak var viewBgUname: UIView!
    @IBOutlet weak var viewBgPass: UIView!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var btnForgotPass: UIButton!
    @IBOutlet weak var btnSignIn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(checkUpdates), name: NSNotification.Name(rawValue: "CHECK_UPDATE"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(exit), name: NSNotification.Name(rawValue: "LOGOUT"), object: nil)
        //statusbar
        let app = UIApplication.shared
        app.isStatusBarHidden = false
        app.statusBarStyle = .lightContent
        self.hide()
        self.checkUpdates()
        self.imagesBackground()
        
    }
    
    @objc func checkUpdates(){
        ApiManager().checkUpdate { (response,failure, error) in
            if error != nil{
                print("error CheckUpdates \(String(describing: error))")
                return
            }
            if failure != nil{
                var fail = Failure()
                fail.deserialize(failure!)
//                print("failure message \(fail.message)")
//                CustomAlert().Error(message: fail.message)
                //do action failure here
                return
            }
            
            //json data model
            var status = Status()
            status.deserialize(response!)
            if status.data != "1"{
                let alert = UIAlertController(title: "Informasi.", message: Wording.FORCE_UPDATE_MESSAGE, preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                    
                }))
                self.present(alert, animated: true, completion: nil)
            }else{
                self.show()
                self.checkDevStatus()
                //check if session is active, open homepage directly
                if Session.userChace.value(forKey: Session.KEY_AUTH) != nil {
                    //go to homepage
                    self.performSegue(withIdentifier: "showDirectHomePage", sender: self)
                    return
                }
            }
            
        }
    }
    
    @objc func exit(){
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers
        self.navigationController!.popToViewController(viewControllers[0], animated: true)
    }
    
    func checkDevStatus(){
        ApiManager().getStatusDev { (response,failure, error) in
            if error != nil{
                self.btnSignUp.alpha = 0
                print("error checkDevStatus \(String(describing: error))")
                return
            }
            if failure != nil{
                self.btnSignUp.alpha = 0
                var fail = Failure()
                fail.deserialize(failure!)
//                print("failure message \(fail.message)")
//                CustomAlert().Error(message: fail.message)
                //do action failure here
                return
            }
            
            //json data model
            var status = Status()
            status.deserialize(response!)
            if status.data != "1"{
                self.btnSignUp.alpha = 0
            }else{
                //harusnya 1 tapi nanti aja di pasang setelah dijelaskan ke user, karena usernya gak mau
                self.btnSignUp.alpha = 0
            }
        }
    }
    
    func hide(){
        self.viewBgPass.alpha = 0
        self.viewBgUname.alpha = 0
        self.btnSignIn.alpha = 0
        self.btnSignUp.alpha = 0
        self.btnForgotPass.alpha = 0
    }
    
    func show(){
        self.viewBgPass.alpha = 1
        self.viewBgUname.alpha = 1
        self.btnSignIn.alpha = 1
        self.btnForgotPass.alpha = 1
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
        let alert = UIAlertController(title: "Informasi.", message: Wording.FORGOT_PASSWORD_MESSAGE, preferredStyle: UIAlertControllerStyle.alert)
        
        let alertOKAction=UIAlertAction(title:"OK", style: UIAlertActionStyle.default,handler: { action in
            
        })
        alert.addAction(alertOKAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func doSignIn(_ sender: AnyObject) {
        self.view.endEditing(true)
        if (self.txtUsername.text?.isEmpty)! || (self.txtPassword.text?.isEmpty)! {
            CustomAlert().Error(message: Wording.EMPTY_FIELD)
        }else if !isValidEmail(testStr: self.txtUsername.text!) {
            CustomAlert().Error(message: Wording.EMAIL_VALIDATION)
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
                var user = UserAuth()
                user.deserialize(JSON(response as AnyObject)!)
//                print("user \(user)")
                if user.status == "1"{
//                    var dataUser = UserAuthData()
//                    dataUser.deserialize(JSON(response?.object(forKey: "data") as AnyObject)!)
                    
                    //session user
                    let userAuth = user.data.dictionary! as NSDictionary
                    Session.userChace.set(userAuth, forKey: Session.KEY_AUTH)
                    Session.userChace.set("\(self.txtUsername.text!)", forKey: Session.EMAIL)
                    //            print("usercache \(Session.userChace.value(forKey: Session.KEY_AUTH))")
                    //go to homepage
                    self.performSegue(withIdentifier: "showHomePage", sender: self)
                }else if user.status == "2" {
                    CustomAlert().Error(message: Wording.DEACTIVATE_INSURANCE)
                }else if user.status == "3" {
                    CustomAlert().Error(message: Wording.DEACTIVATE_USER)
                }
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
