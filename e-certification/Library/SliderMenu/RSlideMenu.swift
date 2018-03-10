//
//  RSlideMenu.swift
//  SliderMenu
//
//  Created by Uber - Abdul on 21/02/17.
//  Copyright © 2017 example.com. All rights reserved.
//

import UIKit
import Arrow

class RSlideMenu: UIViewController {
    
    @IBOutlet weak var tblMenu: UITableView!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnLogout: UIButton!
    
    var dataUser = UserAuthData()
    
    var lisenceID = ""
    var expDate = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //statusbar
        let app = UIApplication.shared
        app.isStatusBarHidden = true
        self.navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view.
        
        let data = JSON(Session.userChace.object(forKey: Session.KEY_AUTH) as AnyObject?)
        dataUser.deserialize(data!)
        self.lblName.text = dataUser.name
        custamizeMenu()
        setTblMenu()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.btnLogout.isUserInteractionEnabled = false
        ApiManager().getExamStatus(isHUD: false) { (response,failure, error) in
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
            var examStatus:StatusExam! = StatusExam()
            examStatus.deserialize(response!)
            if examStatus.status_exam == ExamStatus.Lulus.rawValue {
                ApiManager().getLisence { (response,failure, error) in
                    if error != nil{
                        print("error load Membership \(String(describing: error))")
                        return
                    }
                    if failure != nil{
                        var fail = Failure()
                        fail.deserialize(failure!)
                        print("failure message \(fail.message)")
                        //                CustomAlert().Error(message: fail.message)
                        return
                    }
                    
                    //json data model
                    var membership:Membership = Membership()
                    membership.deserialize(response!)
                    self.lisenceID = membership.lisence.no_license
                    if self.lisenceID != "" {
                        self.expDate = membership.lisence.expired_date
                    }
                    
                    self.tblMenu.reloadData()
                    self.btnLogout.isUserInteractionEnabled = true
                }
            }
        }
    }
    
    func setTblMenu(){
        self.tblMenu.delegate = self
        self.tblMenu.dataSource = self
        self.tblMenu.reloadData()
    }
    
    func custamizeMenu() {
        SideMenuManager.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        
        SideMenuManager.menuWidth = 238
        SideMenuManager.menuFadeStatusBar = false
        SideMenuManager.menuPresentMode = .menuSlideIn
    }
    
    @IBAction func back(_ sender: AnyObject) {
        self.navigationController?.dismiss(animated: true, completion: {
            //nil
        })
    }
    
    @IBAction func logOut(_ sender: AnyObject) {
        let alert = UIAlertController(title: nil, message: Wording.LOGOUT_MESSAGE , preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Batal", style: .cancel) { action in
            // perhaps use action.title here
        })
        
        alert.addAction(UIAlertAction(title: "Keluar", style: .destructive) { action in
            //do logout
            //clear session
            Session.userChace.removeObject(forKey: Session.EMAIL)
            Session.userChace.removeObject(forKey: Session.KEY_AUTH)
//            Session.userChace.removeObject(forKey: Session.ID_NOTIF_READ)
            //force back to login
            self.performSegue(withIdentifier: "unwindToViewController1", sender: self)
        })
        
        self.present(alert, animated: true, completion: nil)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //statusbar
        let app = UIApplication.shared
        app.isStatusBarHidden = false
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

extension RSlideMenu:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height:CGFloat = 42
        switch indexPath.row {
        case 0:
            if height < Helper().heightForView(self.dataUser.name, font: UIFont.systemFont(ofSize: 13, weight: .regular), width: self.tblMenu.frame.size.width - 112) {
                height = Helper().heightForView(self.dataUser.name, font: UIFont.systemFont(ofSize: 13, weight: .regular), width: self.tblMenu.frame.size.width - 112) + 30
            }
            break
        case 1:
            if height < Helper().heightForView((Session.userChace.object(forKey: Session.EMAIL) as? String)!, font: UIFont.systemFont(ofSize: 13, weight: .regular), width: self.tblMenu.frame.size.width - 112) {
                height = Helper().heightForView((Session.userChace.object(forKey: Session.EMAIL) as? String)!, font: UIFont.systemFont(ofSize: 13, weight: .regular), width: self.tblMenu.frame.size.width - 112) + 30
            }
            break
        case 2:
            
            break
        case 3:
            if height < Helper().heightForView("\(lisenceID)", font: UIFont.systemFont(ofSize: 13, weight: .regular), width: self.tblMenu.frame.size.width - 112) {
                height = Helper().heightForView("\(lisenceID)", font: UIFont.systemFont(ofSize: 13, weight: .regular), width: self.tblMenu.frame.size.width - 112) + 30
            }
            break
        case 4:
            
            break
        default:
            break
        }
        return CGFloat(height)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MenuCell = tableView.dequeueReusableCell(withIdentifier: "MenuCellIdentifier", for: indexPath) as! MenuCell
        cell.selectionStyle = .none
        switch indexPath.row {
        case 0:
            cell.lblTitle.text = "Nama"
            cell.lblDetail.text = self.dataUser.name
            break
        case 1:
            cell.lblTitle.text = "Email"
            cell.lblDetail.text = Session.userChace.object(forKey: Session.EMAIL) as? String
            break
        case 2:
            cell.lblTitle.text = "Ubah Sandi"
            cell.lblDetail.text = "************"
            break
        case 3:
            cell.lblTitle.text = "No Lisensi"
            cell.lblDetail.text = "\(lisenceID)"
            break
        case 4:
            cell.lblTitle.text = "Berlaku s/d"
            cell.lblDetail.text = "\(expDate)"
            break
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 {
//            let alert = UIAlertController(title: "Informasi.", message: Wording.CHANGE_PASSWORD_MESSAGE, preferredStyle: UIAlertControllerStyle.alert)
//
//            let alertOKAction=UIAlertAction(title:"OK", style: UIAlertActionStyle.default,handler: { action in
//
//            })
//            alert.addAction(alertOKAction)
//            self.present(alert, animated: true, completion: nil)
            self.performSegue(withIdentifier: "changePassword", sender: self)
        }
    }
}
