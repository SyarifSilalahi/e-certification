//
//  RSlideMenu.swift
//  SliderMenu
//
//  Created by Uber - Abdul on 21/02/17.
//  Copyright © 2017 example.com. All rights reserved.
//

import UIKit

class RSlideMenu: UIViewController {
    
    @IBOutlet weak var tblMenu: UITableView!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //statusbar
        let app = UIApplication.shared
        app.isStatusBarHidden = true
        self.navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view.
        custamizeMenu()
        setTblMenu()
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
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 42
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MenuCell = tableView.dequeueReusableCell(withIdentifier: "MenuCellIdentifier", for: indexPath) as! MenuCell
        cell.selectionStyle = .none
        switch indexPath.row {
        case 0:
            cell.lblTitle.text = "Kartu Anggota"
            cell.lblDetail.text = "0000-0000-000"
            break
        case 1:
            cell.lblTitle.text = "Ubah Password"
            cell.lblDetail.text = ""
            break
        case 2:
            cell.lblTitle.text = "Tanggal Aktif"
            cell.lblDetail.text = "21/07/2017"
            break
        case 3:
            cell.lblTitle.text = "Masa Berlaku"
            cell.lblDetail.text = "6 bulan"
            break
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
