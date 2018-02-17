//
//  LatihanHistoryVC.swift
//  e-certification
//
//  Created by Syarif on 18/02/18.
//  Copyright © 2018 infovesta. All rights reserved.
//

import UIKit

class LatihanHistoryVC: UIViewController {
    @IBOutlet weak var tblLatihan: UITableView!
    var modul:ModulLatihan!
    var listSoal:ListQuestionLatihan!
    var history:BaseHistoryLatihan! = BaseHistoryLatihan()
    var indexChoosed = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //statusbar
        let app = UIApplication.shared
        app.statusBarStyle = .lightContent
        // Do any additional setup after loading the view.
        self.loadHistory()
    }

    func loadHistory(){
        ApiManager().getListHistoryLatihan(self.modul.sub_module_id) { (response,failure, error) in
            if error != nil{
                print("error load List History Latihan \(String(describing: error))")
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
            
            self.history.deserialize(response!)
            self.setTblLatihan()
        }
    }
    
    func setTblLatihan(){
        self.tblLatihan.delegate = self
        self.tblLatihan.dataSource = self
        self.tblLatihan.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "reviewHistoryLatihan"){
            let vc = segue.destination as! LatihanListSoalVC
            vc.listSoal = self.listSoal
            vc.isHistory = true
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

extension LatihanHistoryVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history.data.listDetailHistory.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 53
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:LatihanCell = tableView.dequeueReusableCell(withIdentifier: "LatihanCellIdentifier", for: indexPath) as! LatihanCell
        cell.selectionStyle = .none
        cell.lblTitle.text = modul.module_title
        cell.lblDetail.text = modul.sub_module_title
        cell.btnStart.tag = indexPath.row
        cell.btnStart.addTarget(self, action: #selector(openInfo(sender:)), for: .touchUpInside)
        return cell
    }
    
    @objc func openInfo(sender: UIButton!){
        //        sender.tag
        self.indexChoosed = sender.tag
        var str = self.history.data.listDetailHistory[indexChoosed].history
        str = str.replacingOccurrences(of: "\\", with: "")
        let dict = convertToDictionary(text: str)
        LatihanAnswer.arrAnswer = dict!
        LatihanAnswer.isFinished = true
//        print("\(LatihanAnswer.arrAnswer)")
        
        self.performSegue(withIdentifier: "reviewHistoryLatihan", sender: self)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func convertToDictionary(text: String) -> [[String: String]]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] as? [[String : String]]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}
