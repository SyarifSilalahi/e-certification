//
//  Status.swift
//  e-certification
//
//  Created by Syarif on 2/15/18.
//  Copyright © 2018 infovesta. All rights reserved.
//

import Foundation

import Arrow

struct Status {
    var code :Int = 0
    var status = ""
    var message = ""
    var data = ""
    /// The method you declare your json mapping in.
    
    mutating func deserialize(_ json: JSON) {
        code <-- json["code"]
        status <-- json["status"]
        message <-- json["message"]
        data <-- json["data"]
    }
}
