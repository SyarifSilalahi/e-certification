//
//  UjianListSoalVC.swift
//  e-certification
//
//  Created by Syarif on 1/20/18.
//  Copyright © 2018 infovesta. All rights reserved.
//

import UIKit
import MZTimerLabel

class UjianListSoalVC: UIViewController {
    
    @IBOutlet weak var collectionMenu: UICollectionView!
    @IBOutlet weak var btnSelesai: UIButton!
    @IBOutlet weak var lblCounter: UILabel!
    @IBOutlet weak var lblTimer: MZTimerLabel!
    
    var listSoal:ListQuestionUjian! = ListQuestionUjian()
    var indexSelected = 0
    let imagePicker = UIImagePickerController()
    var nilai = 0
    var successUploadSelfie = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //statusbar
        let app = UIApplication.shared
        app.statusBarStyle = .lightContent
        // Do any additional setup after loading the view.
        self.imagePicker.delegate = self
        self.getListSoal()
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appWillTerminate), name: Notification.Name.UIApplicationWillTerminate, object: nil)
        notificationCenter.addObserver(self, selector: #selector(appMovedToForeground), name: Notification.Name.UIApplicationWillEnterForeground, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.setLblCounter()
        self.collectionMenu.reloadData()
        self.setTimer()
        if UjianAnswer.isFinished{
            self.finishExam()
        }
    }
    
    func setLblCounter(){
        var totalSelected = 0
        for i in 0..<self.listSoal.data.count{
            if UjianAnswer.arrAnswer[i]["choosed"] != ""{
                totalSelected += 1
            }
        }
        self.lblCounter.text = "\(totalSelected) / \(self.listSoal.data.count)"
    }
    
    @objc func appMovedToForeground() {
        print("App moved to background!")
        //submit score here
        let alert = UIAlertController(title: Wording.FINISH_EXAM_TITLE, message: Wording.FINISH_EXAM_EXIT_MESSAGE, preferredStyle: UIAlertControllerStyle.alert)
        
        let alertOKAction=UIAlertAction(title:"OK", style: UIAlertActionStyle.default,handler: { action in
            //finish exam
            self.finishExam()
        })
        alert.addAction(alertOKAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func appWillTerminate() {
        print("App WillTerminate!")
        //set status score here
        Session.userChace.set(UjianAnswer.arrAnswer , forKey: Session.FORCE_EXIT_EXAM)
    }
    
    func getListSoal(){
        self.lblCounter.text = "0 / \(self.listSoal.data.count)"
        self.setMenuCollection()
    }
    
    func setTimer(){
        let intervalDate = UjianAnswer.endDateExam.timeIntervalSince(Date())
        if !UjianAnswer.isFinished && intervalDate > 0{
            //set timer
            self.lblTimer.setCountDownTime(TimeInterval(intervalDate))
            self.lblTimer.timerType = MZTimerLabelTypeTimer
            self.lblTimer.timeFormat = "HH:mm:ss"
            self.lblTimer.delegate = self
            self.lblTimer.start()
        }else{
            self.lblTimer.reset()
            self.lblTimer.text = "00:00:00"
        }
    }
    
    func setMenuCollection(){
        self.collectionMenu.dataSource=self
        self.collectionMenu.delegate=self
        let collectionViewLayout:UICollectionViewFlowLayout = self.collectionMenu.collectionViewLayout as! UICollectionViewFlowLayout
        let size = (self.view.frame.size.width / 4) - 35
        let cellheight = size
        let cellwidth = size
        collectionViewLayout.itemSize = CGSize(width: cellwidth, height: cellheight )
        self.collectionMenu.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "openDetailSoalUjian") {
            let vc = segue.destination as! UjianDetailSoalVC
            vc.index = self.indexSelected
            vc.listSoal = self.listSoal
        }else if (segue.identifier == "hasilUjian"){
            let vc = segue.destination as! HasilUjianVC
            vc.nilai = self.nilai
        }
    }
    
    func finishExam(){
        self.lblTimer.reset()
        self.collectionMenu.reloadData()
        for dic in UjianAnswer.arrAnswer{
            if dic["status"] == "true"{
                nilai += 1
            }
        }
        
        //buat testing lulus
//        nilai = 80
        
        print("nilai \(nilai)")
        ApiManager().setScoreUjian(nilai: "\(nilai)") { (response,failure, error) in
            if error != nil{
                print("error setScoreUjian \(String(describing: error))")
                return
            }
            if failure != nil{
                var fail = Failure()
                fail.deserialize(failure!)
                print("failure setScoreUjian message \(fail.message)")
//                CustomAlert().Error(message: fail.message)
                //do action failure here
                return
            }
//            print("response ujian \(response)")
            var hasilUjian:ScoreExam = ScoreExam()
            hasilUjian.deserialize(response!)
//            print("hasilUjian \(hasilUjian)")
            if hasilUjian.data == ExamStatus.Lulus.rawValue{
                let alert = UIAlertController(title: Wording.FINISH_EXAM_TITLE, message: Wording.FINISH_EXAM_SUCCESS_MESSAGE, preferredStyle: UIAlertControllerStyle.alert)
                
                let alertOKAction=UIAlertAction(title:"OK", style: UIAlertActionStyle.default,handler: { action in
                    // camera
                    self.openCamera()
                })
                alert.addAction(alertOKAction)
                self.present(alert, animated: true, completion: nil)
            }else{
                let alert = UIAlertController(title: Wording.FINISH_EXAM_TITLE, message: Wording.FINISH_EXAM_MESSAGE, preferredStyle: UIAlertControllerStyle.alert)
                
                let alertOKAction=UIAlertAction(title:"OK", style: UIAlertActionStyle.default,handler: { action in
                    self.navigationController?.popViewController(animated: true)
                })
                alert.addAction(alertOKAction)
                self.present(alert, animated: true, completion: nil)
            }
            
        }
        
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    @IBAction func selesai(_ sender: AnyObject) {
        if UjianAnswer.isFinished == false{
            UjianAnswer.isFinished = true
            self.finishExam()
        }else{
            if !self.successUploadSelfie{
                self.openCamera()
            }else{
                self.navigationController?.popViewController(animated: true)
            }
        }
        
    }
    
    func openCamera(){
        self.imagePicker.allowsEditing = true
        self.imagePicker.sourceType = .camera
        self.imagePicker.cameraDevice = .front
        self.present(self.imagePicker, animated: true, completion: nil)
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

extension UjianListSoalVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listSoal.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: MenuCVCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCVCellIdentifier", for: indexPath) as! MenuCVCell
        cell.lblTitle.text = "\(indexPath.row + 1)"
        
        if UjianAnswer.isFinished{
            if UjianAnswer.arrAnswer[indexPath.row]["status"] == "true"{
                cell.setModeCorrect()
            }else {
                cell.setModeInCorrect()
            }
        }else{
            if UjianAnswer.arrAnswer[indexPath.row]["choosed"] == ""{
                cell.setModeNormal()
            }else{
                cell.setModeSelected()
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !UjianAnswer.isFinished{
            self.indexSelected = indexPath.row
            self.performSegue(withIdentifier: "openDetailSoalUjian", sender: self)
        }
    }
}

extension UjianListSoalVC: MZTimerLabelDelegate {
    
    func timerLabel(_ timerLabel: MZTimerLabel!, finshedCountDownTimerWithTime countTime: TimeInterval) {
        print("timer finished")
        UjianAnswer.isFinished = true
        self.alertTimesUp()
    }
    
    func timerLabel(_ timerLabel: MZTimerLabel!, countingTo time: TimeInterval, timertype timerType: MZTimerLabelType) {
        
    }
    
    func alertTimesUp(){
        let alert = UIAlertController(title: Wording.FINISH_EXAM_TITLE, message: Wording.FINISH_EXAM_TIMESUP_MESSAGE, preferredStyle: UIAlertControllerStyle.alert)
        
        let alertOKAction=UIAlertAction(title:"OK", style: UIAlertActionStyle.default,handler: { action in
            //finish exam
            //submit jawaban (score)
            self.finishExam()
        })
        alert.addAction(alertOKAction)
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension UjianListSoalVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage{
//            self.imgProfilePicture.image = pickedImage
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
                
                //set foto user
                ApiManager().uploadImageSelfie(image: compressImageAvatar!,imageLicense: compressImageLisence!, completionHandler: { (response,failure, error) in
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
                    
                })
            }
            
            //upload foto then go to hasil ujian
            //            self.performSegue(withIdentifier: "hasilUjian", sender: self)
            
            self.dismiss(animated: true, completion: {
                self.navigationController?.popViewController(animated: true)
            })
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true) {
//            UjianAnswer.isFinished = false
        }
    }
}
