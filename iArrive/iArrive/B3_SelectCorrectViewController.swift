//
//  B3_SelectCorrectViewController.swift
//  iArrive
//
//  Created by Lam Wun Yin on 28/6/2019.
//  Copyright © 2019 Lam Wun Yin. All rights reserved.
//

import UIKit

class B3_SelectCorrectViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    

    // MARK: Properties
    
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var selectStaffTableView: UITableView!
    @IBOutlet weak var staffSearchBar: UISearchBar!
    var filteredStaffNameList = [staffMember] ()
    var searchActive = false
    let staffSearchController = UISearchController(searchResultsController: nil)
    var staff = staffMember.init(firstName: "", lastName: "", jobTitle: "", isCheckedIn: false)
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if isLoadSampleStaff {
//            publicFunctions().loadSampleStaff()
//        }

        staffNameList.sort(by: { $0.firstName < $1.firstName })
        
        staffSearchBar.delegate = self
        selectStaffTableView.delegate = self
        selectStaffTableView.dataSource = self
        selectStaffTableView.allowsMultipleSelection = false
        selectStaffTableView.allowsMultipleSelectionDuringEditing = false
        
        confirmButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        confirmButton.layer.shadowOffset = .zero
        confirmButton.layer.shadowOpacity = 1.0
        confirmButton.layer.shadowRadius = 0.0
        confirmButton.layer.masksToBounds = false
        confirmButton.layer.cornerRadius = 4.0
        confirmButton.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        confirmButton.titleLabel?.textColor = UIColor.black.withAlphaComponent(0.5)
        confirmButton.isEnabled = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        if staffSearchBar.text == "" {
            searchActive = false
            selectStaffTableView.reloadData()
        }
    }
    

    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive {
            return filteredStaffNameList.count
        }
        return staffNameList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "selectStaffTableCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? selectStaffTableViewCell else {
            fatalError("The dequeued cell is not an instance of selectStaffTableViewCell.")
        }
        if searchActive {
            staff = filteredStaffNameList[indexPath.row]
        } else {
            staff = staffNameList[indexPath.row]
        }
        cell.selectionStyle = .none
        cell.contentView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        
        cell.nameLabel.text = staff.firstName + " " + staff.lastName
        cell.jobTitleLabel.text = staff.jobTitle
        cell.nameLabel.textColor = UIColor.black.withAlphaComponent(0.5)
        cell.jobTitleLabel.textColor = UIColor.black.withAlphaComponent(0.5)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 98.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! selectStaffTableViewCell
        
        if searchActive {
            staff = filteredStaffNameList[indexPath.row]
        } else {
            staff = staffNameList[indexPath.row]
        }
        
        if !cell.didSelectedRow {
            cell.selectionStyle = .none
            cell.contentView.backgroundColor = UIColor.white
            cell.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            cell.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
            cell.layer.shadowOpacity = 1.0
            cell.layer.shadowRadius = 0.0
            cell.layer.masksToBounds = false
            cell.layer.cornerRadius = 4.0

            cell.nameLabel.text = staff.firstName + " " + staff.lastName
            cell.jobTitleLabel.text = staff.jobTitle
            cell.nameLabel.textColor = UIColor.black
            cell.jobTitleLabel.textColor = UIColor.black
            
            currentCheckingInOutFirstName = staff.firstName
            currentCheckingInOutLastName = staff.lastName
            currentCheckingInOutJobTitle = staff.jobTitle
            
            cell.didSelectedRow = true
            confirmButton.backgroundColor = UIColor.white
            confirmButton.setTitleColor(UIColor.black, for: .normal)
            confirmButton.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
            confirmButton.isEnabled = true
        } else {
            cell.selectionStyle = .none
            cell.contentView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
            cell.layer.shadowOffset = .zero
            
            cell.nameLabel.text = staff.firstName + " " + staff.lastName
            cell.jobTitleLabel.text = staff.jobTitle
            cell.nameLabel.textColor = UIColor.black.withAlphaComponent(0.5)
            cell.jobTitleLabel.textColor = UIColor.black.withAlphaComponent(0.5)
            
            currentCheckingInOutFirstName = ""
            currentCheckingInOutLastName = ""
            currentCheckingInOutJobTitle = ""
            cell.didSelectedRow = false
            confirmButton.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
            confirmButton.setTitleColor(UIColor.black.withAlphaComponent(0.5), for: .normal)
            confirmButton.layer.shadowOffset = .zero
            confirmButton.isEnabled = false
        }
    }
    

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! selectStaffTableViewCell
        
        if searchActive {
            staff = filteredStaffNameList[indexPath.row]
        } else {
            staff = staffNameList[indexPath.row]
        }
        
        cell.selectionStyle = .none
        cell.contentView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        cell.layer.shadowOffset = .zero

        cell.didSelectedRow = false
        cell.nameLabel.text = staff.firstName + " " + staff.lastName
        cell.jobTitleLabel.text = staff.jobTitle
        cell.nameLabel.textColor = UIColor.black.withAlphaComponent(0.5)
        cell.jobTitleLabel.textColor = UIColor.black.withAlphaComponent(0.5)
    }
    
    
    // MARK: UISearchBarDelegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredStaffNameList = staffNameList.filter({(staff : staffMember) -> Bool in
            return staff.firstName.lowercased().contains(searchText.lowercased()) || staff.lastName.lowercased().contains(searchText.lowercased()) || staff.jobTitle.lowercased().contains(searchText.lowercased())
        })
        if searchText == "" {
            searchActive = false
        } else {
            searchActive = true
        }
        selectStaffTableView.reloadData()
    }
    
    
    // MARK: Navigation

    @IBAction func pressedConfirmButton(_ sender: UIButton) {
        if let index = staffNameList.firstIndex(where: { $0.firstName == currentCheckingInOutFirstName && $0.lastName == currentCheckingInOutLastName && $0.jobTitle == currentCheckingInOutJobTitle }) {
            if staffNameList[index].isCheckedIn {
                staffNameList[index].isCheckedIn = false
                print(currentCheckingInOutFirstName, "Check out successfully")
            } else {
                staffNameList[index].isCheckedIn = true
                print(currentCheckingInOutFirstName, "Check in successfully")
            }
        } else {
            print("ERROR: There is no selected staff in the staffNameList.")
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pressedCancelButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
