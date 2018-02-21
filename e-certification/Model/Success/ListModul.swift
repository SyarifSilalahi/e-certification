//
//  ListModulLatihan.swift
//  e-certification
//
//  Created by Syarif on 1/27/18.
//  Copyright © 2018 infovesta. All rights reserved.
//

import Foundation
import Arrow

struct ListModulLatihan {
    var code :Int = 0
    var status = ""
    var message = ""
    var data = [ModulLatihan]()
    /// The method you declare your json mapping in.
    
    mutating func deserialize(_ json: JSON) {
        code <-- json["code"]
        status <-- json["status"]
        message <-- json["message"]
        data <-- json["data"]!["sub_modules"]
    }
}

struct ModulLatihan : ArrowParsable {
    var sub_module_id:Int = 0
    var sub_module_title = ""
    var module_title = ""
    
    mutating func deserialize(_ json: JSON) {
        sub_module_id <-- json["sub_module_id"]
        sub_module_title <-- json["sub_module_title"]
        module_title <-- json["module_title"]
    }
}

struct ListQuestionLatihan {
    var code :Int = 0
    var status = ""
    var message = ""
    var data = [QuestionLatihan]()
    /// The method you declare your json mapping in.
    
    mutating func deserialize(_ json: JSON) {
        code <-- json["code"]
        status <-- json["status"]
        message <-- json["message"]
        data <-- json["data"]!["exercise_questions"]
    }
}
struct QuestionLatihan : ArrowParsable {
    var id:Int = 0
    var sub_module_id:Int = 0
    var question = ""
    var option1 = ""
    var option2 = ""
    var option3 = ""
    var option4 = ""
    var answer = ""
    var explanation = ""
    var selected = ""
    
    
    mutating func deserialize(_ json: JSON) {
        id <-- json["id"]
        sub_module_id <-- json["sub_module_id"]
        question <-- json["question"]
        option1 <-- json["option1"]
        option2 <-- json["option2"]
        option3 <-- json["option3"]
        option4 <-- json["option4"]
        answer <-- json["answer"]
        explanation <-- json["explanation"]
        selected <-- json["selected"]
    }
}

struct ListQuestionUjian {
    var code :Int = 0
    var status = ""
    var message = ""
    var data = [QuestionLatihan]()
    /// The method you declare your json mapping in.
    
    mutating func deserialize(_ json: JSON) {
        code <-- json["code"]
        status <-- json["status"]
        message <-- json["message"]
        data <-- json["data"]!["exam_question"]
    }
}
struct QuestionUjian : ArrowParsable {
    var id:Int = 0
    var sub_module_id:Int = 0
    var question = ""
    var option1 = ""
    var option2 = ""
    var option3 = ""
    var option4 = ""
    var answer = ""
    
    mutating func deserialize(_ json: JSON) {
        id <-- json["id"]
        sub_module_id <-- json["sub_module_id"]
        question <-- json["question"]
        option1 <-- json["option1"]
        option2 <-- json["option2"]
        option3 <-- json["option3"]
        option4 <-- json["option4"]
        answer <-- json["answer"]
    }
}

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

struct DurationExam {
    var code :Int = 0
    var status = ""
    var message = ""
    var duration = ""
    var server_time = ""
    
    /// The method you declare your json mapping in.
    
    mutating func deserialize(_ json: JSON) {
        code <-- json["code"]
        status <-- json["status"]
        message <-- json["message"]
        duration <-- json["data"]!["duration"] // base nya menit
        server_time <-- json["data"]!["server_time"]
    }
}

struct ScoreExam {
    var code :Int = 0
    var status = ""
    var message = ""
    var data :Int = 0
    //data 2 = lulus
    //data 3 = gagal
    /// The method you declare your json mapping in.
    mutating func deserialize(_ json: JSON) {
        code <-- json["code"]
        status <-- json["status"]
        message <-- json["message"]
        data <-- json["data"]
    }
}


struct BaseHistoryLatihan {
    var code :Int = 0
    var status = ""
    var message = ""
    var data = ListHistoryLatihan()
    /// The method you declare your json mapping in.
    
    mutating func deserialize(_ json: JSON) {
        code <-- json["code"]
        status <-- json["status"]
        message <-- json["message"]
        data <-- json["data"]!["exercise_questions"]
    }
}

struct ListHistoryLatihan : ArrowParsable {
    var total:Int = 0
    var per_page:Int = 0
    var current_page:Int = 0
    var last_page:Int = 0
    var next_page_url = ""
    var prev_page_url = ""
    var from:Int = 0
    var to:Int = 0
    var listDetailHistory = [HistoryLatihan]()
    
    mutating func deserialize(_ json: JSON) {
        total <-- json["total"]
        per_page <-- json["per_page"]
        current_page <-- json["current_page"]
        last_page <-- json["last_page"]
        next_page_url <-- json["next_page_url"]
        prev_page_url <-- json["prev_page_url"]
        from <-- json["from"]
        to <-- json["to"]
        listDetailHistory <-- json["data"]
    }
}

struct HistoryLatihan : ArrowParsable {
    var exercise_history_id:Int = 0
    var sub_module_id:Int = 0
    var history = ""
    
    mutating func deserialize(_ json: JSON) {
        exercise_history_id <-- json["exercise_history_id"]
        sub_module_id <-- json["sub_module_id"]
        history <-- json["history"]
    }
}
