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
    func forceLogOut(){
        let alert = UIAlertController(title: Wording.FORCE_LOG_OUT_ALLERT_TITLE, message: Wording.FORCE_LOG_OUT_ALLERT_MESSAGE, preferredStyle: UIAlertControllerStyle.alert)
        
        let alertOKAction=UIAlertAction(title:"OK", style: UIAlertActionStyle.default,handler: { action in
                self.logOut()
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
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    func logOut(){
        Session.userChace.removeObject(forKey: Session.KEY_AUTH)
        Session.userChace.removeObject(forKey: Session.EMAIL)
        UIApplication.topViewController()?.navigationController?.popToRootViewController(animated: true)
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
    
    //user Get Materi
    func getMateri(completionHandler:@escaping (JSON?,JSON?, NSError?) -> ()) {
        HUD().show()
        
        let data = JSON(Session.userChace.object(forKey: Session.KEY_AUTH) as AnyObject?)
        var dataUser = UserAuthData()
        dataUser.deserialize(data!)
        let header = [
            "token" : "\(dataUser.token)",
            "device-id" : "\(dataUser.device_id)"
        ]
        
        Alamofire.request("\(Domain.URL_MATERI)",
            method: HTTPMethod.post,
            parameters: nil,
            encoding: URLEncoding.httpBody,
            headers: header)
            .responseJSON { (response) in
                HUD().hide()
                switch response.result {
                case .success(_):
                    let data = JSON(response.result.value as AnyObject?)
                    let responseData = response.result.value as! NSDictionary
                    let status:Bool = (responseData["status"] as! String != "0")
                    if status {
                        completionHandler(data!,nil,nil)
                    }else{
                        if responseData["message"] as! String == "expired_token" {
                            self.forceLogOut()
                            return
                        }
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
    
    //user Get Modul Latihan
    func getModulLatihan(completionHandler:@escaping (JSON?,JSON?, NSError?) -> ()) {
        HUD().show()
        
        let data = JSON(Session.userChace.object(forKey: Session.KEY_AUTH) as AnyObject?)
        var dataUser = UserAuthData()
        dataUser.deserialize(data!)
        let header = [
            "token" : "\(dataUser.token)",
            "device-id" : "\(dataUser.device_id)"
        ]
        
        Alamofire.request("\(Domain.URL_MODUL_LATIHAN)",
            method: HTTPMethod.post,
            parameters: nil,
            encoding: URLEncoding.httpBody,
            headers: header)
            .responseJSON { (response) in
                HUD().hide()
                switch response.result {
                case .success(_):
                    let data = JSON(response.result.value as AnyObject?)
                    let responseData = response.result.value as! NSDictionary
                    let status:Bool = (responseData["status"] as! String != "0")
                    if status {
                        completionHandler(data!,nil,nil)
                    }else{
                        if responseData["message"] as! String == "expired_token" {
                            self.forceLogOut()
                            return
                        }
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
    
    //user Get Question Latihan
    func getQuestionsLatihan(_ modulId:Int, completionHandler:@escaping (JSON?,JSON?, NSError?) -> ()) {
        HUD().show()
        
        let data = JSON(Session.userChace.object(forKey: Session.KEY_AUTH) as AnyObject?)
        var dataUser = UserAuthData()
        dataUser.deserialize(data!)
        
        let param = [
            "sub_module_id" : "\(modulId)"
        ]
        
        let header = [
            "token" : "\(dataUser.token)",
            "device-id" : "\(dataUser.device_id)"
        ]
        
        Alamofire.request("\(Domain.URL_QUESTION_LATIHAN)",
            method: HTTPMethod.post,
            parameters: param,
            encoding: URLEncoding.httpBody,
            headers: header)
            .responseJSON { (response) in
                HUD().hide()
                switch response.result {
                case .success(_):
                    let data = JSON(response.result.value as AnyObject?)
                    let responseData = response.result.value as! NSDictionary
                    let status:Bool = (responseData["status"] as! String != "0")
                    if status {
                        completionHandler(data!,nil,nil)
                    }else{
                        if responseData["message"] as! String == "expired_token" {
                            self.forceLogOut()
                            return
                        }
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
    
    //user Get Status Ujian
    func getExamStatus(completionHandler:@escaping (JSON?,JSON?, NSError?) -> ()) {
        HUD().show()
        
        let data = JSON(Session.userChace.object(forKey: Session.KEY_AUTH) as AnyObject?)
        var dataUser = UserAuthData()
        dataUser.deserialize(data!)
        let header = [
            "token" : "\(dataUser.token)",
            "device-id" : "\(dataUser.device_id)"
        ]
        
        Alamofire.request("\(Domain.URL_EXAM_STATUS)",
            method: HTTPMethod.post,
            parameters: nil,
            encoding: URLEncoding.httpBody,
            headers: header)
            .responseJSON { (response) in
                HUD().hide()
                switch response.result {
                case .success(_):
                    let data = JSON(response.result.value as AnyObject?)
                    let responseData = response.result.value as! NSDictionary
                    let status:Bool = (responseData["status"] as! String != "0")
                    if status {
                        completionHandler(data!,nil,nil)
                    }else{
                        if responseData["message"] as! String == "expired_token" {
                            self.forceLogOut()
                            return
                        }
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
    
    //user Get Question Ujian
    func getQuestionsUjian(completionHandler:@escaping (JSON?,JSON?, NSError?) -> ()) {
        HUD().show()
        
        let data = JSON(Session.userChace.object(forKey: Session.KEY_AUTH) as AnyObject?)
        var dataUser = UserAuthData()
        dataUser.deserialize(data!)
        
        let header = [
            "token" : "\(dataUser.token)",
            "device-id" : "\(dataUser.device_id)"
        ]
        
        Alamofire.request("\(Domain.URL_QUESTION_UJIAN)",
            method: HTTPMethod.post,
            parameters: nil,
            encoding: URLEncoding.httpBody,
            headers: header)
            .responseJSON { (response) in
                HUD().hide()
                switch response.result {
                case .success(_):
                    let data = JSON(response.result.value as AnyObject?)
                    let responseData = response.result.value as! NSDictionary
                    let status:Bool = (responseData["status"] as! String != "0")
                    if status {
                        completionHandler(data!,nil,nil)
                    }else{
                        if responseData["message"] as! String == "expired_token" {
                            self.forceLogOut()
                            return
                        }
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
    
    //user Get Duration Ujian
    func getDurationUjian(completionHandler:@escaping (JSON?,JSON?, NSError?) -> ()) {
        HUD().show()
        
        let data = JSON(Session.userChace.object(forKey: Session.KEY_AUTH) as AnyObject?)
        var dataUser = UserAuthData()
        dataUser.deserialize(data!)
        
        let header = [
            "token" : "\(dataUser.token)",
            "device-id" : "\(dataUser.device_id)"
        ]
        
        Alamofire.request("\(Domain.URL_EXAM_DURATION)",
            method: HTTPMethod.post,
            parameters: nil,
            encoding: URLEncoding.httpBody,
            headers: header)
            .responseJSON { (response) in
                HUD().hide()
                switch response.result {
                case .success(_):
                    let data = JSON(response.result.value as AnyObject?)
                    let responseData = response.result.value as! NSDictionary
                    let status:Bool = (responseData["status"] as! String != "0")
                    if status {
                        completionHandler(data!,nil,nil)
                    }else{
                        if responseData["message"] as! String == "expired_token" {
                            self.forceLogOut()
                            return
                        }
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
    
    //user Set Score Ujian
    func setScoreUjian(completionHandler:@escaping (JSON?,JSON?, NSError?) -> ()) {
        HUD().show()
        
        let data = JSON(Session.userChace.object(forKey: Session.KEY_AUTH) as AnyObject?)
        var dataUser = UserAuthData()
        dataUser.deserialize(data!)
        
        let header = [
            "token" : "\(dataUser.token)",
            "device-id" : "\(dataUser.device_id)"
        ]
        
        Alamofire.request("\(Domain.URL_EXAM_SUBMIT_SCORE)",
            method: HTTPMethod.post,
            parameters: nil,
            encoding: URLEncoding.httpBody,
            headers: header)
            .responseJSON { (response) in
                HUD().hide()
                switch response.result {
                case .success(_):
                    let data = JSON(response.result.value as AnyObject?)
                    let responseData = response.result.value as! NSDictionary
                    let status:Bool = (responseData["status"] as! String != "0")
                    if status {
                        completionHandler(data!,nil,nil)
                    }else{
                        if responseData["message"] as! String == "expired_token" {
                            self.forceLogOut()
                            return
                        }
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
