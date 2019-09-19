//
//  GuardVCExtension.swift
//  Bal.kg
//
//  Created by Mairambek on 9/19/19.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit


extension GuardVC: SendDataDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func qrCodeScanned(info: [String]) {
        self.idField.text = info[0]
        self.guest.text = info[1]
        self.addImage.isHidden = true
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else { return }
        
        self.addImage.image = image
        self.selectedImage = image
        setupReviewImageViewStyle()
    }
    
    //Настройка стиля картинки
    func setupReviewImageViewStyle(){
        self.addImage.layer.borderWidth = 1
        self.addImage.layer.borderColor = UIColor(red: 0.21, green: 0.48, blue: 0.96, alpha: 1).cgColor
        self.addImage.translatesAutoresizingMaskIntoConstraints = false
        self.addImage.contentMode = .scaleToFill
        self.addImage.layer.cornerRadius = 6
    }
    
}

//MARK:  UIPickerViewDelegate
extension GuardVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
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

    @objc func doneClick() {
        guest.resignFirstResponder()
    }
    @objc func cancelClick() {
        guest.resignFirstResponder()
    }
    
}

//MARK:- TextFiled Delegate
extension GuardVC: UITextFieldDelegate  {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.guest.text = "Ученик"
        self.addImage.isHidden = true
        self.pickUp(guest)
    }
    
}


