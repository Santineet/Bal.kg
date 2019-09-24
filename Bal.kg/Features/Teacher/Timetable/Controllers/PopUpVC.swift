//
//  PopUpVC.swift
//  Bal.kg
//
//  Created by Mairambek on 9/21/19.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit

class PopUpVC: UIViewController {

    @IBOutlet weak var selectionView: UIView!
    
    var classId: String?
    var subjectId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

       self.selectionView.layer.cornerRadius = 23
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        moveIn()
    }
    
    @IBAction func assessmentButton(_ sender: UIButton) {
        let markVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MarksTVC") as! MarksTVC

        if let classId = classId, let subjectId = subjectId {
            markVC.classId = classId
            markVC.subjectId = subjectId
            navigationController?.pushViewController(markVC, animated: true)
            self.view.removeFromSuperview()
        }

    }
    
    @IBAction func homeworkButton(_ sender: UIButton) {
        let hmVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeworkVC") as! HomeworkVC
        
        if let classId = classId, let subjectId = subjectId {
            hmVC.classId = classId
            hmVC.subjectId = subjectId
            navigationController?.pushViewController(hmVC, animated: true)
            self.view.removeFromSuperview()
        }

    }
    
    @IBAction func closePopUp(_ sender: UIButton) {
        moveOut()
    }
    
    func moveIn() {
        self.view.transform = CGAffineTransform(scaleX: 1.35, y: 1.35)
        self.view.alpha = 0.0
        
        UIView.animate(withDuration: 0.24) {
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.view.alpha = 1.0
        }
    }
    
    func moveOut() {
        UIView.animate(withDuration: 0.24, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.35, y: 1.35)
            self.view.alpha = 0.0
        }) { _ in
            self.view.removeFromSuperview()
        }
    }
    
    
    
    
}
