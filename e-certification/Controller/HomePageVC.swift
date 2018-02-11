//
//  HomePageVC.swift
//  e-certification
//
//  Created by Syarif on 1/9/18.
//  Copyright © 2018 infovesta. All rights reserved.
//

import UIKit
import HTPullToRefresh

class HomePageVC: UIViewController {
    
    @IBOutlet weak var collectionNews: UICollectionView!
    
    var listNews = ListNews()
    var arrData:[ListDetailNews] = []
    var indexChoosed = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //statusbar
        let app = UIApplication.shared
        app.statusBarStyle = .lightContent
        
        self.getNews()
    }
    
    func getNews(){
        ApiManager().getNews { (response,failure, error) in
            if error != nil{
                print("error load News \(String(describing: error))")
                return
            }
            if failure != nil{
                var fail = Failure()
                fail.deserialize(failure!)
                print("failure message \(fail.message)")
                CustomAlert().Error(message: fail.message)
                //do action failure here
                return
            }
            
            
            //json data model
            self.listNews.deserialize(response!)
            self.arrData = self.listNews.data.listDetailNews
            self.collectionNews.addPullToRefresh(actionHandler: {
                self.loadMore()
                self.collectionNews.pullToRefreshView(at: .bottom).stopAnimating()
            }, position: .bottom)
            //set collectionview
            self.setNewsCollection()
        }
    }
    
    func loadMore(){
        if listNews.data.current_page < listNews.data.last_page && listNews.data.next_page_url != "" {
            ApiManager().getNews(page: self.listNews.data.current_page + 1 , completionHandler: { (response,failure, error) in
                if error != nil{
                    print("error load News \(String(describing: error))")
                    return
                }
                if failure != nil{
                    var fail = Failure()
                    fail.deserialize(failure!)
                    print("failure message \(fail.message)")
                    CustomAlert().Error(message: fail.message)
                    //do action failure here
                    return
                }
                //json data model
                self.listNews.deserialize(response!)
                self.arrData = self.listNews.data.listDetailNews
                self.collectionNews.reloadData()
            })
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "showDetailNews") {
            let vc = segue.destination as! NewsDetailVC
            vc.detailNews = self.arrData[indexChoosed]
        }
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
        return self.arrData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: NewsCVCell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsCVCellIdentifier", for: indexPath) as! NewsCVCell
        let imgUrl = URL(string: "\(self.arrData[indexPath.row].host_file)\(self.arrData[indexPath.row].image)")!
        cell.imgIcoNews.af_setImage(withURL: imgUrl)
        cell.lblTitle.text = "\(self.arrData[indexPath.row].title)"
        cell.lblDetail.text = "\(self.arrData[indexPath.row].created_at)"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.indexChoosed = indexPath.row
        self.performSegue(withIdentifier: "showDetailNews", sender: self)
    }
}
