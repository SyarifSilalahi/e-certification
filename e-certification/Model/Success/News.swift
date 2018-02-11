//
//  News.swift
//  e-certification
//
//  Created by Syarif on 2/12/18.
//  Copyright © 2018 infovesta. All rights reserved.
//

import Foundation
import Arrow

struct ListNews {
    var code :Int = 0
    var status = ""
    var message = ""
    var data = DataNews()
    /// The method you declare your json mapping in.
    
    mutating func deserialize(_ json: JSON) {
        code <-- json["code"]
        status <-- json["status"]
        message <-- json["message"]
        data <-- json["data"]!["news"]
    }
}

struct DataNews : ArrowParsable {
    var total:Int = 0
    var per_page:Int = 0
    var current_page:Int = 0
    var last_page:Int = 0
    var next_page_url = ""
    var prev_page_url = ""
    var from:Int = 0
    var to:Int = 0
    var listDetailNews = [ListDetailNews]()
    
    mutating func deserialize(_ json: JSON) {
        total <-- json["total"]
        per_page <-- json["per_page"]
        current_page <-- json["current_page"]
        last_page <-- json["last_page"]
        next_page_url <-- json["next_page_url"]
        prev_page_url <-- json["prev_page_url"]
        from <-- json["from"]
        to <-- json["to"]
        listDetailNews <-- json["data"]
    }
}

struct ListDetailNews : ArrowParsable {
    var news_id:Int = 0
    var title = ""
    var description = ""
    var image = ""
    var host_file = ""
    var created_at = ""
    
    mutating func deserialize(_ json: JSON) {
        news_id <-- json["news_id"]
        title <-- json["title"]
        description <-- json["description"]
        image <-- json["image"]
        host_file <-- json["host_file"]
        created_at <-- json["created_at"]
    }
}
