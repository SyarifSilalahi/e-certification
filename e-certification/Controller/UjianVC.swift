//
//  UjianVC.swift
//  e-certification
//
//  Created by Syarif on 1/20/18.
//  Copyright © 2018 infovesta. All rights reserved.
//

import UIKit

//exam atatus
//1 sudah diassign
//2 lulus
//3 gagal
//4 belum di assign
//5 on progress

class UjianVC: UIViewController {
    
    @IBOutlet weak var imgBg: UIImageView!
    @IBOutlet weak var viewAccessDenied: UIView!
    @IBOutlet weak var viewLulus: UIView!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblInfo: UILabel!
    @IBOutlet weak var btnMulai: UIButton!
    
    //view status lulus
    @IBOutlet weak var lblTitleStatusLulus: UILabel!
    @IBOutlet weak var lblDetailStatusLulus: UILabel!
    @IBOutlet weak var imgStatusLulus: UIImageView!
    
    var examStatus:StatusExam! = StatusExam()
    var listSoal:ListQuestionUjian! = ListQuestionUjian()
    var duration : DurationExam = DurationExam()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.hideComponentFirst()
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        if Session.userChace.value(forKey: Session.FORCE_EXIT_EXAM) != nil {
//            UjianAnswer.arrAnswer = Session.userChace.value(forKey: Session.FORCE_EXIT_EXAM) as! [[String:String]]
//            var nilai = 0
//            for dic in UjianAnswer.arrAnswer{
//                if dic["status"] == "true"{
//                    nilai += 1
//                }
//            }
//            print("nilai \(UjianAnswer.arrAnswer)")
//            //do submit score here
//            self.submitJawaban(nilai: "\(nilai)")
//
//        }
        
        self.getStatus()
        
    }
    
    //fungsi recheck ditujukan untuk submit jawaban jika user keluar dari applikasi
    func submitJawaban(nilai:String){
        ApiManager().setScoreUjian(nilai: nilai) { (response,failure, error) in
            if error != nil{
                print("error setScoreUjian \(String(describing: error))")
                return
            }
            if failure != nil{
                var fail = Failure()
                fail.deserialize(failure!)
                print("failure message \(fail.message)")
                CustomAlert().Error(message: fail.message)
                //do action failure here
                return
            }
            
            var hasilUjian:ScoreExam = ScoreExam()
            hasilUjian.deserialize(response!)
            print("hasilUjian \(hasilUjian)")
            //clear session
//            Session.userChace.removeObject(forKey: Session.FORCE_EXIT_EXAM)
            //and then re check status ujian
            self.setViewStatusExam(status: hasilUjian.data)
            //then reload page
            
        }
    }
    func getStatus(){
        ApiManager().getExamStatus { (response,failure, error) in
            if error != nil{
                print("error getExamStatus \(String(describing: error))")
                return
            }
            if failure != nil{
                var fail = Failure()
                fail.deserialize(failure!)
                print("failure message \(fail.message)")
                CustomAlert().Error(message: fail.message)
                //do action failure here
                return
            }
            
            //json data model
            self.examStatus.deserialize(response!)
            self.setViewStatusExam(status: self.examStatus)
        }
    }
    
    func setDuration(){
        ApiManager().getDurationUjian { (response,failure, error) in
            if error != nil{
                print("error get Duration \(String(describing: error))")
                return
            }
            if failure != nil{
                var fail = Failure()
                fail.deserialize(failure!)
                print("failure message \(fail.message)")
                CustomAlert().Error(message: fail.message)
                //do action failure here
                return
            }
            
            //json data model
            self.duration.deserialize(response!)
            let duration =  Double(self.duration.duration)
            let minute:TimeInterval = duration!
            let dateEndExam = Date(timeIntervalSinceNow: minute)
            UjianAnswer.endDateExam = dateEndExam
            print("now \(Date()) UjianAnswer.endDateExam \(UjianAnswer.endDateExam)")
            self.performSegue(withIdentifier: "openListSoalUjian", sender: self)
        }
    }
    
    func hideComponentFirst(){
        self.lblTitle.alpha = 0
        self.lblDate.alpha = 0
        self.lblInfo.alpha = 0
        self.btnMulai.alpha = 0
    }
    
    func showComponent(){
        self.lblTitle.alpha = 1
        self.lblDate.alpha = 0
        self.lblInfo.alpha = 1
        self.btnMulai.alpha = 1
    }
    
