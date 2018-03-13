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
    @IBOutlet weak var btnNotification: UIButton!
    let imagePicker = UIImagePickerController()
    
    //view status lulus
    @IBOutlet weak var lblTitleStatusLulus: UILabel!
    @IBOutlet weak var lblDetailStatusLulus: UILabel!
    @IBOutlet weak var imgStatusLulus: UIImageView!
    
    var successUploadSelfie = true
    var hasilUjian:ScoreExam = ScoreExam()
    var examStatus:StatusExam! = StatusExam()
    var listSoal:ListQuestionUjian! = ListQuestionUjian()
    var duration : DurationExam = DurationExam()
    var fotoAgain = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.hideComponentFirst()
        self.imagePicker.delegate = self
        
    }

    override func viewDidAppear(_ animated: Bool) {
        
        self.getStatus()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getNotification()
    }
    
    func getNotification(){
        self.btnNotification.isUserInteractionEnabled = false
        ApiManager().getNotification(isHUD: false) { (response,failure, error) in
            if error != nil{
                print("error load Notification \(String(describing: error))")
                return
            }
            if failure != nil{
                var fail = Failure()
                fail.deserialize(failure!)
                print("failure message \(fail.message)")
                //CustomAlert().Error(message: fail.message)
                //do action failure here
                return
            }
            
            //json data model
            var listNotif:ListNotification = ListNotification()
            listNotif.deserialize(response!)
            if listNotif.data.count == 0 {
                self.btnNotification.setImage(#imageLiteral(resourceName: "ico-notif"), for: .normal)
            }else{
                if Session.userChace.value(forKey: Session.CHECK_NEW_NOTIF) == nil {
                    self.btnNotification.setImage(#imageLiteral(resourceName: "ico-notif-active"), for: .normal)
                    let dicInfoNotif = [
                        "user" : "\(Session.userChace.value(forKey: Session.EMAIL) as! String)",
                        "total_notif" : "\(listNotif.data.count)"
                    ]
                    var arrInfoNotif:[[String:String]] = []
                    arrInfoNotif.append(dicInfoNotif)
                    Session.userChace.set(arrInfoNotif, forKey: Session.CHECK_NEW_NOTIF)
                }else{
                    var arrInfoNotif:[[String:String]] = []
                    arrInfoNotif = Session.userChace.value(forKey: Session.CHECK_NEW_NOTIF) as! [[String : String]]
                    var index = 0
                    for dicInfoNotif in arrInfoNotif{
                        if dicInfoNotif["user"] == Session.userChace.value(forKey: Session.EMAIL) as? String {
                            index += 1
                        }
                    }
                    
                    if index == 0{ //user not found
                        self.btnNotification.setImage(#imageLiteral(resourceName: "ico-notif-active"), for: .normal)
                    }else{ // user found
                        if Int(arrInfoNotif[index - 1]["total_notif"]!)! < listNotif.data.count {
                            self.btnNotification.setImage(#imageLiteral(resourceName: "ico-notif-active"), for: .normal)
                        }else{
                            // set is new notif on notif button if there is detail notif not read
                            if Session.userChace.value(forKey: Session.ID_NOTIF_READ) == nil {
                                self.btnNotification.setImage(#imageLiteral(resourceName: "ico-notif-active"), for: .normal)
                            }else{
                                var arrNotifSession:[NSMutableDictionary] = []
                                arrNotifSession = Session.userChace.value(forKey: Session.ID_NOTIF_READ) as! [NSMutableDictionary]
                                var index = 0
                                for dicInfoNotif in arrNotifSession{
                                    if dicInfoNotif["user"] as? String == Session.userChace.value(forKey: Session.EMAIL) as? String {
                                        index += 1
                                    }
                                }
                                
                                if index == 0{ //user not found
                                    self.btnNotification.setImage(#imageLiteral(resourceName: "ico-notif-active"), for: .normal)
                                }else{ // user found
                                    let dicData = arrNotifSession[index-1]
                                    let arrIndexRead = dicData["arrIndex"] as! [Int]
                                    if arrIndexRead.count == listNotif.data.count {
                                        self.btnNotification.setImage(#imageLiteral(resourceName: "ico-notif"), for: .normal)
                                    }else{
                                        self.btnNotification.setImage(#imageLiteral(resourceName: "ico-notif-active"), for: .normal)
                                    }
                                }
                            }
                        }
                    }
                    
                }
            }
            self.btnNotification.isUserInteractionEnabled = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.fotoAgain = true
    }
    
    func submitSisaJawaban(){
        var nilai = 0
        for dic in UjianAnswer.arrAnswer{
            if dic["status"] == "true"{
                nilai += 1
            }
        }
        print("nilai \(UjianAnswer.arrAnswer)")
        //do submit score here
        self.submitJawaban(nilai: "\(nilai)")
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
                print("failure setScoreUjian message \(fail.message)")
                CustomAlert().Error(message: fail.message)
                //do action failure here
                return
            }
            
            self.hasilUjian.deserialize(response!)
            print("hasilUjian \(self.hasilUjian)")
            
            self.setViewStatusExam(status: self.hasilUjian.data)
            
            if self.hasilUjian.data == ExamStatus.Lulus.rawValue{
                let alert = UIAlertController(title: Wording.FINISH_EXAM_TITLE, message: Wording.FINISH_EXAM_SUCCESS_MESSAGE, preferredStyle: UIAlertControllerStyle.alert)
                
                let alertOKAction=UIAlertAction(title:"OK", style: UIAlertActionStyle.default,handler: { action in
                    // camera
                    self.openCamera()
                })
                alert.addAction(alertOKAction)
                self.present(alert, animated: true, completion: nil)
            }
            
            //clear session
            Session.userChace.removeObject(forKey: Session.FORCE_EXIT_EXAM)
        }
    }
    
    func openCamera(){
        self.imagePicker.allowsEditing = true
        self.imagePicker.sourceType = .camera
        self.imagePicker.cameraDevice = .front
        self.present(self.imagePicker, animated: true, completion: nil)
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
                print("failure getExamStatus message \(fail.message)")
                CustomAlert().Error(message: fail.message)
                //do action failure here
                return
            }
            
            //json data model
            self.examStatus.deserialize(response!)
            self.setViewStatusExam(status: self.examStatus.status_exam)
            if self.examStatus.status_exam == ExamStatus.Lulus.rawValue {
                if self.examStatus.status_image == UploadFotoExam.BelumSubmitFoto.rawValue && self.fotoAgain{
                    let alert = UIAlertController(title: Wording.FINISH_EXAM_TITLE, message: Wording.FINISH_EXAM_SUCCESS_MESSAGE, preferredStyle: UIAlertControllerStyle.alert)
                    
                    let alertOKAction=UIAlertAction(title:"OK", style: UIAlertActionStyle.default,handler: { action in
                        // camera
                        self.openCamera()
                    })
                    alert.addAction(alertOKAction)
                    self.present(alert, animated: true, completion: nil)
                }
            }
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
                print("failure get Duration message \(fail.message)")
//                CustomAlert().Error(message: fail.message)
                //do action failure here
                return
            }
            
            //json data model
            self.duration.deserialize(response!)
            let duration =  Int(self.duration.duration)
            let minute:Int = duration!
//            let dateEndExam = Date(timeIntervalSinceNow: minute)
            let calendar = Calendar.current
            let dateEndExam = calendar.date(byAdding: .minute, value: minute, to: Date())
            UjianAnswer.endDateExam = dateEndExam!
            print("minute \(minute)")
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
        print("status exam \(status)")
        switch status {
        case ExamStatus.SudahDiAssign.rawValue:
            self.viewLulus.alpha = 0
            self.viewAccessDenied.alpha = 0
            self.showComponent()
            self.lblTitle.text = Wording.ASSIGN_EXAM
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
//            self.submitSisaJawaban()
            if Session.userChace.value(forKey: Session.FORCE_EXIT_EXAM) != nil {
                let alert = UIAlertController(title: Wording.FINISH_EXAM_TITLE, message: Wording.FINISH_EXAM_EXIT_MESSAGE, preferredStyle: UIAlertControllerStyle.alert)
                
                let alertOKAction=UIAlertAction(title:"OK", style: UIAlertActionStyle.default,handler: { action in
                    UjianAnswer.arrAnswer = Session.userChace.value(forKey: Session.FORCE_EXIT_EXAM) as! [[String:String]]
                    self.submitSisaJawaban()
                })
                alert.addAction(alertOKAction)
                self.present(alert, animated: true, completion: nil)
            }else{
                self.submitSisaJawaban()
                self.viewAccessDenied.alpha = 1
                self.viewAccessDenied.frame = self.imgBg.frame
                self.view.addSubview(self.viewAccessDenied)
            }
            
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
                print("failure load Question Ujian message \(fail.message)")
                CustomAlert().Error(message: fail.message)
                //do action failure here
                return
            }
            
            
            //json data model
            self.listSoal.deserialize(response!)
            UjianAnswer.arrAnswer = []
            UjianAnswer.isFinished = false
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
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
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

extension UjianVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage{
            HUD().show()
            ApiManager().getLisence { (response,failure, error) in
                if error != nil{
                    print("error load Membership \(String(describing: error))")
                    return
                }
                if failure != nil{
                    var fail = Failure()
                    fail.deserialize(failure!)
                    print("failure load Membership message \(fail.message)")
                    CustomAlert().Error(message: fail.message)
                    //do action failure here
                    return
                }
                
                //json data model
                var membership:Membership = Membership()
                membership.deserialize(response!)
                //set Lisence
                let viewLisence = UINib(nibName: "Lisence", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! Lisence
                viewLisence.lblTitle.text = membership.lisence.insurance_title
                viewLisence.lblSubtitle.text = membership.lisence.insurance_sub_title
                viewLisence.lblUserName.text = membership.lisence.name
                viewLisence.lblNoLisence.text = "No. Lisensi   :   \(membership.lisence.no_license)"
                viewLisence.lblDateLisence.text = "Berlaku s/d   :   \(membership.lisence.expired_date)"
                viewLisence.viewBaseLisensiData.transform = CGAffineTransform(rotationAngle: CGFloat((90.0 * M_PI) / 180.0));
                viewLisence.viewBaseLisensiData.frame.origin.y = 0
                viewLisence.viewBaseLisensiData.frame.origin.x = 0
                
                viewLisence.imgUserAvatar.image = pickedImage
                let image = UIImage(view: viewLisence)
                let compressImageAvatar = UIImage(data: pickedImage.jpeg(.medium)!)
                let compressImageLisence = UIImage(data: image.jpeg(.low)!)
                let imgCompressRotate = compressImageLisence?.imageRotatedByDegrees(-90, flip: false)
                //set foto user
                ApiManager().uploadImageSelfie(image: compressImageAvatar!,imageLicense: imgCompressRotate!, completionHandler: { (response,failure, error) in
                    if error != nil{
                        print("error Upload Selfie \(String(describing: error))")
                        self.successUploadSelfie = false
                        return
                    }
                    if failure != nil{
                        self.successUploadSelfie = false
                        var fail = Failure()
                        fail.deserialize(failure!)
                        print("failure Upload Selfie message \(fail.message)")
                        CustomAlert().Error(message: fail.message)
                        //do action failure here
                        return
                    }
                    self.successUploadSelfie = true
                    var userSelfie:UserSelfie = UserSelfie()
                    userSelfie.deserialize(response!)
                    CustomAlert().Success(message: Wording.FINISH_EXAM_MESSAGE)
                    HUD().hide()
                    self.dismiss(animated: true, completion: {
                        self.fotoAgain = false
                    })
                    
                })
            }
            //upload foto then go to hasil ujian
            //            self.performSegue(withIdentifier: "hasilUjian", sender: self)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true) {
            //set cancel open camera forever
            self.fotoAgain = false
            
//            let alert = UIAlertController(title: Wording.FINISH_EXAM_TITLE, message: Wording.FINISH_EXAM_SUCCESS_MESSAGE, preferredStyle: UIAlertControllerStyle.alert)
//
//            let alertOKAction=UIAlertAction(title:"OK", style: UIAlertActionStyle.default,handler: { action in
//                // camera
//                self.openCamera()
//            })
//            alert.addAction(alertOKAction)
//            self.present(alert, animated: true, completion: nil)
        }
    }
}
