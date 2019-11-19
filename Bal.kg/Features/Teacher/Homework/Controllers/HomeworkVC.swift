//
//  HomeworkVC.swift
//  Bal.kg
//
//  Created by Mairambek on 9/21/19.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit
import RxSwift
import PKHUD

class HomeworkVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var homeworkTextView: UITextView!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var todayButton: UIButton!
    
    var datePicker = UIDatePicker()
    let disposeBag = DisposeBag()
    let homeworkVM = HomeworkViewModel()
    var classId: String?
    var subjectId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createDatePicker()
        navigationItem.title = "Домашнее задание"
        self.homeworkTextView.delegate = self
        self.homeworkTextView.text = "Домашнее задание..."
        self.homeworkTextView.textColor = UIColor.lightGray

        setupTodayButton()
    }
    
    
    
    @IBAction func sendButton(_ sender: UIButton) {
        
        HUD.show(.progress)
        guard let classId = classId else {return}
        guard let subjectId = subjectId else {return}
        guard let date = self.dateField.text else {return}
        guard let text = self.homeworkTextView.text else {return}
        

        if date == "ДАТА:" {
            HUD.hide()
            Alert.displayAlert(title: "", message: "Выберите дату", vc: self)
            return
        } else if text == "Домашнее задание..." {
            HUD.hide()
            Alert.displayAlert(title: "", message: "Введите комментарий", vc: self)
            return
        }
        
        self.homeworkVM.postHomework(classId: classId, subjectId: subjectId, date: date, text: text) { (error) in
            if let error = error {
                HUD.hide()
                Alert.displayAlert(title: "", message: error.localizedDescription, vc: self)
            }
        }
        
        self.homeworkVM.resultBehaviorRelay.skip(1).subscribe(onNext: { (result) in
            
            if result.status == "ok" {
                HUD.hide()
                self.alertCancel(title: "", message: result.message)
            } else {
                HUD.hide()
                Alert.displayAlert(title: "", message: result.message, vc: self)
            }
            
        }).disposed(by: disposeBag)
        
        self.homeworkVM.errorBehaviorRelay.skip(1).subscribe(onNext: { (error) in
            HUD.hide()
            UserDefaults.standard.removeObject(forKey: "token")
            UserDefaults.standard.removeObject(forKey: "userType")
            Alert.displayAlert(title: "", message: error.localizedDescription, vc: self)
            LoginLogoutManager.instance.updateRootVC()
            
        }).disposed(by: disposeBag)
        
    }
    
    func setupTodayButton(){
        
        self.todayButton.addTarget(self, action: #selector(pressedTodayButton), for: .touchUpInside)
    }
    
    @objc func pressedTodayButton(){
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.YYYY"
        let result = formatter.string(from: date)
        self.dateField.text = result
    }
    
    func createDatePicker(){
        let datePickerToolBar = UIToolbar()
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButtonDate = UIBarButtonItem(title: "Готово", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.donePickerDate))
        datePickerToolBar.barStyle = UIBarStyle.default
        datePickerToolBar.isTranslucent = true
        datePickerToolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        datePickerToolBar.sizeToFit()
        datePickerToolBar.setItems([spaceButton,spaceButton,doneButtonDate], animated: true)
        
        datePickerToolBar.isUserInteractionEnabled = true
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(self.datePickerValueChanged(sender:)),  for: .valueChanged)

        
        //Outlets setting
        self.dateField.inputAccessoryView = datePickerToolBar
        self.dateField.inputView = datePicker
        self.dateField.tintColor = .clear
        self.dateField.delegate = self
        self.dateField.font = UIFont.boldSystemFont(ofSize: 24)
        self.dateField.sizeToFit()
    }
    
    func alertCancel(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .cancel) { (alert) in
            self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func donePickerDate(){
        self.dateField.resignFirstResponder()
    }
    
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.YYYY"
        self.dateField.text = dateFormatter.string(from: datePicker.date)
    }
    
    
}


extension HomeworkVC: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty
        {
            textView.text = "Домашнее задание..."
            textView.textColor = UIColor.lightGray
        }
        textView.resignFirstResponder()
    }


}
