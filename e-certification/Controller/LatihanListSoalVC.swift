//
//  LatihanListSoalVC.swift
//  e-certification
//
//  Created by Syarif on 1/19/18.
//  Copyright © 2018 infovesta. All rights reserved.
//

import UIKit

class LatihanListSoalVC: UIViewController {

    @IBOutlet weak var collectionMenu: UICollectionView!
    @IBOutlet weak var btnSelesai: UIButton!
    @IBOutlet weak var lblCounter: UILabel!
    
    var listSoal:ListQuestionLatihan! = ListQuestionLatihan()
    var indexSelected = 0
    var isHistory = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //statusbar
        let app = UIApplication.shared
        app.statusBarStyle = .lightContent
        // Do any additional setup after loading the view.
        self.lblCounter.text = "0 / \(self.listSoal.data.count)"
        self.setMenuCollection()
//        print(" isFinished \(LatihanAnswer.isFinished)\narrAnswer \(LatihanAnswer.arrAnswer)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.setLblCounter()
        self.collectionMenu.reloadData()
    }
    
    func setLblCounter(){
        if isHistory{
            self.lblCounter.text = "\(self.listSoal.data.count) / \(self.listSoal.data.count)"
        }else{
            var totalSelected = 0
            for i in 0..<self.listSoal.data.count{
                if LatihanAnswer.arrAnswer[i]["selected"] != ""{
                    totalSelected += 1
                }
            }
            self.lblCounter.text = "\(totalSelected) / \(self.listSoal.data.count)"
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
    
    
    @IBAction func back(_ sender: AnyObject) {
        if isHistory{
            self.navigationController?.popViewController(animated: true)
        }else{
            let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
            self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
        }
        
    }
    
    @IBAction func selesai(_ sender: AnyObject) {
        if LatihanAnswer.isFinished == false{
            let history = "\(LatihanAnswer.arrAnswer)"
            let replaced1 = history.replacingOccurrences(of: "[", with: "{")
            let newHistory = replaced1.replacingOccurrences(of: "]", with: "}")
            var historyJson = newHistory.replace(0, "[")
            historyJson = historyJson.replace(historyJson.characters.count - 1 , "]")
            ApiManager().setHistoryLatihan(self.listSoal.data[0].sub_module_id, history: historyJson, completionHandler: { (response,failure, error) in
                if error != nil{
                    print("error set History Latihan \(String(describing: error))")
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
                
                LatihanAnswer.isFinished = true
                self.collectionMenu.reloadData()
                CustomAlert().Success(message: Wording.FINISH_EXERCISE_MESSAGE)
                
            })
//            print("history JSON :\n\(historyJson)")
//            var nilai = 0
//            for dic in LatihanAnswer.arrAnswer{
//                if dic["status"] == "true"{
//                    nilai += 1
//                }
//            }
        }else{
            if isHistory{
                self.navigationController?.popViewController(animated: true)
            }else{
                let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
                self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "openDetailSoal") {
            let vc = segue.destination as! LatihanDetailSoalVC
            vc.index = self.indexSelected
            vc.listSoal = self.listSoal
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

extension LatihanListSoalVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listSoal.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: MenuCVCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCVCellIdentifier", for: indexPath) as! MenuCVCell
        cell.lblTitle.text = "\(indexPath.row + 1)"
        if LatihanAnswer.isFinished{
            if LatihanAnswer.arrAnswer[indexPath.row]["selected"] == LatihanAnswer.arrAnswer[indexPath.row]["answer"]{
                cell.setModeCorrect()
            }else {
                cell.setModeInCorrect()
            }
        }else{
            if LatihanAnswer.arrAnswer[indexPath.row]["selected"] == ""{
                cell.setModeNormal()
            }else{
                cell.setModeSelected()
            }
            
        }
//        if indexPath.row == 0 {
//            cell.setModeCorrect()
//        }else if indexPath.row == 3{
//            cell.setModeInCorrect()
//        }else{
//            cell.setModeNormal()
//        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.indexSelected = indexPath.row
        self.performSegue(withIdentifier: "openDetailSoal", sender: self)
    }
}
