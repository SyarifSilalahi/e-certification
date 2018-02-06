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
    func proccessPDF(name: String, title: String, detail: String, description: String)
    // Indicates that the edit process has committed for the given cell
    func proccessVideo(name: String, title: String, detail: String, description: String,timeFlag: String)
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
        
        btnPdf.addTarget(self, action: #selector(openPdf(sender:)), for: .touchUpInside)
        let stopPdf = UITapGestureRecognizer(target: self, action: #selector(self.stopDownloadPdf(_:)))
        pdfIndicator.addGestureRecognizer(stopPdf)
        pdfIndicator.isUserInteractionEnabled = true
        
        btnVideo.addTarget(self, action: #selector(openVideo(sender:)), for: .touchUpInside)
        let stopVideo = UITapGestureRecognizer(target: self, action: #selector(self.stopDownloadVideo(_:)))
        videoIndicator.addGestureRecognizer(stopVideo)
        videoIndicator.isUserInteractionEnabled = true
    }
    
    @objc func openPdf(sender:UIButton!) {
//        self.btnPdf.setImage(#imageLiteral(resourceName: "ico-pdf-enable"), for: .normal)
//        getNameFromUrl(url: urlPdf)
        if FileHelper().isFileExist(name: FileHelper().getNameFromUrl(url: urlPdf)) {
            self.delegate?.proccessPDF(name: FileHelper().getNameFromUrl(url: urlPdf), title: self.lblTitle.text!, detail: self.lblDetail.text!, description: self.description_)
            return
        }
        btnPdf.alpha = 0
        DiggerManager.shared.startTask(for: self.urlPdf)
        Digger.download(urlPdf).completion { (result) in
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
    
    @objc func stopDownloadPdf(_ sender: UITapGestureRecognizer) {
        DiggerManager.shared.stopTask(for: self.urlPdf)
        pdfIndicator.animating = false
        pdfIndicator.stopAnimating()
        self.pdfIndicator.alpha = 0
        self.lblProgressDownloadPDF.alpha = 0
        self.btnPdf.alpha = 1
    }
    
    @objc func openVideo(sender:UIButton!) {
        if FileHelper().isFileExist(name: FileHelper().getNameFromUrl(url: urlVideo)) {
            self.delegate?.proccessVideo(name: FileHelper().getNameFromUrl(url: urlVideo), title: self.lblTitle.text!, detail: self.lblDetail.text!, description: self.description_,timeFlag: self.videoTimeFlag)
            return
        }
        btnVideo.alpha = 0
        DiggerManager.shared.startTask(for: self.urlVideo)
        Digger.download(urlVideo).completion { (result) in
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
    
    @objc func stopDownloadVideo(_ sender: UITapGestureRecognizer) {
        DiggerManager.shared.stopTask(for: self.urlVideo)
        videoIndicator.animating = false
        videoIndicator.stopAnimating()
        self.videoIndicator.alpha = 0
        self.lblProgressDownloadVideo.alpha = 0
        self.btnVideo.alpha = 1
    }
}

extension MateriCell{
    func diggerConfig() {
        /// 是否立刻开始任务,默认为true
        DiggerManager.shared.startDownloadImmediately = false
        /// 设置并发数,默认为3
        DiggerManager.shared.maxConcurrentTasksCount = 4
        /// 设置请求超时,默认为150毫秒
        DiggerManager.shared.timeout = 150
        /// 设置是否可用蜂窝数据下载,默认为true
        DiggerManager.shared.allowsCellularAccess = false
        /// 设置日志级别,默认为high,格式如下,设置为none则关闭
        DiggerManager.shared.logLevel = .none
        /*
         ***************DiggerLog****************
         file   : ExampleController.swift
         method : viewDidLoad()
         line   : [31]:
         info   : digger log
         
         */
        // MARK:-  DiggerCache
        
        /// 在沙盒cactes目录,自定义缓存目录
        DiggerCache.cachesDirectory = "Directory"
        /// 删除所有下载的文件
        DiggerCache.cleanDownloadFiles()
        /// 删除所有临时下载文件
        DiggerCache.cleanDownloadTempFiles()
        /// 获取系统可用内存
        _ = DiggerCache.systemFreeSize()
        /// 获取已下载文件大小
        _ = DiggerCache.downloadedFilesSize()
        /// 获取所有下载完成的文件的路径
        _ = DiggerCache.pathsOfDownloadedfiles
    }
}
