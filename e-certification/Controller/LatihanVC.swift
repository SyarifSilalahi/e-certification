//
//  LatihanVC.swift
//  e-certification
//
//  Created by Syarif on 1/17/18.
//  Copyright © 2018 infovesta. All rights reserved.
//

import UIKit
import Arrow

class LatihanVC: UIViewController {

    @IBOutlet weak var tblLatihan: UITableView!
    @IBOutlet weak var btnNotification: UIButton!
    var dataModulLatihan = ListModulLatihan()
    var indexChoosed = 0
    var listSoal:ListQuestionLatihan! = ListQuestionLatihan()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //statusbar
        let app = UIApplication.shared
        app.statusBarStyle = .lightContent
        // Do any additional setup after loading the view.
        self.loadSubModul()
        
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
    
    func loadSubModul(){
        ApiManager().getModulLatihan { (response,failure, error) in
            if error != nil{
                print("error load Latihan \(String(describing: error))")
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
            self.dataModulLatihan.deserialize(response!)
            //            print("data materi \(self.dataMateri)")
            self.setTblLatihan()
        }
    }
    
    func setTblLatihan(){
        self.tblLatihan.delegate = self
        self.tblLatihan.dataSource = self
        self.tblLatihan.reloadData()
    }
    
    @IBAction func showHistory(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "showHistoryLatihan", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "infoLatihan") {
            let vc = segue.destination as! LatihanInfoVC
            vc.modul = self.dataModulLatihan.data[self.indexChoosed]
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension LatihanVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataModulLatihan.data.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 53
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:LatihanCell = tableView.dequeueReusableCell(withIdentifier: "LatihanCellIdentifier", for: indexPath) as! LatihanCell
        cell.selectionStyle = .none
        cell.lblTitle.text = self.dataModulLatihan.data[indexPath.row].module_title
        cell.lblDetail.text = self.dataModulLatihan.data[indexPath.row].sub_module_title
        cell.btnStart.tag = indexPath.row
        cell.btnStart.addTarget(self, action: #selector(openInfo(sender:)), for: .touchUpInside)
        return cell
    }
    
    @objc func openInfo(sender: UIButton!){
//        sender.tag
        self.indexChoosed = sender.tag
        self.performSegue(withIdentifier: "infoLatihan", sender: self)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

