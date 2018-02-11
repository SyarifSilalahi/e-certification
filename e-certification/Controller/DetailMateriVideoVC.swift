//
//  DetailMateriVideoVC.swift
//  e-certification
//
//  Created by Syarif on 1/13/18.
//  Copyright © 2018 infovesta. All rights reserved.
//

import UIKit
import VGPlayer
import SnapKit
import Digger

class DetailMateriVideoVC: UIViewController {
    @IBOutlet weak var tblMateri: UITableView!
    @IBOutlet weak var viewFooter: UIView!
    @IBOutlet weak var viewPlayer: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    var player = VGPlayer()
    var urlVideo : URL?
    
    var title_ = ""
    var detail = ""
    var fileName = ""
    var description_ = ""
    var videoTimeFlag = ""
    var currentDuration:Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //statusbar
        let app = UIApplication.shared
        app.statusBarStyle = .lightContent
        // Do any additional setup after loading the view.
        self.lblTitle.text = title_
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.shouldRotate = true // or false to disable rotation
        
        self.lblTitle.text = title_
        self.lblDetail.text = detail
        self.lblDescription.text = description_
        self.resetContentSize()
        self.setVideoPlayer()
    }
    
    func resetContentSize(){
        let contentHeight = Helper().heightForView(self.description_, font: UIFont.systemFont(ofSize: 12, weight: .regular), width: self.lblDescription.frame.size.width) + 30
        self.viewFooter.frame.size.height = contentHeight
        self.tblMateri.tableFooterView = self.viewFooter
    }
    
    func getArrFlag(flags:String) ->[String]{
        return flags.components(separatedBy: ",")
    }
    
    func getNextFlag()->Double{
        player.pause()
        let arrGetFlags = getArrFlag(flags: videoTimeFlag)
        print("arrGetFlags \(arrGetFlags)")
        for i in 0..<arrGetFlags.count{
            if (arrGetFlags[i] as NSString).doubleValue > currentDuration {
                print("current time \(self.currentDuration) arrGetFlags[i] \(arrGetFlags[i])")
                return (arrGetFlags[i] as NSString).doubleValue
            }
        }
        return self.currentDuration
    }
    
    func getPrevFlag()->Double{
        player.pause()
        let arrGetFlags = getArrFlag(flags: videoTimeFlag)
        for i in stride(from: arrGetFlags.count - 1, to: -1, by: -1){
            if (arrGetFlags[i] as NSString).doubleValue < currentDuration - 2 {
                return (arrGetFlags[i] as NSString).doubleValue
            }
        }
        return 0
    }
    
    
    func setVideoPlayer(){
        self.urlVideo = URL(fileURLWithPath: FileHelper().getFilePath(name: "\(fileName)"))
        
        self.player.replaceVideo(urlVideo!)
        self.viewPlayer.addSubview(self.player.displayView)
        
        self.player.pause()
        self.player.displayView.topView.alpha = 0
        self.player.backgroundMode = .proceed
        self.player.delegate = self
        self.player.displayView.delegate = self
        self.player.displayView.snp.makeConstraints { [weak self] (make) in
            guard let strongSelf = self else { return }
            make.top.equalTo(strongSelf.self.viewPlayer.snp.top)
            make.left.equalTo(strongSelf.self.viewPlayer.snp.left)
            make.right.equalTo(strongSelf.self.viewPlayer.snp.right)
            make.height.equalTo(strongSelf.self.viewPlayer.snp.height)
        }
    }
    
    @IBAction func back(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func forward(_ sender: AnyObject) {
        player.pause()
        let when = DispatchTime.now() + 1 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            // Your code with delay
            self.player.seekTime(self.getNextFlag())
        }
        
        
    }
    
    @IBAction func backward(_ sender: AnyObject) {
        player.pause()
        let when = DispatchTime.now() + 1 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            // Your code with delay
            self.player.seekTime(self.getPrevFlag())
        }
        
    }
    
    @IBAction func deleteVideo(_ sender: AnyObject) {
        let deleteAlert = UIAlertController(title: "Confirmation", message: "Are you sure want to delete this content?", preferredStyle: UIAlertControllerStyle.alert)
        
        deleteAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            DiggerCache.removeItem(atPath: FileHelper().getFilePath(name: "\(self.fileName)"))
            self.navigationController?.popViewController(animated: true)
        }))
        
        deleteAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        
        present(deleteAlert, animated: true, completion: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.default, animated: false)
//        UIApplication.shared.setStatusBarHidden(false, with: .none)
        self.player.pause()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.shouldRotate = false
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

extension DetailMateriVideoVC: VGPlayerDelegate {
    func vgPlayer(_ player: VGPlayer, playerFailed error: VGPlayerError) {
        print(error)
    }
    func vgPlayer(_ player: VGPlayer, stateDidChange state: VGPlayerState) {
//        print("player State ",state)
    }
    func vgPlayer(_ player: VGPlayer, bufferStateDidChange state: VGPlayerBufferstate) {
//        print("buffer State", state)
    }
    func vgPlayer(_ player: VGPlayer, playerDurationDidChange currentDuration: TimeInterval, totalDuration: TimeInterval) {
//        print("currentDuration \(currentDuration)")
        self.currentDuration = currentDuration
    }
}

extension DetailMateriVideoVC: VGPlayerViewDelegate {
    
    func vgPlayerView(_ playerView: VGPlayerView, willFullscreen fullscreen: Bool) {
        print("fullscreen \(fullscreen)")
    }
    func vgPlayerView(didTappedClose playerView: VGPlayerView) {
        if playerView.isFullScreen {
            playerView.exitFullscreen()
        } else {
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    func vgPlayerView(didDisplayControl playerView: VGPlayerView) {
        playerView.topView.alpha = 0
//        UIApplication.shared.setStatusBarHidden(!playerView.isDisplayControl, with: .fade)
    }
}
