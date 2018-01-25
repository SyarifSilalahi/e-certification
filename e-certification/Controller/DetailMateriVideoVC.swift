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

class DetailMateriVideoVC: UIViewController {
    
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
        
        self.setVideoPlayer()
    }
    
    func setVideoPlayer(){
        self.urlVideo = URL(fileURLWithPath: FileHelper().getFilePath(name: "\(fileName)"))
        
        self.player.replaceVideo(urlVideo!)
        self.viewPlayer.addSubview(self.player.displayView)
        
        self.player.play()
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
    
    @IBAction func deleteVideo(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
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
        print("player State ",state)
    }
    func vgPlayer(_ player: VGPlayer, bufferStateDidChange state: VGPlayerBufferstate) {
        print("buffer State", state)
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
