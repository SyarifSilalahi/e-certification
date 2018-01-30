//
//  StatusExam.swift
//  e-certification
//
//  Created by Syarif on 1/30/18.
//  Copyright © 2018 infovesta. All rights reserved.
//

import Foundation
import Arrow

struct StatusExam {
    var code :Int = 0
    var status = ""
    var message = ""
    var status_exam:Int = 0
    var message_exam = ""
    
    /// The method you declare your json mapping in.
    
    mutating func deserialize(_ json: JSON) {
        code <-- json["code"]
        status <-- json["status"]
        message <-- json["message"]
        status_exam <-- json["data"]!["status_user"]!["status_exam"]
        message_exam <-- json["data"]!["status_user"]!["message"]
    }
}
