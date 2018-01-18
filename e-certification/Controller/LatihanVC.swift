//
//  LatihanVC.swift
//  e-certification
//
//  Created by Syarif on 1/17/18.
//  Copyright © 2018 infovesta. All rights reserved.
//

import UIKit

class LatihanVC: UIViewController {

    @IBOutlet weak var tblLatihan: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //statusbar
        let app = UIApplication.shared
        app.statusBarStyle = .lightContent
        // Do any additional setup after loading the view.
        self.setTblLatihan()
        
    }
    
    func setTblLatihan(){
        self.tblLatihan.delegate = self
        self.tblLatihan.dataSource = self
        self.tblLatihan.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension LatihanVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 53
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:LatihanCell = tableView.dequeueReusableCell(withIdentifier: "LatihanCellIdentifier", for: indexPath) as! LatihanCell
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

