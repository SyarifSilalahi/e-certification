//
//  MenuLatihanVC.swift
//  e-certification
//
//  Created by Syarif on 1/13/18.
//  Copyright © 2018 infovesta. All rights reserved.
//

import UIKit

class MenuLatihanVC: UIViewController {
    
    @IBOutlet weak var collectionMenu: UICollectionView!
    @IBOutlet weak var btnSelesai: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setMenuCollection()
    }
    
    func setMenuCollection(){
        self.collectionMenu.dataSource=self
        self.collectionMenu.delegate=self
        let collectionViewLayout:UICollectionViewFlowLayout = self.collectionMenu.collectionViewLayout as! UICollectionViewFlowLayout
        let size = (self.view.frame.size.width / 4) - 40
        let cellheight = size
        let cellwidth = size
        collectionViewLayout.itemSize = CGSize(width: cellwidth, height: cellheight )
        self.collectionMenu.reloadData()
    }
    
    @IBAction func selesai(_ sender: AnyObject) {
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

extension MenuLatihanVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: MenuCVCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCVCellIdentifier", for: indexPath) as! MenuCVCell
        cell.lblTitle.text = "\(indexPath.row + 1)"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
