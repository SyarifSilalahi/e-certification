//
//  UserAuth.swift
//  MTG
//
//  Created by Syarif on 8/3/17.
//  Copyright © 2017 Pistarlabs. All rights reserved.
//

import Foundation
import Arrow

struct UserAuth {
    var code :Int = 0
    var status = ""
    var message = ""
    var data = UserAuthData()
    /// The method you declare your json mapping in.
    
    mutating func deserialize(_ json: JSON) {
        code <-- json["code"]
        status <-- json["status"]
        message <-- json["message"]
        data <-- json["data"]
    }
}

//tolong jangan ada yang null
struct UserAuthData : ArrowParsable {
    var id:Int = 0
    var user_id:Int = 0
    var insurance_id:Int = 0
    var member_level_id = ""
    var registration_id = ""
    var name = ""
    var address = ""
    var province = ""
    var city = ""
    var phone = ""
    var gender = ""
    var birth_date = ""
    var birth_place = ""
    var no_ktp = ""
    var no_npwp = ""
    var company = ""
    var company_image = ""
    var fax = ""
    var director = ""
    var expired_date = ""
    var status_exam:Int = 0
    var created_at = ""
    var updated_at = ""
    var token = ""
    var device_id = ""
    var dictionary: [String: String]! //temp untuk menghandle null biar bisa di masukin ke NSUserDefault

    mutating func deserialize(_ json: JSON) {
        id <-- json["id"]
        user_id <-- json["user_id"]
        insurance_id <-- json["insurance_id"]
        member_level_id <-- json["member_level_id"]
        registration_id <-- json["registration_id"]
        name <-- json["name"]
        address <-- json["address"]
        province <-- json["province"]
        city <-- json["city"]
        phone <-- json["phone"]
        gender <-- json["gender"]
        birth_date <-- json["birth_date"]
        birth_place <-- json["birth_place"]
        no_ktp <-- json["no_ktp"]
        no_npwp <-- json["no_npwp"]
        company <-- json["company"]
        company_image <-- json["company_image"]
        fax <-- json["fax"]
        director <-- json["director"]
        expired_date <-- json["expired_date"]
        status_exam <-- json["status_exam"]
        created_at <-- json["created_at"]
        updated_at <-- json["updated_at"]
        token <-- json["token"]
        device_id <-- json["device_id"]
        dictionary = [
            "id" : "\(id)",
            "user_id" : "\(user_id)",
            "insurance_id" : "\(insurance_id)",
            "member_level_id" : "\(member_level_id)",
            "registration_id" : "\(registration_id)",
            "name" : "\(name)",
            "address" : "\(address)",
            "province" : "\(province)",
            "city" : "\(city)",
            "phone" : "\(phone)",
            "gender" : "\(gender)",
            "birth_date" : "\(birth_date)",
            "birth_place" : "\(birth_place)",
            "no_ktp" : "\(no_ktp)",
            "no_npwp" : "\(no_npwp)",
            "company" : "\(company)",
            "company_image" : "\(company_image)",
            "fax" : "\(fax)",
            "director" : "\(director)",
            "expired_date" : "\(expired_date)",
            "status_exam" : "\(status_exam)",
            "created_at" : "\(created_at)",
            "updated_at" : "\(updated_at)",
            "token" : "\(token)",
            "device_id" : "\(device_id)"
        ]
        
    }
}

struct UserAvatar : ArrowParsable {
    var id:Int = 0
    var path = ""
    mutating func deserialize(_ json: JSON) {
        id <-- json["id"]
        path <-- json["path"]
    }
}

struct UserSelfie: ArrowParsable{
    var code :Int = 0
    var status = ""
    var message = ""
    /// The method you declare your json mapping in.
    
    mutating func deserialize(_ json: JSON) {
        code <-- json["code"]
        status <-- json["status"]
        message <-- json["message"]
    }
}
