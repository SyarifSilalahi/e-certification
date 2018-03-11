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

enum UploadFotoExam : String {
    case SudahSubmitFoto = "1"
    case BelumSubmitFoto = "2"
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
    static let URL_SUBMIT_HISTORY_LATIHAN = "\(URL_BASE)/user/exercise_history"
    static let URL_GET_HISTORY_LATIHAN = "\(URL_BASE)/user/list_exercise_history"
    static let URL_EXAM_STATUS = "\(URL_BASE)/user/check_status_exam"
    static let URL_QUESTION_UJIAN = "\(URL_BASE)/user/exam_question"
    static let URL_EXAM_DURATION = "\(URL_BASE)/user/get_exam_duration"
    static let URL_EXAM_SUBMIT_SCORE = "\(URL_BASE)/user/score_after_exam"
    static let URL_EXAM_UPLOAD_FOTO = "\(URL_BASE)/user/image_after_exam"
    static let URL_GET_LISENCE = "\(URL_BASE)/user/license_detail"
    static let URL_NEWS = "\(URL_BASE)/user/news"
    static let URL_NOTIFICATION = "\(URL_BASE)/user/notification"
    static let URL_CHECK_UPDATE = "\(URL_BASE)/update_status"
    static let URL_CHECK_DEV = "\(URL_BASE)/development_status"
    static let URL_CHANGE_PASSWORD = "\(URL_BASE)/user/update_password"
    static let URL_FORGOT_PASSWORD = "\(URL_BASE)/forgot_password"
    
    
}

struct Wording {
    static let Connection = "Maaf! Koneksi gagal, Silahkan periksa koneksi internet anda"
    static let DEFAULT_ALLERT_TITLE = "Informasi"
    static let FORCE_LOG_OUT_ALLERT_TITLE = "Pemberitahuan"
    static let FORCE_LOG_OUT_ALLERT_MESSAGE = "Seseorang telah menggunakan Akun anda, \nSilahkan Login kembali"
    static let FINISH_EXERCISE_TITLE = "Latihan Selesai."
    static let FINISH_EXERCISE_MESSAGE = "Anda telah menyelesaikan latihan ini.\nTerimakasih telah berpartisipasi."
    static let FINISH_EXAM_TITLE = "Ujian Selesai."
    static let FINISH_EXAM_MESSAGE = "Anda telah menyelesaikan ujian.\nTerimakasih telah berpartisipasi."
    static let FINISH_EXAM_SUCCESS_MESSAGE = "Selamat!\nAnda telah lulus.\nSilahkan lengkapi data diri anda dalam bentuk foto."
    static let FINISH_EXAM_TIMESUP_MESSAGE = "Waktu ujian telah selesai.\nSilahkan submit jawaban anda."
    static let FINISH_EXAM_EXIT_MESSAGE = "Maaf anda telah keluar atau menutup aplikasi, Anda tidak dapat melanjutkan ujian, Sistem akan segera melakukan penghitungan hasil ujian."
    static let EMPTY_FIELD = "Silahkan isi semua kolom yang dibutuhkan."
    static let EMAIL_VALIDATION = "Harap mengisi format email dengan benar."
    static let FORGOT_PASSWORD_MESSAGE = "Untuk mengganti kata sandi, anda diharapkan untuk menghubungi Administrasi."
    static let CHANGE_PASSWORD_MESSAGE = "Untuk mengganti kata sandi, anda diharapkan untuk menghubungi Administrasi."
    static let FORCE_UPDATE_MESSAGE = "Aplikasi anda sudah usang.\nHarap lakukan pembaharuan."
    static let SUCCESS_REGISTER = "Pendaftaran berhasil."
    static let CONFIRM_DELETE_MATERI = "Apakah anda yakin ingin menghapus materi ini?"
    static let LOGOUT_MESSAGE = "Apakah anda yakin ingin keluar dari aplikasi?"
    
