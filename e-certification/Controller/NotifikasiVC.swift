//
//  NotivikasiVC.swift
//  e-certification
//
//  Created by Syarif on 1/20/18.
//  Copyright © 2018 infovesta. All rights reserved.
//

import UIKit

class NotifikasiVC: UIViewController {
    
    @IBOutlet weak var tblNotif: UITableView!
    @IBOutlet weak var txtSearch: UITextField!
    var listNotif:ListNotification = ListNotification()
    var indexChoosed = 0
    var arrSearchDataNotification:[DataNotification] = []
    var arrIndexRead:[Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.getNotification()
    }
    
    func getNotification(){
        ApiManager().getNotification { (response,failure, error) in
            if error != nil{
                print("error load Notification \(String(describing: error))")
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
            self.listNotif.deserialize(response!)
            self.arrSearchDataNotification = self.listNotif.data
            
            if Session.userChace.value(forKey: Session.CHECK_NEW_NOTIF) != nil{
                //reset is new notif
                var arrInfoNotif:[[String:String]] = []
                arrInfoNotif = Session.userChace.value(forKey: Session.CHECK_NEW_NOTIF) as! [[String : String]]
                var index = 0
                for dicInfoNotif in arrInfoNotif{
                    if dicInfoNotif["user"] == Session.userChace.value(forKey: Session.EMAIL) as? String {
                        index += 1
                    }
                }
                
                if index == 0{ //user not found
                    let dicInfoNotif = [
                        "user" : "\(Session.userChace.value(forKey: Session.EMAIL) as! String)",
                        "total_notif" : "\(self.listNotif.data.count)"
                    ]
                    arrInfoNotif.append(dicInfoNotif)
                    Session.userChace.set(arrInfoNotif, forKey: Session.CHECK_NEW_NOTIF)
                }else{ // user found
                    if Int(arrInfoNotif[index - 1]["total_notif"]!)! < self.listNotif.data.count {
                        let dicInfoNotif = [
                            "user" : "\(Session.userChace.value(forKey: Session.EMAIL) as! String)",
                            "total_notif" : "\(self.listNotif.data.count)"
                        ]
                        arrInfoNotif[index - 1] = dicInfoNotif
                        Session.userChace.set(arrInfoNotif, forKey: Session.CHECK_NEW_NOTIF)
                    }
                }
            }
            
            self.setTblNotif()
        }
    }
    func setTblNotif(){
        self.tblNotif.delegate = self
        self.tblNotif.dataSource = self
        self.tblNotif.reloadData()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.txtSearch.resignFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "openDetailNotification") {
            let vc = segue.destination as! NotifikasiDetailVC
            vc.detailNotifikasi = self.listNotif.data[self.indexChoosed]
        }
    }
    
    @IBAction func back(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
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

extension NotifikasiVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrSearchDataNotification.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:NotifCell = tableView.dequeueReusableCell(withIdentifier: "NotifCellIdentifier", for: indexPath) as! NotifCell
        cell.selectionStyle = .none
        if Session.userChace.value(forKey: Session.ID_NOTIF_READ) == nil {
            cell.imgDot.alpha = 1
        }else{
            self.arrIndexRead = Session.userChace.value(forKey: Session.ID_NOTIF_READ) as! [Int]
            if self.arrIndexRead.contains(self.arrSearchDataNotification[indexPath.row].user_notification_id){
                cell.imgDot.alpha = 0
            }else{
                cell.imgDot.alpha = 1
            }
        }
        cell.lblTitle.text = self.arrSearchDataNotification[indexPath.row].title
        cell.lblDetail.text = self.arrSearchDataNotification[indexPath.row].description
        cell.lblTime.text = self.arrSearchDataNotification[indexPath.row].created_at.toNormalFormat()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if Session.userChace.value(forKey: Session.ID_NOTIF_READ) == nil {
            self.arrIndexRead = []
            self.arrIndexRead.append(self.arrSearchDataNotification[indexPath.row].user_notification_id)
            Session.userChace.set(self.arrIndexRead, forKey: Session.ID_NOTIF_READ)
        }else{
            self.arrIndexRead = Session.userChace.value(forKey: Session.ID_NOTIF_READ) as! [Int]
            if self.arrIndexRead.contains(self.arrSearchDataNotification[indexPath.row].user_notification_id){
            }else{
                self.arrIndexRead.append(self.arrSearchDataNotification[indexPath.row].user_notification_id)
                Session.userChace.set(self.arrIndexRead, forKey: Session.ID_NOTIF_READ)
            }
        }
        self.indexChoosed = indexPath.row
        self.performSegue(withIdentifier: "openDetailNotification", sender: self)
    }
}

extension NotifikasiVC:UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Combine the textView text and the replacement text to
        // create the updated text string
        let currentText = textField.text
        let updatedText = currentText?.replacingCharacters(in: (currentText?.range(from: range))!, with: string)
        self.searchProgram(searchText: updatedText!)
        return true
    }
    
    func searchProgram(searchText: String) {
        if searchText == "" {
            self.arrSearchDataNotification = self.listNotif.data
        }else{
            self.arrSearchDataNotification = self.listNotif.data.filter({ (dataNotif) -> Bool in
                if (dataNotif.title.range(of: searchText, options: .caseInsensitive) != nil){
                    return true
                }else {
                    return false
                }
            })
        }
        self.tblNotif.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}
