//
//  HomePageVC.swift
//  e-certification
//
//  Created by Syarif on 1/9/18.
//  Copyright © 2018 infovesta. All rights reserved.
//

import UIKit

class HomePageVC: UIViewController {
    
    @IBOutlet weak var collectionNews: UICollectionView!
    @IBOutlet weak var tblNotif: UITableView!
    @IBOutlet weak var txtSearch: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTblNotif()
        setNewsCollection()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setTblNotif(){
        self.tblNotif.delegate = self
        self.tblNotif.dataSource = self
        self.tblNotif.reloadData()
    }
    
    func setNewsCollection(){
        self.collectionNews.dataSource=self
        self.collectionNews.delegate=self
        let collectionViewLayout:UICollectionViewFlowLayout = self.collectionNews.collectionViewLayout as! UICollectionViewFlowLayout
        let size = (self.view.frame.size.width / 2) - 55
        let cellheight = size + 10
        let cellwidth = size
        collectionViewLayout.itemSize = CGSize(width: cellwidth, height: cellheight )
        self.collectionNews.reloadData()
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

extension HomePageVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 43
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:NotifCell = tableView.dequeueReusableCell(withIdentifier: "NotifCellIdentifier", for: indexPath) as! NotifCell
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension HomePageVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: NewsCVCell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsCVCellIdentifier", for: indexPath) as! NewsCVCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
