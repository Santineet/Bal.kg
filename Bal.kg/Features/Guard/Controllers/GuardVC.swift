//
//  GuardVC.swift
//  Bal.kg
//
//  Created by Mairambek on 10/09/2019.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit
import RxSwift
import PKHUD

protocol SendDataDelegate {
    func qrCodeScanned(info: [String])
}

class GuardVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
   
    @IBOutlet weak var addImage: UIImageView!
    @IBOutlet weak var input: UILabel!
    @IBOutlet weak var idField: UITextField!
    @IBOutlet weak var `switch`: UISwitch!
    @IBOutlet weak var guest: UITextField!
    @IBOutlet weak var exit: UILabel!
    
    
    var loginVM = GuardViewModel()
    let disposeBag = DisposeBag()
    var picker : UIPickerView!
    var pickerData = ["Ученик", "Учитель", "Гость"]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.input.textColor = UIColor.blue
        self.switch.addTarget(self, action: #selector(paramTarget(paramTarget:)) , for: .valueChanged)
        self.addImage.isHidden = true
        guest.delegate = self
        guest.tintColor = UIColor.clear
        pressAddimage()
    }
    
    func pressAddimage(){
        self.addImage.isUserInteractionEnabled = true
        self.addImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.didTappedProfileImageView)))
    }
    
    @objc func didTappedProfileImageView(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.isEditing = true
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }

    
    // observer for switch
    @objc func paramTarget(paramTarget: UISwitch){
        if paramTarget.isOn {
            self.exit.textColor = UIColor.blue
            self.input.textColor = UIColor.black
        } else {
            self.exit.textColor = UIColor.black
            self.input.textColor = UIColor.blue
        }
        
    }
    
 
    
    @IBAction func scanButton(_ sender: UIButton) {
    
        let scanVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "QRCodeScanVC") as! QRCodeScanVC
        scanVC.guardVC = self
        let navC = UINavigationController(rootViewController: scanVC)
        present(navC, animated: true, completion: nil)
        
    }
    
    @IBAction func sendButton(_ sender: UIButton) {
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        HUD.show(.progress)
        
        self.loginVM.logout { (error) in
            if error != nil {
                HUD.hide()
                Alert.displayAlert(title: "Ошибка", message: "Для получения данных требуется подключение к интернету", vc: self)
            }
        }
        
        
        self.loginVM.logoutBehaviorRelay.skip(1).subscribe(onNext: { (success) in
            HUD.hide()
            if success.status == "ok" {
             
                UserDefaults.standard.removeObject(forKey: "token")
                UserDefaults.standard.removeObject(forKey: "userType")
                Alert.displayAlert(title: "", message: success.message, vc: self)
                LoginLogoutManager.instance.updateRootVC()
            
            } else if success.status == "error"{
                Alert.displayAlert(title: "Ошибка", message: success.message, vc: self)
            }
        }).disposed(by: disposeBag)
        
        self.loginVM.errorBehaviorRelay.skip(1).subscribe(onNext: { (error) in
            Alert.displayAlert(title: "Error", message: error.localizedDescription, vc: self)
        }).disposed(by: disposeBag)
        
    }
    
    
    func pickUp(_ textField : UITextField){

        // UIPickerView
        self.picker = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.picker.delegate = self
        self.picker.dataSource = self
        self.picker.backgroundColor = UIColor.white
        textField.inputView = self.picker

        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()

        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar

    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == 2 {
            self.addImage.isHidden = false
        } else {
            self.addImage.isHidden = true
        }
        self.guest.text = pickerData[row]
    }
    //MARK:- TextFiled Delegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.guest.text = "Ученик"
        self.pickUp(guest)
    }
    
    @objc func doneClick() {
        guest.resignFirstResponder()
    }
    @objc func cancelClick() {
        guest.resignFirstResponder()
    }
    

}

extension GuardVC: SendDataDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func qrCodeScanned(info: [String]) {
        self.idField.text = info[0]
        self.guest.text = info[1]
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedFromImageFromPicker:UIImage?
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            selectedFromImageFromPicker = editedImage
        }else if let originalImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            selectedFromImageFromPicker = originalImage
        }
        if let selectedImage = selectedFromImageFromPicker{
            
            setupReviewImageViewStyle()
            self.addImage.image = selectedImage
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    //Настройка стиля картинки
    func setupReviewImageViewStyle(){
        self.addImage.layer.borderWidth = 1
        self.addImage.layer.borderColor = UIColor(red: 0.21, green: 0.48, blue: 0.96, alpha: 1).cgColor
        self.addImage.translatesAutoresizingMaskIntoConstraints = false
        self.addImage.contentMode = .scaleToFill
    }

    
}
