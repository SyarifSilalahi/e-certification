//
//  MembershipVC.swift
//  e-certification
//
//  Created by Syarif on 2/18/18.
//  Copyright © 2018 infovesta. All rights reserved.
//

import UIKit

class MembershipVC: UIViewController {
    
    @IBOutlet weak var imgLisence: UIImageView!
    @IBOutlet weak var viewAccessDenied: UIView!
    @IBOutlet weak var imgBg: UIImageView!
    var membership:Membership = Membership()
    var examStatus:StatusExam! = StatusExam()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        self.getStatus()
    }
    func getStatus(){
        ApiManager().getExamStatus { (response,failure, error) in
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
            self.examStatus.deserialize(response!)
            self.setViewStatusExam(status: self.examStatus)
        }
    }
    
    func setViewStatusExam(status:StatusExam!){
        switch status.status_exam {
        case ExamStatus.Lulus.rawValue:
            self.viewAccessDenied.alpha = 0
            ApiManager().getLisence { (response,failure, error) in
                if error != nil{
                    print("error load Membership \(String(describing: error))")
                    self.viewAccessDenied.frame = self.imgBg.frame
                    self.viewAccessDenied.alpha = 1
                    self.view.addSubview(self.viewAccessDenied)

                    return
                }
                if failure != nil{
                    var fail = Failure()
                    fail.deserialize(failure!)
                    print("failure message \(fail.message)")
                    CustomAlert().Error(message: fail.message)
                    //do action failure here
                    self.viewAccessDenied.frame = self.imgBg.frame
                    self.viewAccessDenied.alpha = 1
                    self.view.addSubview(self.viewAccessDenied)
                    return
                }

                //json data model
                self.membership.deserialize(response!)
                print("lisence \(self.membership.lisence)")
                self.setLisence(data: self.membership)
            }
            break
        default:
            self.viewAccessDenied.alpha = 1
            self.viewAccessDenied.frame = self.imgBg.frame
            self.view.addSubview(self.viewAccessDenied)
            break
        }
    }
    
    func setLisence(data:Membership){
        //set Lisence
        let viewLisence = UINib(nibName: "Lisence", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! Lisence
        viewLisence.lblTitle.text = data.lisence.insurance_title
        viewLisence.lblSubtitle.text = data.lisence.insurance_sub_title
        viewLisence.lblUserName.text = data.lisence.name
        viewLisence.lblNoLisence.text = "No. Lisensi   :   \(data.lisence.no_license)"
        viewLisence.lblDateLisence.text = "Berlaku s/d   :   \(data.lisence.expired_date)"
        viewLisence.viewBaseLisensiData.transform = CGAffineTransform(rotationAngle: CGFloat((90.0 * M_PI) / 180.0));
        viewLisence.viewBaseLisensiData.frame.origin.y = 0
        viewLisence.viewBaseLisensiData.frame.origin.x = 0
        
        let imgUrl = URL(string: "\(data.lisence.host_file)\(data.lisence.image_user)")!
        self.getDataFromUrl(url: imgUrl) { data, response, error in
            guard let data = data, error == nil else { return }
//            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                viewLisence.imgUserAvatar.image = UIImage(data: data)
                let image = UIImage(view: viewLisence)
                self.imgLisence.image = image
            }
        }
        
        
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
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
