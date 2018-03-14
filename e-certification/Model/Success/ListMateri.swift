//
//  ListMateri.swift
//  e-certification
//
//  Created by Syarif on 1/25/18.
//  Copyright © 2018 infovesta. All rights reserved.
//

import Foundation
import Arrow

struct ListMateri {
    var code :Int = 0
    var status = ""
    var message = ""
    var data = [Materi]()
    /// The method you declare your json mapping in.
    
    mutating func deserialize(_ json: JSON) {
        code <-- json["code"]
        status <-- json["status"]
        message <-- json["message"]
        data <-- json["data"]!["materials"]
    }
}

struct Materi : ArrowParsable {
    var material_id:Int = 0
    var sub_module_id:Int = 0
    var title = ""
    var description = ""
    var video = ""
    var document = ""
    var sub_module_title = ""
    var host_file = ""
    var video_next = ""
    var updated_at = ""
    var created_at = ""
    
    mutating func deserialize(_ json: JSON) {
        material_id <-- json["material_id"]
        sub_module_id <-- json["module_id"]
        title <-- json["title"]
        description <-- json["description"]
        video <-- json["video"]
        document <-- json["document"]
        sub_module_title <-- json["sub_module_title"]
        host_file <-- json["host_file"]
        video_next <-- json["video_next"]
        updated_at <-- json["updated_at"]
        created_at <-- json["created_at"]
    }
}

