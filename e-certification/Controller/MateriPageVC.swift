//
//  MateriPageVC.swift
//  e-certification
//
//  Created by Syarif on 1/12/18.
//  Copyright © 2018 infovesta. All rights reserved.
//

import UIKit

class MateriPageVC: UIViewController {
    
    @IBOutlet weak var tblMateri: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setTblMateri()
        
    }
    
    func setTblMateri(){
        self.tblMateri.delegate = self
        self.tblMateri.dataSource = self
        self.tblMateri.reloadData()
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
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 53
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MateriCell = tableView.dequeueReusableCell(withIdentifier: "MateriCellIdentifier", for: indexPath) as! MateriCell
        cell.selectionStyle = .none
        cell.setImageTitle(text: "Bab \(indexPath.row + 1)", isNew: true)
        cell.setActions(urlPdf: "http://kmmc.in/wp-content/uploads/2014/01/lesson2.pdf", urlVideo: "http://www.sample-videos.com/video/mp4/480/big_buck_bunny_480p_30mb.mp4")
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension MateriPageVC: MateriCellDelegate {
    func proccessPDF(name: String, title: String) {
        
    }
    
    func proccessVideo(name: String, title: String) {
        let detailMateriVideoVC = storyboard?.instantiateViewController(withIdentifier: "DetailMateriVideoVC") as! DetailMateriVideoVC
        detailMateriVideoVC.title_ = title
        detailMateriVideoVC.fileName = name
        self.navigationController?.pushViewController(detailMateriVideoVC, animated: true)
    }
}
