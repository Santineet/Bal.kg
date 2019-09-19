//
//  TeacherTVC.swift
//  Bal.kg
//
//  Created by Mairambek on 9/18/19.
//  Copyright © 2019 Sunrise. All rights reserved.
//

import UIKit

class TeacherTVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
  
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 6
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeacherListTVCell", for: indexPath) as! TeacherListTVCell

        cell.listLabel.text = String(indexPath.row)
        
        return cell
    }
 

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    @IBAction func logout(_ sender: Any) {
        
        
    }
    
  

}
