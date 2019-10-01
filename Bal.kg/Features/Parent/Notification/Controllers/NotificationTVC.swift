//
//  NotificationTVC.swift
//  Bal.kg
//
//  Created by Mairambek on 9/27/19.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit
import PKHUD
import RxSwift


class NotificationTVC: UITableViewController {
    
    let notificatonsVM = NotificationViewModel()
    let disposeBag = DisposeBag()
    var notifications = [NotificationModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getNotifications()
        self.tableView.tableFooterView = UIView()
        self.tableView.allowsSelection = false
    }
    
    func getNotifications(){
        
        HUD.show(.progress)
        
        self.notificatonsVM.getNotifications { (error) in
            if let error = error {
                HUD.hide()
                Alert.displayAlert(title: "", message: error.localizedDescription, vc: self)
            }
        }
        
        self.notificatonsVM.notificationsBehaviorRelay.skip(1).subscribe(onNext: { (notifications) in
            
            HUD.hide()
            self.notifications = notifications
            self.tableView.reloadData()
            
        }).disposed(by: disposeBag)
        
        self.notificatonsVM.errorBehaviorRelay.skip(1).subscribe(onNext: { (error) in
            
            HUD.hide()
            Alert.displayAlert(title: "", message: error.localizedDescription, vc: self)
            
        }).disposed(by: disposeBag)
        
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.notifications.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTVCell", for: indexPath) as! NotificationTVCell
        
        let notification = self.notifications[indexPath.row]
        
        cell.commentLabel.text = notification.about
        cell.dateLabel.text = notification.date
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let comment = self.notifications[indexPath.row].about
        
        let stringSizeAsText: CGSize = getStringSizeForFont(font: UIFont(name: "Avenir", size: 18.0)!, myText: comment)
        let labelWidth: CGFloat = UIScreen.main.bounds.width - 32
        let originalLabelHeight: CGFloat = 30.0
        let labelLines: CGFloat = CGFloat(ceil(Float(stringSizeAsText.width/labelWidth)))
        let height =  85.0 - originalLabelHeight + CGFloat(labelLines*30)
        return height
        
    }
    
    // Метод для рассчета размера Cell
    func getStringSizeForFont(font: UIFont, myText: String) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = (myText as NSString).size(withAttributes: fontAttributes)
        
        return size
    }
    
}
