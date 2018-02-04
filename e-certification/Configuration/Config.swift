//
//  Config.swift
//  e-certification
//
//  Created by Syarif on 1/8/18.
//  Copyright © 2018 infovesta. All rights reserved.
//

import Foundation
import Hue

//exam atatus
//1 sudah diassign
//2 lulus
//3 gagal
//4 belum di assign
//5 on progress

enum ExamStatus : Int {
    case SudahDiAssign = 1
    case Lulus = 2
    case Gagal = 3
    case BelumDiAssign = 4
    case OnProgress = 5
}

struct Domain {
    
    // BASE URL PRODUCTION
    //        static let URL_BASE = "http://a64f6017.ngrok.io/api" //for chat
    
    // BASE URL DEVELOPMENT
    static let URL_BASE = "http://159.89.195.22:8080" //dev
    
    //url product status
//    static let URL_STATUS_APPS = "http://api.invoker.pistarlabs.id/product-status"
    
    static let URL_SIGNIN = "\(URL_BASE)/login"
    static let URL_MATERI = "\(URL_BASE)/user/material"
    static let URL_MODUL_LATIHAN = "\(URL_BASE)/user/sub_module"
    static let URL_QUESTION_LATIHAN = "\(URL_BASE)/user/exercise_question"
    static let URL_EXAM_STATUS = "\(URL_BASE)/user/check_status_exam"
    static let URL_QUESTION_UJIAN = "\(URL_BASE)/user/exam_question"
    
    static let URL_CHAT = "\(URL_BASE)/chat"
    
}

struct Wording {
    static let ANSWERED = "You're already answered"
    static let PARTICIPATED = "You're already participated"
    static let TIMEOVER = "Time is over"
    static let Connection = "Connection problem!"
    static let FORCE_LOG_OUT_ALLERT_TITLE = "Upss!"
    static let FORCE_LOG_OUT_ALLERT_MESSAGE = "Expired Token\nPlease login again."
    static let FINISH_EXERCISE_TITLE = "Latihan Selesai."
    static let FINISH_EXERCISE_MESSAGE = "Anda yakin ingin mengumpulkan ?"
    static let FINISH_EXAM_TITLE = "Ujian Selesai."
    static let FINISH_EXAM_MESSAGE = "Anda yakin ingin mengumpulkan ?"
}

struct Session {
    static let userChace = UserDefaults.standard
    static let KEY_UDID = "UDID" //IMEI
    static let KEY_AUTH = "KEY_AUTH"
    static let EMAIL = "EMAIL"
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
    static let primaryBlueColor = UIColor.init(hex: "#29A9FF")
    static let NavigationColor = UIColor.init(hex: "#4E4E4E") //charcoal
    
    static let errorColor = UIColor.init(hex: "#d31f26")
    static let successColor = UIColor.init(hex: "#8bc74a")
    
}

struct LatihanAnswer {
    static var isFinished:Bool = false
    static var arrAnswer:[[String:String]] = [] as! [[String:String]]
}

struct UjianAnswer {
    static var isFinished:Bool = false
    static var arrAnswer:[[String:String]] = [] as! [[String:String]]
}
