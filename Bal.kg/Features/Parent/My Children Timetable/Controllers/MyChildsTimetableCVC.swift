//
//  MyChildsTimetableCVC.swift
//  Bal.kg
//
//  Created by Mairambek on 9/30/19.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit
import RxSwift
import PKHUD


class MyChildsTimetableCVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    
    let childTimetableVM = MyChildTimetableViewModel()
    let disposeBag = DisposeBag()
    var subjectList = [TimetableModel]()
    var id: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getChildTimetable(id: id)
        
        collectionView.allowsSelection = false
    }
    

    func getChildTimetable(id: String){
        HUD.show(.progress)
        
        self.childTimetableVM.getChildTimetable(id: id) { (error) in
            if let error = error {
                HUD.hide()
                Alert.displayAlert(title: "", message: error.localizedDescription, vc: self)
                
            }
        }
        
        self.childTimetableVM.childTimetableBehaviorRelay.skip(1).subscribe(onNext: { (subjectList) in
            
            HUD.hide()
            self.subjectList = subjectList
            self.collectionView.reloadData()

        }).disposed(by: disposeBag)
        
        self.childTimetableVM.errorBehaviorRelay.skip(1).subscribe(onNext: { (error) in
         
            HUD.hide()
            UserDefaults.standard.removeObject(forKey: "token")
            UserDefaults.standard.removeObject(forKey: "userType")
            Alert.displayAlert(title: "", message: error.localizedDescription, vc: self)
            LoginLogoutManager.instance.updateRootVC()
            
        }).disposed(by: disposeBag)
        
    }

    //MARK: numberOfItemsInSection

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return subjectList.count
    }
    
    //MARK: cellForItemAt

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let subject = subjectList[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyChildTimetableCVCell", for: indexPath) as! MyChildTimetableCVCell
        cell.dayLabel.text = subject.dayName
        cell.tableView.delegate = self
        cell.tableView.dataSource = self
        cell.tableView.tag = indexPath.row
        cell.tableView.tableFooterView = UIView()
        cell.tableView.isScrollEnabled = false
        cell.tableView.allowsSelection = false
        return cell
    }

    
    //MARK: collectionViewLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath:IndexPath) -> CGSize {
        let subjects = self.subjectList[indexPath.row].subjects.count
        if indexPath.row % 2 == 0 {
            if subjectList[indexPath.row].subjects.count == 0 &&  subjectList[indexPath.row + 1].subjects.count == 0 {
                return CGSize(width: view.bounds.width/2 - 20, height: CGFloat(68+28))
            }
            
            if subjectList[indexPath.row].subjects.count >= subjectList[indexPath.row + 1].subjects.count {
                return CGSize(width: view.bounds.width/2 - 20, height: CGFloat(subjects*68+28))
            } else {
                let count = subjectList[indexPath.row + 1].subjects.count
                return CGSize(width: view.bounds.width/2 - 20, height: CGFloat(count*68+28))
            }
            
        } else {
            if subjectList[indexPath.row].subjects.count == 0 &&  subjectList[indexPath.row - 1].subjects.count == 0 {
                return CGSize(width: view.bounds.width/2 - 20, height: CGFloat(68+28))
            }
            
            if subjectList[indexPath.row].subjects.count >= subjectList[indexPath.row - 1].subjects.count {
                return CGSize(width: view.bounds.width/2 - 20, height: CGFloat(subjects*68+28))
            } else {
                let count = subjectList[indexPath.row - 1].subjects.count
                return CGSize(width: view.bounds.width/2 - 20, height: CGFloat(count*68+28))
            }
            
        }
        
    }
    
    
  

}

extension MyChildsTimetableCVC: UITableViewDelegate, UITableViewDataSource {
   
    //MARK: tableview numberOfRowsInSection

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let index = tableView.tag
        let subjects = subjectList[index]
        if subjects.subjects.count == 0 {
            return 1
        }
        return subjects.subjects.count
    }
    
    //MARK: tableview cellForRowAt

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let list = subjectList[tableView.tag]
        if list.subjects.count == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "noLesson")
            
            cell?.textLabel?.text = "Нет уроков"
            cell?.textLabel?.textAlignment = .center
            cell?.textLabel?.textColor = UIColor.gray
            cell?.isUserInteractionEnabled = false

            return cell ?? UITableViewCell()
            
        }
        
        
        let subjects = list.subjects[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyChildTimetableTVCell", for: indexPath) as! MyChildTimetableTVCell
        
        cell.timeLabel.text = subjects.timeStart
        cell.lessonName.text = subjects.nameSubject
        
        return cell
    }
    
    //MARK: tableview heightForRowAt

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        tableView.deselectRow(at: indexPath, animated: true)
//
//        let subject = subjectList[tableView.tag].subjects[indexPath.row]
//
//        let myMark = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyMarksTVC") as! MyMarksTVC
//
//        myMark.title = subject.nameSubject
//        myMark.id = self.id
//        myMark.subject_id = subject.id
//
//        navigationController?.pushViewController(myMark, animated: true)
//
//    }
    
}
