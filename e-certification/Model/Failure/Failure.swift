//
//  Failure.swift
//  MTG
//
//  Created by Syarif on 8/3/17.
//  Copyright © 2017 Pistarlabs. All rights reserved.
//

import Foundation
import Arrow

struct Failure {
    var code = ""
    var status = ""
    var message = ""
    var data:NSDictionary = NSDictionary()
    /// The method you declare your json mapping in.
    mutating func deserialize(_ json: JSON) {
        code <-- json["code"]
        status <-- json["status"]
        message <-- json["message"]
        data <-- json["errors"] 
    }
}