    func setViewStatusExam(status:Int){
        print("status \(status)")
        print("ExamStatus.SudahDiAssign.rawValue \(ExamStatus.SudahDiAssign.rawValue)")
        switch status {
        case ExamStatus.Lulus.rawValue:
            self.viewLulus.alpha = 1
            self.imgStatusLulus.image = #imageLiteral(resourceName: "ico-lulus")
            self.lblTitleStatusLulus.text = "Selamat!"
            self.lblDetailStatusLulus.text = "Anda Telah Lulus."
            self.viewLulus.frame = self.imgBg.frame
            self.view.addSubview(self.viewLulus)
            break
        case ExamStatus.Gagal.rawValue:
            self.viewLulus.alpha = 1
            self.imgStatusLulus.image = #imageLiteral(resourceName: "ico-access-denied")
            self.lblTitleStatusLulus.text = "Maaf!"
            self.lblDetailStatusLulus.text = "Anda belum lulus ujian."
            self.viewAccessDenied.frame = self.imgBg.frame
            self.view.addSubview(self.viewAccessDenied)
            break
        case ExamStatus.BelumDiAssign.rawValue:
            self.viewAccessDenied.alpha = 1
            self.viewAccessDenied.frame = self.imgBg.frame
            self.view.addSubview(self.viewAccessDenied)
            break
        case ExamStatus.OnProgress.rawValue:
            self.viewAccessDenied.alpha = 1
            self.viewAccessDenied.frame = self.imgBg.frame
            self.view.addSubview(self.viewAccessDenied)
            break
        default:
            self.viewAccessDenied.alpha = 1
            self.viewAccessDenied.frame = self.imgBg.frame
            self.view.addSubview(self.viewAccessDenied)
            break
        }
    }
    
    func setViewStatusExam(status:StatusExam!){
        switch status.status_exam {
        case ExamStatus.SudahDiAssign.rawValue:
            self.viewLulus.alpha = 0
            self.viewAccessDenied.alpha = 0
            self.showComponent()
            self.lblTitle.text = status.message_exam
            break
        case ExamStatus.Lulus.rawValue:
            self.viewLulus.alpha = 1
            self.viewLulus.frame = self.imgBg.frame
            self.imgStatusLulus.image = #imageLiteral(resourceName: "ico-lulus")
            self.lblTitleStatusLulus.text = "Selamat!"
            self.lblDetailStatusLulus.text = "Anda Telah Lulus."
            self.view.addSubview(self.viewLulus)
            break
        case ExamStatus.Gagal.rawValue:
            self.viewLulus.alpha = 1
            self.viewLulus.frame = self.imgBg.frame
            self.imgStatusLulus.image = #imageLiteral(resourceName: "ico-access-denied")
            self.lblTitleStatusLulus.text = "Maaf!"
            self.lblDetailStatusLulus.text = "Anda belum lulus ujian."
            self.view.addSubview(self.viewLulus)
            break
        case ExamStatus.BelumDiAssign.rawValue:
            self.viewAccessDenied.alpha = 1
            self.viewAccessDenied.frame = self.imgBg.frame
            self.view.addSubview(self.viewAccessDenied)
            break
        case ExamStatus.OnProgress.rawValue:
            self.viewAccessDenied.alpha = 1
            self.viewAccessDenied.frame = self.imgBg.frame
            self.view.addSubview(self.viewAccessDenied)
            
            //buat testing
//            self.submitJawaban(nilai: "90")
            //
            
            break
        default:
            self.viewAccessDenied.alpha = 1
            self.viewAccessDenied.frame = self.imgBg.frame
            self.view.addSubview(self.viewAccessDenied)
            break
        }
    }
    
    @IBAction func start(_ sender: AnyObject) {
        ApiManager().getQuestionsUjian { (response,failure, error) in
            if error != nil{
                print("error load Question Ujian \(String(describing: error))")
                return
            }
            if failure != nil{
                var fail = Failure()
                fail.deserialize(failure!)
                print("failure message \(fail.message)")
                CustomAlert().Error(message: fail.message)
                //do action failure here
                return
            }
            
            
            //json data model
            self.listSoal.deserialize(response!)
            UjianAnswer.arrAnswer = []
            UjianAnswer.isFinished = false
            UjianAnswer.isTimesUp = false
            for _ in 0..<self.listSoal.data.count{
                let tempAnswer = [
                    "choosed" : "",
                    "status" : "notAnswered"
                ]
                UjianAnswer.arrAnswer.append(tempAnswer)
            }
            
            self.setDuration()
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "openListSoalUjian") {
            let vc = segue.destination as! UjianListSoalVC
            vc.listSoal = self.listSoal
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
