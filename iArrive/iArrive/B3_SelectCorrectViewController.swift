//
//  B3_SelectCorrectViewController.swift
//  iArrive
//
//  Created by Lam Wun Yin on 28/6/2019.
//  Copyright © 2019 Lam Wun Yin. All rights reserved.
//

import UIKit

class B3_SelectCorrectViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    // MARK: Properties
    
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var selectStaffTableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isLoadSampleStaff {
            publicFunctions().loadSampleStaff()
        }
        
        selectStaffTableView.delegate = self
        selectStaffTableView.dataSource = self

        confirmButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        confirmButton.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        confirmButton.layer.shadowOpacity = 1.0
        confirmButton.layer.shadowRadius = 0.0
        confirmButton.layer.masksToBounds = false
        confirmButton.layer.cornerRadius = 4.0
        
    }
    

    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return staffNameList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "selectStaffTableCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? selectStaffTableViewCell else {
            fatalError("The dequeued cell is not an instance of selectStaffTableViewCell.")
        }
        cell.layer.backgroundColor = UIColor.white.withAlphaComponent(0.5).cgColor
        cell.layer.shadowColor = UIColor.white.cgColor
        
        cell.nameLabel.text = staffNameList[indexPath.row].firstName + " " + staffNameList[indexPath.row].lastName
        cell.jobTitleLabel.text = staffNameList[indexPath.row].jobTitle
        cell.nameLabel.textColor = UIColor.black.withAlphaComponent(0.5)
        cell.jobTitleLabel.textColor = UIColor.black.withAlphaComponent(0.5)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 98.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellIdentifier = "selectStaffTableCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? selectStaffTableViewCell else {
            fatalError("The dequeued cell is not an instance of selectStaffTableViewCell.")
        }
        cell.layer.backgroundColor = UIColor.white.cgColor
        cell.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        cell.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
        cell.layer.shadowOpacity = 1.0
        cell.layer.shadowRadius = 0.0
        cell.layer.masksToBounds = false
        cell.layer.cornerRadius = 4.0
        
        cell.nameLabel.text = staffNameList[indexPath.row].firstName + " " + staffNameList[indexPath.row].lastName
        cell.jobTitleLabel.text = staffNameList[indexPath.row].jobTitle
        cell.nameLabel.textColor = UIColor.black
        cell.jobTitleLabel.textColor = UIColor.black
    }
    
    
    // MARK: Navigation

    @IBAction func pressedConfirmButton(_ sender: UIButton) {
        print("Pressed Confitm")
    }
    
    @IBAction func pressedCancelButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
