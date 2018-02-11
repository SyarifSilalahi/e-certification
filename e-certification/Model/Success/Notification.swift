//
//  Notification.swift
//  e-certification
//
//  Created by Syarif on 2/12/18.
//  Copyright © 2018 infovesta. All rights reserved.
//

import Foundation
import Arrow

struct ListNotification {
    var code :Int = 0
    var status = ""
    var message = ""
    var data = [DataNotification]()
    /// The method you declare your json mapping in.
    
    mutating func deserialize(_ json: JSON) {
        code <-- json["code"]
        status <-- json["status"]
        message <-- json["message"]
        data <-- json["data"]!["notification"]
    }
}

struct DataNotification : ArrowParsable {
    var user_notification_id:Int = 0
    var title = ""
    var description = ""
    var created_at = ""
    
    mutating func deserialize(_ json: JSON) {
        user_notification_id <-- json["user_notification_id"]
        title <-- json["title"]
        description <-- json["description"]
        created_at <-- json["created_at"]
    }
}
