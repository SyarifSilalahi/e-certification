//
//  UjianDetailSoalVC.swift
//  e-certification
//
//  Created by Syarif on 1/23/18.
//  Copyright © 2018 infovesta. All rights reserved.
//

import UIKit
import CountdownLabel

class UjianDetailSoalVC: UIViewController {
    
    @IBOutlet weak var tblSoal: UITableView!
    @IBOutlet weak var lblSoal: UILabel!
    @IBOutlet weak var lblCounterNext: UILabel!
    @IBOutlet weak var lblCounterBack: UILabel!
    @IBOutlet weak var lblCounter: UILabel!
    @IBOutlet var lblTimer: CountdownLabel!
    
    var listSoal:ListQuestionUjian! = ListQuestionUjian()
    
    var index = 0
    var indexpathRow = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.lblSoal.text = self.listSoal.data[index].question
        self.setLblCounter()
        self.tblSoal.dataSource = self
        self.tblSoal.delegate = self
        self.tblSoal.reloadData()
        
        //set timer
        self.lblTimer.setCountDownTime(minutes: 3000)
        self.lblTimer.animationType = CountdownEffect.Evaporate
        self.lblTimer.timeFormat = "hh:mm:ss"
        self.lblTimer.delegate = self as? LTMorphingLabelDelegate
        self.lblTimer.start()
    }

    func setLblCounter(){
        self.lblCounter.text = "\(index + 1) / \(self.listSoal.data.count)"
        if self.index > 0{
            self.lblCounterBack.text = "\(self.index )"
            self.lblCounterNext.text = "\(self.index + 1 + 1)"
            if index  == self.listSoal.data.count - 1 {
                self.lblCounterNext.text = "\(self.index + 1)"
            }
        }else{
            self.lblCounterBack.text = "\(self.index + 1)"
            self.lblCounterNext.text = "\(self.index + 1 + 1)"
        }
    }
    
    @IBAction func soalNext(_ sender: AnyObject) {
        if index < self.listSoal.data.count - 1 {
            self.indexpathRow = -1
            index += 1
            self.setLblCounter()
            //get next soal
            self.lblSoal.text = self.listSoal.data[index].question
            self.tblSoal.reloadData()
        }
    }
    
    @IBAction func soalBack(_ sender: AnyObject) {
        if index > 0{
            self.indexpathRow = -1
            index -= 1
            self.setLblCounter()
            //get back soal
            self.lblSoal.text = self.listSoal.data[index].question
            self.tblSoal.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
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

extension UjianDetailSoalVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:OpsiSoalCell = tableView.dequeueReusableCell(withIdentifier: "OpsiSoalCellIdentifier", for: indexPath) as! OpsiSoalCell
        cell.selectionStyle = .none
        switch indexPath.row {
        case 0:
            cell.lblTitle.text = "A."
            cell.lblDetail.text = self.listSoal.data[self.index].option1
            break
        case 1:
            cell.lblTitle.text = "B."
            cell.lblDetail.text = self.listSoal.data[self.index].option2
            break
        case 2:
            cell.lblTitle.text = "C."
            cell.lblDetail.text = self.listSoal.data[self.index].option3
            break
        case 3:
            cell.lblTitle.text = "C."
            cell.lblDetail.text = self.listSoal.data[self.index].option4
            break
        default:
            break
        }
        if self.indexpathRow == indexPath.row{
            cell.modeSelect()
        }else{
            cell.modeNormal()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.indexpathRow = indexPath.row
        self.tblSoal.reloadData()
    }
}

extension UjianDetailSoalVC: CountdownLabelDelegate {
    func countdownFinished() {
        debugPrint("countdownFinished at delegate.")
        //completion
        print("timer finished")
    }
    
    internal func countingAt(timeCounted: TimeInterval, timeRemaining: TimeInterval) {
        debugPrint("time counted at delegate=\(timeCounted)")
        debugPrint("time remaining at delegate=\(timeRemaining)")
    }
    
}
