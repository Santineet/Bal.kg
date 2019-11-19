//
//  MyHomeworkCVC.swift
//  Bal.kg
//
//  Created by Mairambek on 10/1/19.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit
import PKHUD
import RxSwift


class MyHomeworkCVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    let myHomeworkVM = MyHomeworkViewModel()
    let disposeBag = DisposeBag()
    var homeworkList = [MyHomeworkModel]()
    var id: String = ""
//    var subjectId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.getShedulesHomework(id: id)
        self.navigationItem.title = "Домашнее задание"
        self.collectionView.allowsSelection = false
    }


    func getShedulesHomework(id: String){
        
        HUD.show(.progress)


        self.myHomeworkVM.getShedulesHomework(id: id) { (error) in
            if let error = error {
                HUD.hide()
                Alert.displayAlert(title: "", message: error.localizedDescription, vc: self)
            }
        }
        self.myHomeworkVM.shedulesHomeworkBehaviorRelay.skip(1).subscribe(onNext: { (homework) in
            HUD.hide()
            self.homeworkList = homework
            self.collectionView.reloadData()
            
        }).disposed(by: disposeBag)
        
        self.myHomeworkVM.errorBehaviorRelay.skip(1).subscribe(onNext: { (error) in
            
            HUD.hide()
            UserDefaults.standard.removeObject(forKey: "token")
            UserDefaults.standard.removeObject(forKey: "userType")
            Alert.displayAlert(title: "", message: error.localizedDescription, vc: self)
            LoginLogoutManager.instance.updateRootVC()
            
        }).disposed(by: disposeBag)
    }
    


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return self.homeworkList.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let homework = self.homeworkList[indexPath.row]
       
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyHomeworkCVCell", for: indexPath) as! MyHomeworkCVCell
        
        cell.dayName.text = homework.day_name
        cell.tableView.delegate = self
        cell.tableView.tag = indexPath.row
        cell.tableView.dataSource = self
        cell.tableView.isScrollEnabled = false
        return cell
    }
    
    
    //MARK: collectionViewLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath:IndexPath) -> CGSize {
        
        let subjects = self.homeworkList[indexPath.row].list_subjects
        
        if subjects.count == 0 {
            
             return CGSize(width: view.bounds.width - 20, height: CGFloat(91))
        }
        
        return CGSize(width: view.bounds.width - 20, height: CGFloat(subjects.count*63 + 28))
    }
        

}


extension MyHomeworkCVC: UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let subjects = self.homeworkList[tableView.tag].list_subjects
        
        if subjects.count == 0 {
            return 1
        }
        
        return subjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let subjects = self.homeworkList[tableView.tag].list_subjects

        if subjects.count == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "noHomework")
            
            cell?.textLabel?.text = "Нет домашних заданий"
            cell?.textLabel?.textColor = UIColor.darkGray
            cell?.textLabel?.textAlignment = .center
            cell?.isUserInteractionEnabled = false
            return cell ?? UITableViewCell()
        }
        
        let subjectInfo = subjects[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: "MyHomeworkTVCell", for: indexPath) as! MyHomeworkTVCell
        
        cell.date.text = subjectInfo.time_start
        cell.subject_name.text = subjectInfo.name_subject
        cell.commentHomeworkLabel.text = subjectInfo.homework
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 63
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)

        let homework = self.homeworkList[tableView.tag].list_subjects

        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeworkCommentTVC") as! HomeworkCommentTVC
        
        vc.subjectId = homework.first?.id ?? ""
        vc.id = self.id
        
        vc.title = homework[indexPath.row].name_subject
        
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
    
    
}
