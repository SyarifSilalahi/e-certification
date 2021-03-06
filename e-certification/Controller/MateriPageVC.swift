//
//  MateriPageVC.swift
//  e-certification
//
//  Created by Syarif on 1/12/18.
//  Copyright © 2018 infovesta. All rights reserved.
//

import UIKit
import Arrow
import Digger

class MateriPageVC: UIViewController {
    
    @IBOutlet weak var tblMateri: UITableView!
    @IBOutlet weak var btnNotification: UIButton!
    var dataMateri = ListMateri()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //statusbar
        let app = UIApplication.shared
        app.statusBarStyle = .lightContent
        // Do any additional setup after loading the view.
    }
    
    func loadMateri(){
        ApiManager().getMateri { (response,failure, error) in
            if error != nil{
                print("error load Materi \(String(describing: error))")
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
            self.dataMateri.deserialize(response!)
//            print("data materi \(self.dataMateri)")
            self.setTblMateri()
        }
    }
    
    func setTblMateri(){
        self.tblMateri.delegate = self
        self.tblMateri.dataSource = self
        self.tblMateri.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.loadMateri()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getNotification()
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

extension MateriPageVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataMateri.data.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MateriCell = tableView.dequeueReusableCell(withIdentifier: "MateriCellIdentifier", for: indexPath) as! MateriCell
        cell.selectionStyle = .none
        cell.setTitle(text: "\(dataMateri.data[indexPath.row].title)", isNew: false)
        cell.lblDetail.text = dataMateri.data[indexPath.row].description
        cell.description_ = dataMateri.data[indexPath.row].description
        //data url nya dari api suka berubah2 jadi harus sering2 di cek buat mastiin
        cell.setActions(urlPdf: "\(dataMateri.data[indexPath.row].host_file)/\(dataMateri.data[indexPath.row].document)", urlVideo: "\(dataMateri.data[indexPath.row].host_file)/\(dataMateri.data[indexPath.row].video)")
        cell.videoTimeFlag = dataMateri.data[indexPath.row].video_next
        cell.update = dataMateri.data[indexPath.row].updated_at
        cell.delegate = self
        
//        //for testing
//        if indexPath.row == 0 {
//            cell.setActions(urlPdf: "\(dataMateri.data[indexPath.row].host_file)\(dataMateri.data[indexPath.row].document)", urlVideo: "http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
//            cell.videoTimeFlag = "0,15,30,40,50"
//        }else{
//            //normal nya
//
//        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

}

extension MateriPageVC: MateriCellDelegate {
    func proccessPDF(name: String, title: String, detail: String, update:String, description: String) {
        let detailMateriPDFVC = storyboard?.instantiateViewController(withIdentifier: "DetailMateriPDFVC") as! DetailMateriPDFVC
        detailMateriPDFVC.title_ = title
        detailMateriPDFVC.detail = detail
        detailMateriPDFVC.description_ = description
        detailMateriPDFVC.fileName = name
        detailMateriPDFVC.update = update
        self.navigationController?.pushViewController(detailMateriPDFVC, animated: true)
    }
    
    func proccessVideo(name: String, title: String, detail: String, update:String, description: String, timeFlag: String) {
        let detailMateriVideoVC = storyboard?.instantiateViewController(withIdentifier: "DetailMateriVideoVC") as! DetailMateriVideoVC
        detailMateriVideoVC.title_ = title
        detailMateriVideoVC.detail = detail
        detailMateriVideoVC.description_ = description
        detailMateriVideoVC.fileName = name
        detailMateriVideoVC.videoTimeFlag = timeFlag
        detailMateriVideoVC.update = update
        self.navigationController?.pushViewController(detailMateriVideoVC, animated: true)
    }
    
    func startDownloadVideo(url: String) {
        DiggerManager.shared.startTask(for: url)
    }
    
    func stopDownloadVideo(url: String) {
        DiggerManager.shared.stopTask(for: url)
    }
}
