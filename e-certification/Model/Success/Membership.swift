//
//  Membership.swift
//  e-certification
//
//  Created by Syarif on 2/18/18.
//  Copyright © 2018 infovesta. All rights reserved.
//

import Foundation
import Arrow

struct Membership {
    var code :Int = 0
    var status = ""
    var message = ""
    var lisence = Lisences()
    /// The method you declare your json mapping in.
    
    mutating func deserialize(_ json: JSON) {
        code <-- json["code"]
        status <-- json["status"]
        message <-- json["message"]
        lisence <-- json["data"]!
    }
}

struct Lisences : ArrowParsable {
    var name = ""
    var expired_date = ""
    var image_user = ""
    var image_license = ""
    var no_license = ""
    var insurance_sub_title = ""
    var host_file = ""
    var insurance_title = ""
    
    mutating func deserialize(_ json: JSON) {
        name <-- json["name"]
        expired_date <-- json["expired_date"]
        image_user <-- json["image_user"]
        image_license <-- json["image_license"]
        no_license <-- json["no_license"]
        insurance_sub_title <-- json["insurance_sub_title"]
        host_file <-- json["host_file"]
        insurance_title <-- json["insurance_title"]
    }
}

