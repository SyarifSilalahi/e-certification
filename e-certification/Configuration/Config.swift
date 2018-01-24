//
//  Config.swift
//  e-certification
//
//  Created by Syarif on 1/8/18.
//  Copyright © 2018 infovesta. All rights reserved.
//

import Foundation
import Hue

struct Domain {
    
    // BASE URL PRODUCTION
    //        static let URL_BASE = "http://a64f6017.ngrok.io/api" //for chat
    
    // BASE URL DEVELOPMENT
    static let URL_BASE = "http://159.89.195.22:8080" //dev
    
    //url product status
//    static let URL_STATUS_APPS = "http://api.invoker.pistarlabs.id/product-status"
    
    static let URL_SIGNIN = "\(URL_BASE)/login"
    static let URL_CHANGE_PASS = "\(URL_BASE)/auth/password/change"
    static let URL_FORGOT_PASS = "\(URL_BASE)/auth/password/forgot"
    static let URL_VERIFY_TOKEN = "\(URL_BASE)/auth/password/token"
    static let URL_RESET_PASS = "\(URL_BASE)/auth/password/reset"
    static let URL_EDIT_PROFILE = "\(URL_BASE)/profile"
    static let URL_NEW_FEEDBACK = "\(URL_BASE)/feedback"
    static let URL_SUBMIT_POLLING = "\(URL_BASE)/poll"
    static let URL_SUBMIT_SURVEY = "\(URL_BASE)/survey"
    static let URL_ORGANIZATION_CHART = "\(URL_BASE)/organization/chart"
    static let URL_LOGOUT = "\(URL_BASE)/auth/logout"
    static let URL_TESTING = "\(URL_BASE)/apple/is-testing"
    static let URL_REGISTER_TOKEN = "\(URL_BASE)/device/register"
    static let URL_REMOVE_TOKEN = "\(URL_BASE)/device/delete"
    
    static let URL_CHAT = "\(URL_BASE)/chat"
    
}

struct Wording {
    static let ANSWERED = "You're already answered"
    static let PARTICIPATED = "You're already participated"
    static let TIMEOVER = "Time is over"
    static let Connection = "Connection problem!"
}

struct Session {
    static let userChace = UserDefaults.standard
    static let KEY_UDID = "UDID" //IMEI
    static let KEY_AUTH = "KEY_AUTH"
    static let OLD_PASS = "OLD_PASS"
}

struct FONT {
    static let A_BOOK = "Avenir-Book"
    static let A_HEAVY = "Avenir-Heavy"
    static let A_MEDIUM = "Avenir-Medium"
    static let A_ROMAN = "Avenir-Roman"
    static let G_BOOK = "GothamBook"
    static let G_MEDIUM = "GothamMedium"
    
    func setFont(_ fontType:String, fontSize:CGFloat) -> UIFont{
        return UIFont(name: fontType, size: fontSize)!
    }
    
    func setFontAbook(_ fontSize:CGFloat) -> UIFont{
        return UIFont(name: FONT.A_BOOK, size: fontSize)!
    }
    
    func setFontAheavy(_ fontSize:CGFloat) -> UIFont{
        return UIFont(name: FONT.A_HEAVY, size: fontSize)!
    }
    
    func setFontAmedium(_ fontSize:CGFloat) -> UIFont{
        return UIFont(name: FONT.A_MEDIUM, size: fontSize)!
    }
    
    func setFontAroman(_ fontSize:CGFloat) -> UIFont{
        return UIFont(name: FONT.A_ROMAN, size: fontSize)!
    }
    
    func setFontGbook(_ fontSize:CGFloat) -> UIFont{
        return UIFont(name: FONT.G_BOOK, size: fontSize)!
    }
    
    func setFontGmedium(_ fontSize:CGFloat) -> UIFont{
        return UIFont(name: FONT.G_MEDIUM, size: fontSize)!
    }
    
}

struct Theme {
    
    // Color for application
    static let primaryColor = UIColor.init(hex: "#66B219")
    static let secondaryColor = UIColor.init(hex: "#00AA00")
    
    static let errorColor = UIColor.init(hex: "#d31f26")
    static let successColor = UIColor.init(hex: "#8bc74a")
    
}
