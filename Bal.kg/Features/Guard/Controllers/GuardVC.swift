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
import RealmSwift

protocol SendDataDelegate {
    func qrCodeScanned(info: [String])
}


class GuardVC: UIViewController {
    
    @IBOutlet weak var addImage: UIImageView!
    @IBOutlet weak var input: UILabel!
    @IBOutlet weak var idField: UITextField!
    @IBOutlet weak var `switch`: UISwitch!
    @IBOutlet weak var guest: UITextField!
    @IBOutlet weak var exit: UILabel!
    @IBOutlet weak var showDataSwitch: UISwitch!
    @IBOutlet weak var guestInfo: UILabel!
    
    var guardVM = GuardViewModel()
    let disposeBag = DisposeBag()
    var picker : UIPickerView!
    var pickerData = ["Ученик", "Учитель", "Гость"]
    var status = 0
    var imagePicker = UIImagePickerController()
    var selectedImage: UIImage?
    let realm = try! Realm() // Доступ к хранилищу
    var items: Results<DataBase>! //Контейнер со свойствами обьекта DataBase
    var itemsArrayForCheck: Results<DataBase>!

 
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.input.textColor = UIColor.blue
        self.switch.addTarget(self, action: #selector(paramTarget(paramTarget:)) , for: .valueChanged)
        self.guestInfo.isHidden = true
        self.showDataSwitch.addTarget(self, action: #selector(swithTarget(paramTarget:)), for: .valueChanged)
        guest.delegate = self
        guest.tintColor = UIColor.clear
        pressAddimage()
        
    }
    
    //MARK: press Addimage
    func pressAddimage(){
        imagePicker.sourceType = UIImagePickerController.SourceType.camera
        imagePicker.delegate = self
        self.addImage.isHidden = true
        self.addImage.isUserInteractionEnabled = true
        self.addImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.didTappedImageView)))
    }
    
    //MARK: didTappedImageView
    @objc func didTappedImageView(){
        present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK: observer for showDataSwitch
    @objc func swithTarget(paramTarget: UISwitch){
        if paramTarget.isOn {
            self.guestInfo.isHidden = false
        } else {
            self.guestInfo.isHidden = true
            self.guestInfo.text = ""
        }
    }
    
    
    //MARK: observer for login logout switch
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
        HUD.show(.progress)
       
        self.items = realm.objects(DataBase.self)

        guard let id = self.idField.text else {return}
        guard var type = self.guest.text else {return}
      
        var imageData: Data? = nil
        var imageName: String? = nil
        
        
        if type == "Ученик"  {
            type = "children"
        } else if type == "Учитель" {
            type = "teacher"
        } else if type == "Гость" {
            type = "guest"
            imageData = self.selectedImage?.jpegData(compressionQuality: 1)
            imageName = self.selectedImage?.imageAsset.debugDescription
        }
        
        
        
        if(!id.isEmpty && !type.isEmpty){
            HUD.show(.progress)
            
            if self.guardVM.isConnnected() == true {
                if items.count > 0 {
                    if sendDataFromDataBase() == true {
                        try! realm.write {
                            self.realm.deleteAll()
                        }
                        
                        self.postGuestData(id: id, type: type, imageData: imageData, imageName: imageName)
                    }
                } else {
                    self.postGuestData(id: id, type: type, imageData: imageData, imageName: imageName)
                }
                
            } else {
                self.postGuestData(id: id, type: type, imageData: imageData, imageName: imageName)
            }
            
        }
        

        
    }
    
    //MARK: post and get data
    func postGuestData(id: String, type: String,imageData: Data?, imageName: String?){
        let timeStamp = Date.currentTimeStamp

        self.guardVM.sendInfo(id: id, status: self.status, type: type, time: String(timeStamp), imageData: imageData, imageName: imageName) { (error) in
            let db = DataBase()
            db.id = id
            db.type = type
            db.status = self.status
            db.imageData = imageData
            db.imageName = imageName
            db.time = String(timeStamp)
            try! self.realm.write {
                self.realm.add(db)
                
                HUD.hide()
                self.setupViewAfterSendData()
                Alert.displayAlert(title: "", message: "Данные сохранены в базу данных", vc: self)
                
                return
            }
            
            
        }
        
        self.guardVM.guestInfoBehaviorRelay.skip(1).subscribe(onNext: { (info) in
            
            if info.status == "ok" {
                HUD.hide()
                self.guestInfo.text = info.fio + "   " + info.about
                
                self.setupViewAfterSendData()
                Alert.displayAlert(title: "", message: info.message, vc: self)
            } else {
                HUD.hide()
                Alert.displayAlert(title: "", message: info.message, vc: self)
            }
        }).disposed(by: disposeBag)
        
        self.guardVM.errorBehaviorRelay.skip(1).subscribe(onNext: { (error) in
            HUD.hide()
            Alert.displayAlert(title: "Error", message: error.localizedDescription, vc: self)
        }).disposed(by: disposeBag)
        
    }


//MARK: sendDataFromDataBase
    func sendDataFromDataBase() -> Bool{

        for item in self.items {

            let id = item.id
            let status = item.status
            let type = item.type
            let time = item.time
            let imageData = item.imageData
            let imageName = item.imageName

            
            
            self.guardVM.sendInfo(id: id, status: status, type: type, time: time, imageData: imageData, imageName: imageName) { (error) in
                if error != nil {
                    Alert.displayAlert(title: "", message: error?.localizedDescription ?? "Ошибка соединения", vc: self)
                    return
                }
            }

            usleep(200000)
        }
        
        return true
    }
    
    //MARK: setupImegeAfterSendData
    func setupViewAfterSendData(){
        self.idField.text = ""
        self.guest.text = ""
        self.addImage.isHidden = true
        let image = UIImage(named: "add_photo-512.png")
        self.addImage.image = image
        self.addImage.layer.borderWidth = 0
    }

    //MARK: logoutButton
    @IBAction func logoutButton(_ sender: Any) {
        HUD.show(.progress)
        self.guardVM.logout { (error) in
            if error != nil {
                HUD.hide()
                Alert.displayAlert(title: "Ошибка", message: "Для получения данных требуется подключение к интернету", vc: self)
            }
        }
        
        self.guardVM.logoutBehaviorRelay.skip(1).subscribe(onNext: { (success) in
            if success.status == "ok" {
                HUD.hide()
                UserDefaults.standard.removeObject(forKey: "token")
                UserDefaults.standard.removeObject(forKey: "userType")
                Alert.displayAlert(title: "", message: success.message, vc: self)
                LoginLogoutManager.instance.updateRootVC()
                
            } else if success.status == "error"{
                HUD.hide()
                Alert.displayAlert(title: "Ошибка", message: success.message, vc: self)
            }
        }).disposed(by: disposeBag)
        
        self.guardVM.errorBehaviorRelay.skip(1).subscribe(onNext: { (error) in
            HUD.hide()
            Alert.displayAlert(title: "Error", message: error.localizedDescription, vc: self)
        }).disposed(by: disposeBag)
        
    }

    
}

