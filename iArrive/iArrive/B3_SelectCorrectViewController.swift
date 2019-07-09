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
    @IBOutlet weak var staffSearchBar: UISearchBar!
    @IBOutlet weak var selectStaffTableView: UITableView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    
    
    // MARK: Local Variables
    var filteredStaffNameList = [staffMember] ()
    var searchActive = false
    let staffSearchController = UISearchController(searchResultsController: nil)
    var staff: staffMember?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load Sample Staff for debugging (Delete after deployment)
        if isLoadSampleStaff {
            publicFunctions().loadSampleStaff()
        }
        
        // Update delegate, data source, and other initialization
        staffSearchBar.delegate = self
        selectStaffTableView.delegate = self
        selectStaffTableView.dataSource = self
        selectStaffTableView.allowsMultipleSelection = false
        selectStaffTableView.allowsMultipleSelectionDuringEditing = false

        // Sort the Staff Name List (according to ascending order of First Name)
        staffNameList.sort(by: { $0.firstName < $1.firstName })
        
        // Set up Confirm Button
        confirmButton.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        confirmButton.titleLabel?.textColor = UIColor.black.withAlphaComponent(0.5)
        confirmButton.layer.applySketchShadow(
            color: UIColor(red: 0, green: 0, blue: 0, alpha: 0.25),
            alpha: 1.0,
            x: 0,
            y: 0,
            blur: 4,
            spread: 0)
        confirmButton.layer.cornerRadius = 4.0
        confirmButton.isEnabled = false
        
        // Associate Button objects with action methods (For updating button background colors and shadows)
        confirmButton.addTarget(self, action: #selector(buttonPressing), for: .touchDown)
        confirmButton.addTarget(self, action: #selector(buttonPressedInside), for: .touchUpInside)
        confirmButton.addTarget(self, action: #selector(buttonDraggedInside), for: .touchDragInside)
        confirmButton.addTarget(self, action: #selector(buttonDraggedOutside), for: .touchDragOutside)
        cancelButton.addTarget(self, action: #selector(buttonPressing), for: .touchDown)
        cancelButton.addTarget(self, action: #selector(buttonPressedInside), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(buttonDraggedInside), for: .touchDragInside)
        cancelButton.addTarget(self, action: #selector(buttonDraggedOutside), for: .touchDragOutside)
    }
    
    // Hide keyboard and Update selectStaffTableView when users tap space outside search bar
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        if staffSearchBar.text == "" {
            searchActive = false
            selectStaffTableView.reloadData()
        }
    }
    
    
    
    // MARK: Action Methods for Buttons
    // For updating button background colors and shadows
    
    @objc func buttonPressing(_ sender: AnyObject?) {
        if sender === confirmButton {
            confirmButton.backgroundColor = UIColor.white.withAlphaComponent(0.5)
            confirmButton.layer.shadowOffset = .zero
        } else {
            cancelButton.setTitleColor(publicFunctions().hexStringToUIColor(hex: "#2FB4E6").withAlphaComponent(0.5), for: .normal)
        }
    }
    
    @objc func buttonPressedInside(_ sender: AnyObject?) {
        if sender === confirmButton {
            confirmButton.backgroundColor = UIColor.white.withAlphaComponent(1.0)
            confirmButton.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
        } else {
            cancelButton.setTitleColor(publicFunctions().hexStringToUIColor(hex: "#2FB4E6").withAlphaComponent(1), for: .normal)
        }
    }
    
    @objc func buttonDraggedInside(_ sender: AnyObject?) {
        if sender === confirmButton {
            confirmButton.backgroundColor = UIColor.white.withAlphaComponent(0.5)
            confirmButton.layer.shadowOffset = .zero
        } else {
            cancelButton.setTitleColor(publicFunctions().hexStringToUIColor(hex: "#2FB4E6").withAlphaComponent(0.5), for: .normal)
        }
    }
    
    @objc func buttonDraggedOutside(_ sender: AnyObject?) {
        if sender === confirmButton {
            confirmButton.backgroundColor = UIColor.white.withAlphaComponent(1.0)
            confirmButton.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
        } else {
            cancelButton.setTitleColor(publicFunctions().hexStringToUIColor(hex: "#2FB4E6").withAlphaComponent(1), for: .normal)
        }
    }
    
    
    
    // MARK: UISearchBarDelegate
    
    // Set up the search condition of the search bar
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
    
    // Hide keyboard when user presses Search button in the keyboard
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
    

    // MARK: UITableViewDelegate
    
    // Set up the number of table cells in the selectStaffTableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive {
            return filteredStaffNameList.count
        }
        return staffNameList.count
    }
    
    // Set up each table cell in the selectStaffTableView
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
        cell.nameLabel.text = staff!.firstName + " " + staff!.lastName
        cell.jobTitleLabel.text = staff!.jobTitle
        cell.nameLabel.textColor = UIColor.black.withAlphaComponent(0.5)
        cell.jobTitleLabel.textColor = UIColor.black.withAlphaComponent(0.5)
        return cell
    }
    
    // Set up the height of each table cell in the selectStaffTableView
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 98.0
    }
    
    // Set up the selected table cell and related actions in the selectStaffTableView
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! selectStaffTableViewCell
        if searchActive {
            staff = filteredStaffNameList[indexPath.row]
        } else {
            staff = staffNameList[indexPath.row]
        }
        // When the cell is first selected
        if !cell.didSelectedRow {
            cell.selectionStyle = .none
            cell.contentView.backgroundColor = UIColor.white
            cell.layer.applySketchShadow(
                color: UIColor(red: 0, green: 0, blue: 0, alpha: 0.25),
                alpha: 1.0,
                x: 3,
                y: 3,
                blur: 4,
                spread: 0)
            cell.layer.masksToBounds = false
            cell.layer.cornerRadius = 4.0
            cell.nameLabel.text = staff!.firstName + " " + staff!.lastName
            cell.jobTitleLabel.text = staff!.jobTitle
            cell.nameLabel.textColor = UIColor.black
            cell.jobTitleLabel.textColor = UIColor.black
            // Store the information of selected table cell
            currentCheckingInOutFirstName = staff!.firstName
            currentCheckingInOutLastName = staff!.lastName
            currentCheckingInOutJobTitle = staff!.jobTitle
            cell.didSelectedRow = true
            confirmButton.backgroundColor = UIColor.white
            confirmButton.setTitleColor(UIColor.black, for: .normal)
            confirmButton.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
            confirmButton.isEnabled = true
        } else { // When the cell is double selected (cancel)
            cell.selectionStyle = .none
            cell.contentView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
            cell.layer.shadowOffset = .zero
            cell.nameLabel.text = staff!.firstName + " " + staff!.lastName
            cell.jobTitleLabel.text = staff!.jobTitle
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
    
    // Set up the deselected table cells (all other table cell beside the selected one) and related actions in the selectStaffTableView
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
        cell.nameLabel.text = staff!.firstName + " " + staff!.lastName
        cell.jobTitleLabel.text = staff!.jobTitle
        cell.nameLabel.textColor = UIColor.black.withAlphaComponent(0.5)
        cell.jobTitleLabel.textColor = UIColor.black.withAlphaComponent(0.5)
    }
    
    
    
    // MARK: Navigation

    // Back to Sign In Page when user presses Confirm Button with Check In / Out status updated
    @IBAction func pressedConfirmButton(_ sender: UIButton) {
        if let index = staffNameList.firstIndex(where: { $0.firstName == currentCheckingInOutFirstName && $0.lastName == currentCheckingInOutLastName && $0.jobTitle == currentCheckingInOutJobTitle }) {
            if staffNameList[index].isCheckedIn {
                staffNameList[index].isCheckedIn = false
                print(currentCheckingInOutFirstName ?? "", "Check out successfully")
            } else {
                staffNameList[index].isCheckedIn = true
                print(currentCheckingInOutFirstName ?? "", "Check in successfully")
            }
        } else {
            print("ERROR: There is no selected staff in the staffNameList.")
        }
        self.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: {})
    }
    
    // Back to Sign In Page when user presses Confirm Button without any status updated
    @IBAction func pressedCancelButton(_ sender: UIButton) {
        self.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: {})
    }
    
}
