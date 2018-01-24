//
//  ApiManager.swift
//  e-certification
//
//  Created by Syarif on 1/24/18.
//  Copyright © 2018 infovesta. All rights reserved.
//

import UIKit
import Arrow
import Alamofire
import AlamofireImage

class ApiManager: NSObject {
    func forceLogOut(vc:UIViewController ,message:String){
        let alert = UIAlertController(title: "Info", message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let alertOKAction=UIAlertAction(title:"OK", style: UIAlertActionStyle.default,handler: { action in
                Session.userChace.removeObject(forKey: Session.KEY_AUTH)
                UIApplication.topViewController()?.navigationController?.popToRootViewController(animated: true)
//            var dataUser = UserAuthData()
//            let data = JSON(Session.userChace.object(forKey: Session.KEY_AUTH) as AnyObject?)
//            dataUser.deserialize(data!)
//            self.logOut(dataUser.api_token, completionHandler: { (response,failure, error) in
//                if error != nil{
//                    print("error signOut \(String(describing: error))")
//                    return
//                }
//                if failure != nil{
//                    var fail = Failure()
//                    fail.deserialize(failure!)
//                    print("failure message \(fail.message)")
//                    //do action failure here
//                    return
//                }
//
//                Session.userChace.removeObject(forKey: Session.KEY_AUTH)
//                Session.userChace.removeObject(forKey: Session.RECENT)
//                UIApplication.topViewController()?.navigationController?.popToRootViewController(animated: true)
//            })
        })
        alert.addAction(alertOKAction)
        vc.present(alert, animated: true, completion: nil)
    }
    
    func connectionCheck(error : Error){
        if let err = error as? URLError, err.code == .notConnectedToInternet {
            // no internet connection
            CustomAlert().Error(message: "Please check your internet connection.")
        }
    }
    
    //user Login
    func userAuth(_ param:[String:String],completionHandler:@escaping (AnyObject?,JSON?, NSError?) -> ()) {
        HUD().show()
        let header = [
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        Alamofire.request("\(Domain.URL_SIGNIN)",
            method: HTTPMethod.post,
            parameters: param,
            encoding: URLEncoding.httpBody,
            headers: header)
            .responseJSON { (response) in
                HUD().hide()
//                print("response signIn \(response)")
                switch response.result {
                case .success(_):
                    let data = JSON(response.result.value as AnyObject?)
                    let responseData = response.result.value as! NSDictionary
                    let status:Bool = (responseData["status"] as! String != "0")
                    if status {
                        completionHandler(response.result.value as AnyObject?,nil,nil)
                    }else{
                        completionHandler(nil,data!, nil)
                    }
                    break
                case .failure(let error):
                    self.connectionCheck(error: error)
                    completionHandler(nil,nil, error as NSError?)
                    break
                }
        }
    }
}
