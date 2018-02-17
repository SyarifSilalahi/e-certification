//
//  MateriCell.swift
//  e-certification
//
//  Created by Syarif on 1/12/18.
//  Copyright © 2018 infovesta. All rights reserved.
//

import UIKit
import Digger
import KRActivityIndicatorView

protocol MateriCellDelegate {
    // Indicates that the edit process has begun for the given cell
    func proccessPDF(name: String, title: String, detail: String, update:String, description: String)
    // Indicates that the edit process has committed for the given cell
    func proccessVideo(name: String, title: String, detail: String, update:String, description: String,timeFlag: String)
    
    func startDownloadVideo(url: String)
    func stopDownloadVideo(url: String)
}

class MateriCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var imgContent: UIImageView!
    @IBOutlet weak var btnPdf: UIButton!
    @IBOutlet weak var btnVideo: UIButton!
    @IBOutlet weak var lblProgressDownloadPDF: UILabel!
    @IBOutlet weak var lblProgressDownloadVideo: UILabel!
    @IBOutlet weak var videoIndicator: KRActivityIndicatorView!
    @IBOutlet weak var pdfIndicator: KRActivityIndicatorView!
    
    var delegate: MateriCellDelegate?
    var description_ = ""
    var urlPdf = ""
    var urlVideo = ""
    var videoTimeFlag = ""
    var update = ""
    
    var isDownloadingVideo = false
    var isDownloadingPDF = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        DiggerCache.cleanDownloadFiles()
    }

    func setTitle(text:String,isNew:Bool){
        let title = NSMutableAttributedString(string: "\(text)")
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(named: "ico-dot-new")
        let imageOffsetY:CGFloat = 2.0;
        imageAttachment.bounds = CGRect(x: 5, y: imageOffsetY, width: imageAttachment.image!.size.width, height: imageAttachment.image!.size.height)
        let imageString = NSAttributedString(attachment: imageAttachment)
        if isNew{
            title.append(imageString)
        }
        lblTitle.attributedText = title
    }
    
    //set active deactive
    func setPDFActive(){
        self.btnPdf.setImage(#imageLiteral(resourceName: "ico-pdf-enable"), for: .normal)
    }
    
    func setPDFDeActive(){
        self.btnPdf.setImage(#imageLiteral(resourceName: "ico-pdf-disable"), for: .normal)
    }
    
    func setVideoActive(){
        self.btnVideo.setImage(#imageLiteral(resourceName: "ico-video-enable"), for: .normal)
    }
    
    func setVideoDeActive(){
        self.btnVideo.setImage(#imageLiteral(resourceName: "ico-video-disable"), for: .normal)
    }
    
    //show hide loading
    func showPDFLoading(){
        self.pdfIndicator.animating = true
        self.pdfIndicator.startAnimating()
        self.pdfIndicator.alpha = 1
        self.lblProgressDownloadPDF.alpha = 1
        self.btnPdf.alpha = 0
    }
    
    func hidePDFLoading(){
        self.pdfIndicator.animating = false
        self.pdfIndicator.stopAnimating()
        self.pdfIndicator.alpha = 0
        self.lblProgressDownloadPDF.alpha = 0
        self.btnPdf.alpha = 1
    }
    
    func showVideoLoading(){
        self.videoIndicator.animating = true
        self.videoIndicator.startAnimating()
        self.videoIndicator.alpha = 1
        self.lblProgressDownloadVideo.alpha = 1
        self.btnVideo.alpha = 0
    }
    
    func hideVideoLoading(){
        self.videoIndicator.animating = false
        self.videoIndicator.stopAnimating()
        self.videoIndicator.alpha = 0
        self.lblProgressDownloadVideo.alpha = 0
        self.btnVideo.alpha = 1
    }
    
    func setProgressPDF(progres:Int){
        self.lblProgressDownloadPDF.text = "\(progres)%"
    }
    
    func setProgressVideo(progres:Int){
        self.lblProgressDownloadVideo.text = "\(progres)%"
    }
    
    
    func setActions(urlPdf:String, urlVideo:String){
        self.urlPdf = urlPdf
        self.urlVideo = urlVideo
        
        if FileHelper().isFileExist(name: FileHelper().getNameFromUrl(url: urlPdf)) {
            self.btnPdf.setImage(#imageLiteral(resourceName: "ico-pdf-enable"), for: .normal)
        }else{
            self.btnPdf.setImage(#imageLiteral(resourceName: "ico-pdf-disable"), for: .normal)
        }
        
        if FileHelper().isFileExist(name: FileHelper().getNameFromUrl(url: urlVideo)) {
            self.btnVideo.setImage(#imageLiteral(resourceName: "ico-video-enable"), for: .normal)
        }else{
            self.btnVideo.setImage(#imageLiteral(resourceName: "ico-video-disable"), for: .normal)
        }
        
        DiggerManager.shared.startDownloadImmediately = false
        self.prepareToDownloadPdf()
        self.prepareToDownloadVideo()
        
        btnPdf.addTarget(self, action: #selector(openPdf(sender:)), for: .touchUpInside)
        let stopPdf = UITapGestureRecognizer(target: self, action: #selector(self.stopDownloadPdf(_:)))
        pdfIndicator.addGestureRecognizer(stopPdf)
        pdfIndicator.isUserInteractionEnabled = true
        
        btnVideo.addTarget(self, action: #selector(openVideo(sender:)), for: .touchUpInside)
        let stopVideo = UITapGestureRecognizer(target: self, action: #selector(self.stopDownloadVideo(_:)))
        videoIndicator.addGestureRecognizer(stopVideo)
        videoIndicator.isUserInteractionEnabled = true
    }
    
    private func prepareToDownloadPdf(){
        DiggerManager.shared.download(with:urlPdf).completion { (result) in
            switch result {
            case .success(let url):
                self.btnPdf.setImage(#imageLiteral(resourceName: "ico-pdf-enable"), for: .normal)
                DiggerManager.shared.stopTask(for: self.urlPdf)
                self.pdfIndicator.animating = false
                self.pdfIndicator.stopAnimating()
                self.pdfIndicator.alpha = 0
                self.lblProgressDownloadPDF.alpha = 0
                self.btnPdf.alpha = 1
                print("url pdf \(url)")
                diggerLog(url)
            case .failure(let error):
                self.pdfIndicator.animating = false
                self.pdfIndicator.stopAnimating()
                self.pdfIndicator.alpha = 0
                self.lblProgressDownloadPDF.alpha = 0
                self.btnPdf.alpha = 1
                _ =  error
                diggerLog(error)
                
            }
            
            }.progress { (progress) in
                //                cell.progressView.progress = Float(progress.fractionCompleted)
                //                print("progress \(Float(progress.fractionCompleted))")
                print("progress \(Int(Float(progress.fractionCompleted) * 100))")
                self.lblProgressDownloadPDF.text = "\(Int(Float(progress.fractionCompleted) * 100))%"
                self.btnPdf.alpha = 0
                self.pdfIndicator.alpha = 1
                self.lblProgressDownloadPDF.alpha = 1
                self.pdfIndicator.animating = true
                self.pdfIndicator.startAnimating()
                
            }.speed { (speed) in
                //                print("\(speed / 1024)" + "KB/S")
                
        }
    }
    
    @objc func openPdf(sender:UIButton!) {
//        self.btnPdf.setImage(#imageLiteral(resourceName: "ico-pdf-enable"), for: .normal)
//        getNameFromUrl(url: urlPdf)
        if FileHelper().isFileExist(name: FileHelper().getNameFromUrl(url: urlPdf)) {
            self.delegate?.proccessPDF(name: FileHelper().getNameFromUrl(url: urlPdf), title: self.lblTitle.text!, detail: self.lblDetail.text!,update: self.update, description: self.description_)
            return
        }
        self.btnPdf.alpha = 0
        self.pdfIndicator.alpha = 1
        self.lblProgressDownloadPDF.alpha = 1
        self.pdfIndicator.animating = true
        self.pdfIndicator.startAnimating()
        DiggerManager.shared.startTask(for: self.urlPdf)
    }
    
    private func prepareToDownloadVideo(){
        DiggerManager.shared.download(with: urlVideo).completion { (result) in
            switch result {
            case .success(let url):
                self.btnVideo.setImage(#imageLiteral(resourceName: "ico-video-enable"), for: .normal)
                DiggerManager.shared.stopTask(for: self.urlVideo)
                self.videoIndicator.animating = false
                self.videoIndicator.stopAnimating()
                self.videoIndicator.alpha = 0
                self.lblProgressDownloadVideo.alpha = 0
                self.btnVideo.alpha = 1
                print("url video \(url)")
                diggerLog(url)
            case .failure(let error):
                self.videoIndicator.animating = false
                self.videoIndicator.stopAnimating()
                self.videoIndicator.alpha = 0
                self.lblProgressDownloadVideo.alpha = 0
                self.btnVideo.alpha = 1
                _ =  error
                diggerLog(error)
                
            }
            
            }.progress { (progress) in
                //                cell.progressView.progress = Float(progress.fractionCompleted)
                //                print("progress \(Float(progress.fractionCompleted))")
                print("progress \(Int(Float(progress.fractionCompleted) * 100))")
                
                self.lblProgressDownloadVideo.text = "\(Int(Float(progress.fractionCompleted) * 100))%"
                self.btnVideo.alpha = 0
                self.videoIndicator.alpha = 1
                self.lblProgressDownloadVideo.alpha = 1
                self.videoIndicator.animating = true
                self.videoIndicator.startAnimating()
                
            }.speed { (speed) in
                //                print("\(speed / 1024)" + "KB/S")
        }
    }
    
    @objc func openVideo(sender:UIButton!) {
        if FileHelper().isFileExist(name: FileHelper().getNameFromUrl(url: urlVideo)) {
            self.delegate?.proccessVideo(name: FileHelper().getNameFromUrl(url: urlVideo), title: self.lblTitle.text!, detail: self.lblDetail.text!,update: self.update, description: self.description_,timeFlag: self.videoTimeFlag)
            return
        }
        self.btnVideo.alpha = 0
        self.videoIndicator.alpha = 1
        self.lblProgressDownloadVideo.alpha = 1
        self.videoIndicator.animating = true
        self.videoIndicator.startAnimating()
//        DiggerManager.shared.startTask(for: self.urlVideo)
        self.delegate?.startDownloadVideo(url: self.urlVideo)
    }
    
    @objc func stopDownloadPdf(_ sender: UITapGestureRecognizer) {
        DiggerManager.shared.stopTask(for: self.urlPdf)
        
//        let seed = DiggerManager.shared.findDiggerSeed(with: self.urlPdf)!
//        seed.downloadTask.suspend()
        
        pdfIndicator.animating = false
        pdfIndicator.stopAnimating()
        self.pdfIndicator.alpha = 0
        self.lblProgressDownloadPDF.alpha = 0
        self.btnPdf.alpha = 1
        
    }
    
    @objc func stopDownloadVideo(_ sender: UITapGestureRecognizer) {
//        DiggerManager.shared.stopTask(for: self.urlVideo)
        self.delegate?.stopDownloadVideo(url: self.urlVideo)
        
//        let seed = DiggerManager.shared.findDiggerSeed(with: self.urlVideo)!
//        seed.downloadTask.suspend()
        
        videoIndicator.animating = false
        videoIndicator.stopAnimating()
        self.videoIndicator.alpha = 0
        self.lblProgressDownloadVideo.alpha = 0
        self.btnVideo.alpha = 1
    }
}
