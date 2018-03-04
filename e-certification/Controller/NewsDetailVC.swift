//
//  NewsDetailVC.swift
//  e-certification
//
//  Created by Syarif on 1/11/18.
//  Copyright © 2018 infovesta. All rights reserved.
//

import UIKit

class NewsDetailVC: UIViewController {
    
    @IBOutlet weak var tblNews : UITableView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var imgHeader: UIImageView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var viewFooter: UIView!
    @IBOutlet weak var webContent: UIWebView!
    
    var detailNews:ListDetailNews = ListDetailNews()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //statusbar
        let app = UIApplication.shared
        app.statusBarStyle = .lightContent
        
        self.lblTitle.text = self.detailNews.title
        let imgUrl = URL(string: "\(self.detailNews.host_file)\(self.detailNews.image)")!
        self.lblDetail.text = self.detailNews.created_at.toNormalFormat()
        self.imgHeader.af_setImage(withURL: imgUrl)
        
        var contentBody = self.detailNews.description
        contentBody = (contentBody as NSString).replacingOccurrences(of: "img style", with: "img _")
        let iFrameWidth = self.webContent.frame.size.width - 5
        let iFrameHeight = iFrameWidth / 1.5
        let htmlString = "<html><head><style>img{max-width:100% ;height:auto !important;width:auto !important;} iframe{ width: \(iFrameWidth)px; height: \(iFrameHeight)px; resize: both; overflow: auto;} </style></head><bodystyle=\"background-color: transparent;\"><font face=\"MyriadPro-Regular\" color=\"#536066\"> \(contentBody) </font></body></html>"
        self.webContent.delegate = self
        webContent.isOpaque = false
        webContent.backgroundColor = UIColor.clear
        webContent.loadHTMLString(htmlString, baseURL: nil)
        // Do any additional setup after loading the view.
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

extension NewsDetailVC: UIWebViewDelegate {
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        webViewResizeToContent(webView: webView)
    }
    
    func webViewResizeToContent(webView: UIWebView) {
        let height:CGFloat = webView.scrollView.contentSize.height
        self.viewFooter.frame.size.height = height + 50
        self.tblNews.tableFooterView = self.viewFooter
    }
}
