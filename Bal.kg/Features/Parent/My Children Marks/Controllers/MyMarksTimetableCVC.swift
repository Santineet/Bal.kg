//
//  MyMarksTimetableCVC.swift
//  Bal.kg
//
//  Created by Mairambek on 11/20/19.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit
import PKHUD
import RxSwift

class MyMarksTimetableCVC: UICollectionViewController {

    let myMarksVM = MyMarksViewModel()
    
    var subjectList = [MyMarksTimetableModel]()
    var id: String = ""
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getMarksTimetable(id: id)

    }

  //MARK: - Marks timetable reguest
    func getMarksTimetable(id: String){
        HUD.show(.progress)
        myMarksVM.getMarksTimetable(id: id) { (error) in
            if let error = error  {
                HUD.hide()
                Alert.displayAlert(title: "", message: error.localizedDescription, vc: self)
            }
        }
        
        myMarksVM.myMarksTimetableBehaviorRelay.skip(1).subscribe(onNext: { (subjectList) in
            
            
            self.subjectList = subjectList
            self.collectionView.reloadData()
            HUD.hide()
            }).disposed(by: disposeBag)
        
        myMarksVM.errorTimetableBehaviorRelay.skip(1).subscribe(onNext: { (error) in
            
            HUD.hide()
            UserDefaults.standard.removeObject(forKey: "token")
            UserDefaults.standard.removeObject(forKey: "userType")
            Alert.displayAlert(title: "", message: error.localizedDescription, vc: self)
            LoginLogoutManager.instance.updateRootVC()
            
            }).disposed(by: disposeBag)
        
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return subjectList.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let subject = subjectList[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyMarksTimetableCVCell", for: indexPath) as! MyMarksTimetableCVCell
        cell.dayLabel.text = subject.dayName
        cell.tableView.delegate = self
        cell.tableView.dataSource = self
        cell.tableView.tag = indexPath.row
        cell.tableView.tableFooterView = UIView()
        cell.tableView.isScrollEnabled = false
      
        return cell
    }



}

extension MyMarksTimetableCVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath:IndexPath) -> CGSize {
        print("layput is work")
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

extension MyMarksTimetableCVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let index = tableView.tag
        let subjects = subjectList[index]
        if subjects.subjects.count == 0 {
            return 1
        }
        return subjects.subjects.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let list = subjectList[tableView.tag]
        if list.subjects.count == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "noMarksCell")
            
            cell?.textLabel?.text = "Нет уроков"
            cell?.textLabel?.textAlignment = .center
            cell?.textLabel?.textColor = UIColor.gray
            cell?.isUserInteractionEnabled = false

            return cell ?? UITableViewCell()
            
        }
        
        let subjects = list.subjects[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyMarksTimetableTVCell", for: indexPath) as! MyMarksTimetableTVCell
        
        cell.timeLabel.text = subjects.timeStart
        cell.subjectLabel.text = subjects.nameSubject
        cell.markLabel.text = subjects.mark
        
        return cell
 
    }
    
    
    //MARK: tableview heightForRowAt
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }

    //MARK: tableview didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         
         tableView.deselectRow(at: indexPath, animated: true)
         
         let subject = subjectList[tableView.tag].subjects[indexPath.row]
     
         let myMark = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyMarksTVC") as! MyMarksTVC
         
         myMark.title = subject.nameSubject
         myMark.id = self.id
         myMark.subject_id = subject.id
         
         navigationController?.pushViewController(myMark, animated: true)
         
     }
    
    
}
