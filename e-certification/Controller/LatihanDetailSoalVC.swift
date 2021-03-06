//
//  LatihanDetailSoal.swift
//  e-certification
//
//  Created by Syarif on 1/23/18.
//  Copyright © 2018 infovesta. All rights reserved.
//

import UIKit

class LatihanDetailSoalVC: UIViewController {
    
    @IBOutlet weak var tblSoal: UITableView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var lblSoal: UILabel!
    @IBOutlet weak var lblCounterNext: UILabel!
    @IBOutlet weak var lblCounterBack: UILabel!
    @IBOutlet weak var lblCounter: UILabel!
    @IBOutlet weak var btnCounterNext: UIButton!
    @IBOutlet weak var btnCounterBack: UIButton!
    
    var listSoal:[QuestionLatihan] = []
    
    var index = 0
    var indexpathRow = -1
    var arrOption:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.lblSoal.text = self.listSoal[index].question
        
        self.arrOption = ["\(self.listSoal[index].option1)","\(self.listSoal[index].option2)","\(self.listSoal[index].option3)","\(self.listSoal[index].option4)"]
        self.arrOption = self.arrOption.shuffled
        
        self.setLblCounter()
        self.tblSoal.dataSource = self
        self.tblSoal.delegate = self
        self.tblSoal.reloadData()
        if index == 0 {
            setVisibilityBack(hide: true)
        }
        if index == self.listSoal.count - 1{
            setVisibilityNext(hide: true)
        }
//        print("arrOption \(arrOption)")
//        print("arrOption shuffled \(arrOption.shuffled)")
    }
    
    func resetHeaderSize(){
        let contentHeight = Helper().heightForView(self.listSoal[index].question, font: FONT().setFontM_ROMAN(15), width: self.lblSoal.frame.size.width) + 50
        self.viewHeader.frame.size.height = contentHeight
        self.tblSoal.tableHeaderView = self.viewHeader
    }
    
    func setLblCounter(){
        self.lblCounter.text = "\(index + 1) / \(self.listSoal.count)"
        if self.index > 0{
            self.lblCounterBack.text = "\(self.index )"
            self.lblCounterNext.text = "\(self.index + 1 + 1)"
            if index  == self.listSoal.count - 1 {
                self.lblCounterNext.text = "\(self.index + 1)"
            }
        }else{
            self.lblCounterBack.text = "\(self.index + 1)"
            self.lblCounterNext.text = "\(self.index + 1 + 1)"
        }
        self.resetHeaderSize()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func soalNext(_ sender: AnyObject) {
        if index < self.listSoal.count - 1 {
            self.setVisibilityBack(hide: false)
            self.indexpathRow = -1
            index += 1
            self.setLblCounter()
            //get next soal
            self.lblSoal.text = self.listSoal[index].question
            self.arrOption = ["\(self.listSoal[index].option1)","\(self.listSoal[index].option2)","\(self.listSoal[index].option3)","\(self.listSoal[index].option4)"]
            self.arrOption = self.arrOption.shuffled
            self.tblSoal.reloadData()
            if index == self.listSoal.count - 1{
                self.setVisibilityNext(hide: true)
            }
        }
        
    }
    
    @IBAction func soalBack(_ sender: AnyObject) {
        print("index \(index)")
        if index > 0{
            self.setVisibilityNext(hide: false)
            self.indexpathRow = -1
            index -= 1
            self.setLblCounter()
            //get back soal
            self.lblSoal.text = self.listSoal[index].question
            self.arrOption = ["\(self.listSoal[index].option1)","\(self.listSoal[index].option2)","\(self.listSoal[index].option3)","\(self.listSoal[index].option4)"]
            self.arrOption = self.arrOption.shuffled
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

extension LatihanDetailSoalVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height:CGFloat = 66
        if height < Helper().heightForView(self.arrOption[indexPath.row], font: FONT().setFontM_ROMAN(15), width: 192) {
            height = Helper().heightForView(self.arrOption[indexPath.row], font: FONT().setFontM_ROMAN(15), width: 192)
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
        
        if LatihanAnswer.isFinished{
            if LatihanAnswer.arrAnswer[self.index].selected == ""{
                if self.listSoal[self.index].answer == cell.lblDetail.text{
                    cell.modeTrueAnswerNotSelected()
                }else{
                    cell.modeNormal()
                }
                
            }else if LatihanAnswer.arrAnswer[self.index].selected == self.listSoal[self.index].answer{
                if LatihanAnswer.arrAnswer[self.index].selected == cell.lblDetail.text {
                    cell.modeTrue()
                }else{
                    if self.listSoal[self.index].answer == cell.lblDetail.text{
                        cell.modeTrue()
                    }else{
                        cell.modeNormal()
                    }
                }
            }else{
                if LatihanAnswer.arrAnswer[self.index].selected == cell.lblDetail.text {
                    cell.modeFalse()
                }else{
                    if self.listSoal[self.index].answer == cell.lblDetail.text{
                        cell.modeTrue()
                    }else{
                        cell.modeNormal()
                    }
                }
            }
        }else{
            if LatihanAnswer.arrAnswer[self.index].selected == cell.lblDetail.text{
//                cell.modeSelect()
                cell.modeTrue()
            }else{
                cell.modeNormal()
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !LatihanAnswer.isFinished{
            self.chooseAnswer(answer: self.arrOption[indexPath.row])
            self.tblSoal.reloadData()
        }
    }
    
    func chooseAnswer(answer:String){
//        let tempAnswer = [
//            "id" : "\(self.listSoal.data[self.index].id)",
//            "sub_module_id" : "\(self.listSoal.data[self.index].sub_module_id)",
//            "question" : "\(self.listSoal.data[self.index].question)",
//            "option1" : "\(self.listSoal.data[self.index].option1)",
//            "option2" : "\(self.listSoal.data[self.index].option2)",
//            "option3" : "\(self.listSoal.data[self.index].option3)",
//            "option4" : "\(self.listSoal.data[self.index].option4)",
//            "answer" : "\(self.listSoal.data[self.index].answer)",
//            "selected" : "\(answer)"
//        ]
        var tempAnswer = self.listSoal[self.index]
        tempAnswer.selected = answer
        LatihanAnswer.arrAnswer[self.index] = tempAnswer
    }
}
