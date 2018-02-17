//
//  UjianDetailSoalVC.swift
//  e-certification
//
//  Created by Syarif on 1/23/18.
//  Copyright © 2018 infovesta. All rights reserved.
//

import UIKit
import MZTimerLabel

class UjianDetailSoalVC: UIViewController {
    
    @IBOutlet weak var tblSoal: UITableView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var lblSoal: UILabel!
    @IBOutlet weak var lblCounterNext: UILabel!
    @IBOutlet weak var lblCounterBack: UILabel!
    @IBOutlet weak var lblCounter: UILabel!
    @IBOutlet weak var btnCounterNext: UIButton!
    @IBOutlet weak var btnCounterBack: UIButton!
    @IBOutlet weak var lblTimer: MZTimerLabel!
    
    var listSoal:ListQuestionUjian! = ListQuestionUjian()
    
    var index = 0
    var indexpathRow = -1
    var arrOption:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appWillTerminate), name: Notification.Name.UIApplicationWillTerminate, object: nil)
        notificationCenter.addObserver(self, selector: #selector(appMovedToForeground), name: Notification.Name.UIApplicationWillEnterForeground, object: nil)
        
        self.lblSoal.text = self.listSoal.data[index].question
        
        self.arrOption = ["\(self.listSoal.data[index].option1)","\(self.listSoal.data[index].option2)","\(self.listSoal.data[index].option3)","\(self.listSoal.data[index].option4)"]
        self.arrOption = self.arrOption.shuffled
        
        self.setLblCounter()
        self.tblSoal.dataSource = self
        self.tblSoal.delegate = self
        self.tblSoal.reloadData()
        
        let contentHeight = Helper().heightForView(self.listSoal.data[index].question, font: UIFont.systemFont(ofSize: 15, weight: .bold), width: self.lblSoal.frame.size.width) + 50
        self.viewHeader.frame.size.height = contentHeight
        if index == 0 {
            setVisibilityBack(hide: true)
        }
        if index == self.listSoal.data.count - 1{
            setVisibilityNext(hide: true)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.setTimer()
    }
    
    func setTimer(){
        let intervalDate = UjianAnswer.endDateExam.timeIntervalSince(Date())
        if !UjianAnswer.isFinished && intervalDate > 0{
            //set timer
            self.lblTimer.setCountDownTime(TimeInterval(intervalDate))
            self.lblTimer.timerType = MZTimerLabelTypeTimer
            self.lblTimer.timeFormat = "HH:mm:ss"
            self.lblTimer.delegate = self
            self.lblTimer.start()
        }else{
            self.lblTimer.reset()
            self.lblTimer.text = "00:00:00"
        }
    }
    
    @objc func appMovedToForeground() {
        //submit score here
        let alert = UIAlertController(title: Wording.FINISH_EXAM_TITLE, message: Wording.FINISH_EXAM_EXIT_MESSAGE, preferredStyle: UIAlertControllerStyle.alert)
        
        let alertOKAction=UIAlertAction(title:"OK", style: UIAlertActionStyle.default,handler: { action in
            //finish exam
            UjianAnswer.isFinished = true
            self.navigationController?.popViewController(animated: true)
        })
        alert.addAction(alertOKAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func appWillTerminate() {
        print("App WillTerminate!")
        //set status score here
        Session.userChace.set(UjianAnswer.arrAnswer , forKey: Session.FORCE_EXIT_EXAM)
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
        self.resetHeaderSize()
    }
    
    func resetHeaderSize(){
        let contentHeight = Helper().heightForView(self.listSoal.data[index].question, font: UIFont.systemFont(ofSize: 15, weight: .bold), width: self.lblSoal.frame.size.width) + 50
        self.viewHeader.frame.size.height = contentHeight
        self.tblSoal.tableHeaderView = self.viewHeader
    }
    
    @IBAction func soalNext(_ sender: AnyObject) {
        if index < self.listSoal.data.count - 1 {
            self.setVisibilityBack(hide: false)
            self.indexpathRow = -1
            index += 1
            self.setLblCounter()
            //get next soal
            self.arrOption = ["\(self.listSoal.data[index].option1)","\(self.listSoal.data[index].option2)","\(self.listSoal.data[index].option3)","\(self.listSoal.data[index].option4)"]
            self.arrOption = self.arrOption.shuffled
            self.lblSoal.text = self.listSoal.data[index].question
            self.tblSoal.reloadData()
            if index == self.listSoal.data.count - 1{
                self.setVisibilityNext(hide: true)
            }
        }
    }
    
    @IBAction func soalBack(_ sender: AnyObject) {
        if index > 0{
            self.setVisibilityNext(hide: false)
            self.indexpathRow = -1
            index -= 1
            self.setLblCounter()
            //get back soal
            self.arrOption = ["\(self.listSoal.data[index].option1)","\(self.listSoal.data[index].option2)","\(self.listSoal.data[index].option3)","\(self.listSoal.data[index].option4)"]
            self.arrOption = self.arrOption.shuffled
            self.lblSoal.text = self.listSoal.data[index].question
            self.tblSoal.reloadData()
            if index == 0{
                self.setVisibilityBack(hide: true)
            }
        }
    }
    
    func setVisibilityBack(hide:Bool){
        self.btnCounterBack.isHidden = hide
        self.lblCounterBack.isHidden = hide
    }
    
    func setVisibilityNext(hide:Bool){
        self.btnCounterNext.isHidden = hide
        self.lblCounterNext.isHidden = hide
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
        var height:CGFloat = 66
        if height < Helper().heightForView(self.arrOption[indexPath.row], font: UIFont.systemFont(ofSize: 15, weight: .bold), width: 192) {
            height = Helper().heightForView(self.arrOption[indexPath.row], font: UIFont.systemFont(ofSize: 15, weight: .bold), width: 192)
        }
        return CGFloat(height)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:OpsiSoalCell = tableView.dequeueReusableCell(withIdentifier: "OpsiSoalCellIdentifier", for: indexPath) as! OpsiSoalCell
        cell.selectionStyle = .none
        switch indexPath.row {
        case 0:
            cell.lblTitle.text = "A."
            break
        case 1:
            cell.lblTitle.text = "B."
            break
        case 2:
            cell.lblTitle.text = "C."
            break
        case 3:
            cell.lblTitle.text = "D."
            break
        default:
            break
        }
        
        cell.lblDetail.text = self.arrOption[indexPath.row]
        
        if UjianAnswer.isFinished{
            if UjianAnswer.arrAnswer[self.index]["choosed"] == self.listSoal.data[self.index].answer{
                if UjianAnswer.arrAnswer[self.index]["choosed"] == cell.lblDetail.text {
                    cell.modeTrue()
                }else{
                    if self.listSoal.data[self.index].answer == cell.lblDetail.text{
                        cell.modeTrue()
                    }else{
                        cell.modeNormal()
                    }
                }
            }else{
                if UjianAnswer.arrAnswer[self.index]["choosed"] == cell.lblDetail.text {
                    cell.modeFalse()
                }else{
                    if self.listSoal.data[self.index].answer == cell.lblDetail.text{
                        cell.modeTrue()
                    }else{
                        cell.modeNormal()
                    }
                }
            }
        }else{
            if UjianAnswer.arrAnswer[self.index]["choosed"] == cell.lblDetail.text{
                cell.modeSelect()
            }else{
                cell.modeNormal()
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !UjianAnswer.isFinished{
            self.chooseAnswer(answer: self.arrOption[indexPath.row])
            self.tblSoal.reloadData()
        }
    }
    
    func chooseAnswer(answer:String){
        if self.listSoal.data[self.index].answer == answer{
            let tempAnswer = [
                "choosed" : "\(answer)",
                "status" : "true"
            ]
            UjianAnswer.arrAnswer[self.index] = tempAnswer
        }else{
            let tempAnswer = [
                "choosed" : "\(answer)",
                "status" : "false"
            ]
            UjianAnswer.arrAnswer[self.index] = tempAnswer
        }
    }
}

extension UjianDetailSoalVC: MZTimerLabelDelegate {
    func timerLabel(_ timerLabel: MZTimerLabel!, finshedCountDownTimerWithTime countTime: TimeInterval) {
        print("timer finished")
        let alert = UIAlertController(title: Wording.FINISH_EXAM_TITLE, message: Wording.FINISH_EXAM_TIMESUP_MESSAGE, preferredStyle: UIAlertControllerStyle.alert)
        
        let alertOKAction=UIAlertAction(title:"OK", style: UIAlertActionStyle.default,handler: { action in
            //finish exam
            UjianAnswer.isFinished = true
            self.navigationController?.popViewController(animated: true)
        })
        alert.addAction(alertOKAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func timerLabel(_ timerLabel: MZTimerLabel!, countingTo time: TimeInterval, timertype timerType: MZTimerLabelType) {
        
    }
    
}