    static let ACCESS_DENIED = "Akses dibuka kembali pada saat anda akan perpanjang lisensi.\nTerima Kasih."
    static let NO_LISENCE = "Maaf.\nAnda belum mempunyai kartu digital."
    static let PASS_EXAM = "Anda Telah Lulus!"
    static let FAILED_EXAM = "Anda tidak lulus ujian."
    static let CONGRATS = "Selamat!"
    static let SORRY = "Maaf!"
    
    static let DEACTIVATE_INSURANCE = "Maaf perusahaan asuransi anda tidak aktif. Silahkan hubungi administrator."
    static let DEACTIVATE_USER = "Maaf user anda tidak aktif. Silahkan hubungi administrator."
    
    //new wording
    static let NEW_PASS_VALIDATION = "Konfirmasi kata sandi baru anda tidak sesuai."
    static let OLD_PASS_VALIDATION = "Kata sandi anda sebelumnya tidak sesuai."
    static let OLD_SUCCESS_CHANGE_PASSWORD = "Kata sandi berhasil di ubah."
    static let ASSIGN_EXAM = "Sudah di assign"
    static let FINISH_EXAM_CONFIRMATION = "Apakah anda yakin untuk submit ujian?"
    static let REQ_EMAIL_FORGOT_PASS = "Silahkan masukkan email anda"
    static let SUCCESS_REQ_FORGOT_PASS = "Permintaan lupa kata sandi anda sedang di proses. Untuk info lebih lanjut harap untuk menghubungi Administrasi."
    
}

struct Session {
    static let userChace = UserDefaults.standard
    static let KEY_UDID = "UDID" //IMEI
    static let KEY_AUTH = "KEY_AUTH"
    static let EMAIL = "EMAIL"
    static let OLD_PASS = "OLD_PASS"
    static let FORCE_EXIT_EXAM = "EXIT"
    static let ID_NOTIF_READ = "ID_NOTIF_READ"
    static let CHECK_NEW_NOTIF = "CHECK_NEW_NOTIF"
}

struct FONT {
    static let M_BOLD = "MyriadPro-Bold"
    static let M_ROMAN = "MyriadPro-Regular"
    static let M_SEMIBOLD = "MyriadPro-Semibold"
    static let M_ITALIC = "MyriadWebPro-Italic"
    static let G_BOOK = "GothamBook"
    static let G_MEDIUM = "GothamMedium"
    
    func setFont(_ fontType:String, fontSize:CGFloat) -> UIFont{
        return UIFont(name: fontType, size: fontSize)!
    }
    
    func setFontM_BOLD(_ fontSize:CGFloat) -> UIFont{
        return UIFont(name: FONT.M_BOLD, size: fontSize)!
    }
    
    func setFontM_ROMAN(_ fontSize:CGFloat) -> UIFont{
        return UIFont(name: FONT.M_ROMAN, size: fontSize)!
    }
    
    func setFontM_SEMIBOLD(_ fontSize:CGFloat) -> UIFont{
        return UIFont(name: FONT.M_SEMIBOLD, size: fontSize)!
    }
    
    func setFontM_ITALIC(_ fontSize:CGFloat) -> UIFont{
        return UIFont(name: FONT.M_ITALIC, size: fontSize)!
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
    static let primaryGreenColor = UIColor.init(hex: "#42ae41")
    static let NavigationColor = UIColor.init(hex: "#4E4E4E") //charcoal
    
    
    
    static let errorColor = UIColor.init(hex: "#d31f26")
    static let successColor = UIColor.init(hex: "#8bc74a")
    
}

struct LatihanAnswer {
    static var isFinished:Bool = false
    static var arrAnswer:[QuestionLatihan] = []
}

struct UjianAnswer {
    static var isFinished:Bool = false
    static var arrAnswer:[[String:String]] = [] as! [[String:String]]
    static var endDateExam:Date = Date()
}
