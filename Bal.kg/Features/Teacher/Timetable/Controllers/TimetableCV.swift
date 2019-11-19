//
//  TimetableCV.swift
//  Bal.kg
//
//  Created by Mairambek on 9/20/19.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit
import RxSwift
import PKHUD

class TimetableCV: UICollectionViewController, UICollectionViewDelegateFlowLayout { 
    
    let timetableVM = TimetableViewModel()
    let disposeBag = DisposeBag()
    var subjectsList = [TimetableModel]()
    var classId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Расписание"
        getTimetable()
        
    }
    
    
    func getTimetable(){
        HUD.show(.progress)
        
        self.timetableVM.getTimetable(class_id: self.classId) { (error) in
            if error != nil {
                HUD.hide()
                Alert.displayAlert(title: "", message: error?.localizedDescription ?? "Connection error", vc: self)
            }
        }
        
        self.timetableVM.timetableBehaviorRelay.skip(1).subscribe(onNext: { (subjectsList) in
            self.subjectsList = subjectsList
            HUD.hide()
            self.collectionView.reloadData()
            
        }).disposed(by: disposeBag)
        
        self.timetableVM.errorBehaviorRelay.skip(1).subscribe(onNext: { (error) in
            HUD.hide()
            UserDefaults.standard.removeObject(forKey: "token")
            UserDefaults.standard.removeObject(forKey: "userType")
            Alert.displayAlert(title: "", message: error.localizedDescription, vc: self)
            LoginLogoutManager.instance.updateRootVC()
    
        }).disposed(by: disposeBag)
        
        
        
    }
    
    
    // MARK: UICollectionViewDataSource
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subjectsList.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let subject = subjectsList[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimetableCVCell", for: indexPath) as! TimetableCVCell
        cell.dayName.text = subject.dayName
        cell.tableView.delegate = self
        cell.tableView.dataSource = self
        cell.tableView.tag = indexPath.row
        cell.tableView.tableFooterView = UIView()
        cell.tableView.isScrollEnabled = false
        
        if subject.subjects.count == 0 {
            cell.tableView.allowsSelection = false
        }
        return cell
    }
    
    //MARK: collectionViewLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath:IndexPath) -> CGSize {
        let subjects = self.subjectsList[indexPath.row].subjects.count
        if indexPath.row % 2 == 0 {
            if subjectsList[indexPath.row].subjects.count == 0 &&  subjectsList[indexPath.row + 1].subjects.count == 0 {
                return CGSize(width: view.bounds.width/2 - 20, height: CGFloat(68+28))
            }
            
            if subjectsList[indexPath.row].subjects.count >= subjectsList[indexPath.row + 1].subjects.count {
                return CGSize(width: view.bounds.width/2 - 20, height: CGFloat(subjects*68+28))
            } else {
                let count = subjectsList[indexPath.row + 1].subjects.count
                return CGSize(width: view.bounds.width/2 - 20, height: CGFloat(count*68+28))
            }
            
        } else {
            if subjectsList[indexPath.row].subjects.count == 0 &&  subjectsList[indexPath.row - 1].subjects.count == 0 {
                return CGSize(width: view.bounds.width/2 - 20, height: CGFloat(68+28))
            }
            
            if subjectsList[indexPath.row].subjects.count >= subjectsList[indexPath.row - 1].subjects.count {
                return CGSize(width: view.bounds.width/2 - 20, height: CGFloat(subjects*68+28))
            } else {
                let count = subjectsList[indexPath.row - 1].subjects.count
                return CGSize(width: view.bounds.width/2 - 20, height: CGFloat(count*68+28))
            }
            
        }
        
    }
    
    
    
}


extension TimetableCV: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let index = tableView.tag
        let subjects = subjectsList[index]
        if subjects.subjects.count == 0 {
            return 1
        }
        return subjects.subjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let list = subjectsList[tableView.tag]
        if list.subjects.count == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "noLessons")
            
            cell?.textLabel?.text = "Нет уроков"
            cell?.textLabel?.textAlignment = .center
            cell?.textLabel?.textColor = UIColor.gray
            
            return cell!
            
        }
        
        
        let subjects = list.subjects[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimeTableTVCell", for: indexPath) as! TimeTableTVCell
        
        cell.timeLesson.text = subjects.timeStart
        cell.nameLesson.text = subjects.nameSubject
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let subjectId = subjectsList[tableView.tag].subjects[indexPath.row].id
        
        let popUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PopUpVC") as! PopUpVC
        
   
        
        popUpVC.classId = classId
        popUpVC.subjectId = subjectId
        
        self.addChild(popUpVC) // 2
        popUpVC.view.frame = self.view.frame  // 3
        self.view.addSubview(popUpVC.view) // 4
        popUpVC.didMove(toParent: self) // 5
        
    }
    
    
    
    
}
