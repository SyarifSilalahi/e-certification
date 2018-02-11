//
//  DetailMateriPDFVC.swift
//  e-certification
//
//  Created by Syarif on 1/23/18.
//  Copyright © 2018 infovesta. All rights reserved.
//

import UIKit
import PDFReader
import Digger

class DetailMateriPDFVC: UIViewController {
    
    @IBOutlet weak var tblMateri: UITableView!
    @IBOutlet weak var viewFooter: UIView!
    @IBOutlet weak var viewPdf: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var collectionPdf: UICollectionView!
    
    var urlPdf : URL?
    
    var title_ = ""
    var fileName = ""
    var detail = ""
    var description_ = ""
    
    private var readerController : PDFViewController!
    private var document : PDFDocument!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //statusbar
        let app = UIApplication.shared
        app.statusBarStyle = .lightContent
        // Do any additional setup after loading the view.
        self.lblTitle.text = title_
        self.lblDetail.text = detail
        self.lblDescription.text = description_
        
        self.urlPdf = URL(fileURLWithPath: FileHelper().getFilePath(name: "\(fileName)"))
        document = PDFDocument(url: urlPdf!)!
        readerController = PDFViewController.createNew(with: document)
        collectionPdf.register(PDFPageCollectionViewCell.self, forCellWithReuseIdentifier: "page")
        self.resetContentSize()
    }
    
    func resetContentSize(){
        let contentHeight = Helper().heightForView(self.description_, font: UIFont.systemFont(ofSize: 12, weight: .regular), width: self.lblDescription.frame.size.width) + 30
        self.viewFooter.frame.size.height = contentHeight
        self.tblMateri.tableFooterView = self.viewFooter
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func back(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func fullscreen(_ sender: AnyObject) {
        navigationController?.pushViewController(readerController, animated: true)
    }
    
    @IBAction func deletePdf(_ sender: AnyObject) {
        let deleteAlert = UIAlertController(title: "Confirmation", message: "Are you sure want to delete this content?", preferredStyle: UIAlertControllerStyle.alert)
        
        deleteAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            DiggerCache.removeItem(atPath: FileHelper().getFilePath(name: "\(self.fileName)"))
            self.navigationController?.popViewController(animated: true)
        }))
        
        deleteAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        
        present(deleteAlert, animated: true, completion: nil)
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

extension DetailMateriPDFVC: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return document.pageCount
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "page", for: indexPath) as! PDFPageCollectionViewCell
        cell.setup(indexPath.row, collectionViewBounds: collectionView.bounds, document: document)
        return cell
    }
}

extension DetailMateriPDFVC: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 1, height: collectionView.frame.height)
    }
}
