//
//  UjianListSoalVC.swift
//  e-certification
//
//  Created by Syarif on 1/20/18.
//  Copyright © 2018 infovesta. All rights reserved.
//

import UIKit
import CountdownLabel

class UjianListSoalVC: UIViewController {
    
    @IBOutlet weak var collectionMenu: UICollectionView!
    @IBOutlet weak var btnSelesai: UIButton!
    @IBOutlet weak var lblCounter: UILabel!
    @IBOutlet var lblTimer: CountdownLabel!
    
    var listSoal:ListQuestionUjian! = ListQuestionUjian()
    var indexSelected = 0
    let imagePicker = UIImagePickerController()
    var nilai = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //statusbar
        let app = UIApplication.shared
        app.statusBarStyle = .lightContent
        // Do any additional setup after loading the view.
        self.imagePicker.delegate = self
        self.getListSoal()
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: Notification.Name.UIApplicationWillResignActive, object: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.setTimer()
        if UjianAnswer.isTimesUp{
            self.lblTimer.cancel()
            self.finishExam(message: Wording.FINISH_EXAM_TIMESUP_MESSAGE)
        }
    }
    
    @objc func appMovedToBackground() {
        print("App moved to background!")
        //submit score here
    }
    
    func getListSoal(){
        self.lblCounter.text = "0 / \(self.listSoal.data.count)"
        self.setMenuCollection()
    }
    
    func setTimer(){
        if !UjianAnswer.isFinished{
            //set timer
            self.lblTimer.setCountDownDate(fromDate: Date() as NSDate, targetDate: UjianAnswer.endDateExam as NSDate)
            self.lblTimer.animationType = CountdownEffect.Evaporate
            self.lblTimer.timeFormat = "hh:mm:ss"
            self.lblTimer.delegate = self as? LTMorphingLabelDelegate
            self.lblTimer.start()
        }else{
            self.lblTimer.cancel()
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
    
    func finishExam(message:String){
        self.lblTimer.cancel()
        self.collectionMenu.reloadData()
        for dic in UjianAnswer.arrAnswer{
            if dic["status"] == "true"{
                nilai += 1
            }
        }
        let alert = UIAlertController(title: Wording.FINISH_EXAM_TITLE, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let alertOKAction=UIAlertAction(title:"OK", style: UIAlertActionStyle.default,handler: { action in
            //finish exam
            //submit jawaban (score)
            
            // camera
            self.openCamera()
        })
        alert.addAction(alertOKAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func selesai(_ sender: AnyObject) {
        if UjianAnswer.isFinished == false{
            UjianAnswer.isFinished = true
            self.finishExam(message: Wording.FINISH_EXAM_TITLE)
        }else{
            self.navigationController?.popViewController(animated: true)
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
            cell.setModeNormal()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !UjianAnswer.isTimesUp{
            self.indexSelected = indexPath.row
            self.performSegue(withIdentifier: "openDetailSoalUjian", sender: self)
        }
    }
}

extension UjianListSoalVC: CountdownLabelDelegate {
    func countdownFinished() {
        debugPrint("countdownFinished at delegate.")
        //completion
        print("timer finished")
        UjianAnswer.isTimesUp = true
        self.finishExam(message: Wording.FINISH_EXAM_TIMESUP_MESSAGE)
    }
    
    internal func countingAt(timeCounted: TimeInterval, timeRemaining: TimeInterval) {
        debugPrint("time counted at delegate=\(timeCounted)")
        debugPrint("time remaining at delegate=\(timeRemaining)")
    }
    
}

extension UjianListSoalVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage{
//            self.imgProfilePicture.image = pickedImage
            //upload foto then go to hasil ujian
            self.performSegue(withIdentifier: "hasilUjian", sender: self)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true) {
            UjianAnswer.isFinished = false
        }
    }
}
