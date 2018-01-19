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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //statusbar
        let app = UIApplication.shared
        app.statusBarStyle = .lightContent
        setNewsCollection()
    }
    
    @IBAction func setting(_ sender: AnyObject) {
        print("setting")
        //statusbar
        let app = UIApplication.shared
        app.isStatusBarHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
