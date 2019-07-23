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
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    
    
    // MARK: Local Variables
    var filteredStaffNameList = [staffMember] ()
    var searchActive = false
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
        
        // Set up Staff Search Bar
        let textFieldInsideSearchBar = staffSearchBar.value(forKey: "searchField") as! UITextField
        textFieldInsideSearchBar.subviews.first?.backgroundColor = .white
        textFieldInsideSearchBar.subviews.first?.layer.cornerRadius = 17.5
        textFieldInsideSearchBar.subviews.first?.layer.borderColor = publicFunctions().hexStringToUIColor(hex: "#707070").cgColor
        textFieldInsideSearchBar.subviews.first?.layer.borderWidth = 1.0
        textFieldInsideSearchBar.subviews.first?.subviews.forEach({ $0.removeFromSuperview() })
        textFieldInsideSearchBar.backgroundColor = publicFunctions().hexStringToUIColor(hex: "#F7F7F7")
        
        // Set up Select Staff TableView
        selectStaffTableView.separatorStyle = .none
        selectStaffTableView.backgroundColor = publicFunctions().hexStringToUIColor(hex: "#F7F7F7")
        
        // Set up Confirm Button
        confirmButton.layer.cornerRadius = 4.0
        confirmButton.layer.applySketchShadow(
            color: UIColor(red: 0, green: 0, blue: 0, alpha: 0.16),
            x: 0,
            y: 3,
            blur: 6,
            spread: 0)
        
        // Set up Back Button
        backButton.setTitleColor(publicFunctions().hexStringToUIColor(hex: "#2FB4E6").withAlphaComponent(1), for: .normal)
        backButton.setTitleColor(UIColor.black.withAlphaComponent(0.7), for: .highlighted)
        
        // Associate Button objects with action methods (For updating button background colors and shadows)
        confirmButton.addTarget(self, action: #selector(buttonPressing), for: .touchDown)
        confirmButton.addTarget(self, action: #selector(buttonPressedInside), for: .touchUpInside)
        confirmButton.addTarget(self, action: #selector(buttonDraggedInside), for: .touchDragInside)
        confirmButton.addTarget(self, action: #selector(buttonDraggedOutside), for: .touchDragOutside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Initialize Confirm button state
        disableConfirmButton()
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
            disableConfirmButton()
        }
    }
    
    @objc func buttonPressedInside(_ sender: AnyObject?) {
        if sender === confirmButton {
            enableConfirmButton()
        }
    }
    
    @objc func buttonDraggedInside(_ sender: AnyObject?) {
        if sender === confirmButton {
            disableConfirmButton()
        }
    }
    
    @objc func buttonDraggedOutside(_ sender: AnyObject?) {
        if sender === confirmButton {
            enableConfirmButton()
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
        cell.contentView.backgroundColor = publicFunctions().hexStringToUIColor(hex: "#F7F7F7")
        cell.whiteRoundedView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        cell.nameLabel.text = staff!.firstName + " " + staff!.lastName
        cell.jobTitleLabel.text = staff!.jobTitle
        cell.nameLabel.textColor = UIColor.black.withAlphaComponent(0.3)
        cell.jobTitleLabel.textColor = UIColor.black.withAlphaComponent(0.3)
        return cell
    }
    
    // Set up height of each table cell in the selectStaffTableView
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 118.0
    }
    
    // Set up the selected table cell and related actions in the selectStaffTableView
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! selectStaffTableViewCell
        if searchActive {
            staff = filteredStaffNameList[indexPath.row]
        } else {
            staff = staffNameList[indexPath.row]
        }
        cell.nameLabel.text = staff!.firstName + " " + staff!.lastName
        cell.jobTitleLabel.text = staff!.jobTitle
        cell.selectionStyle = .none
//        cell.layer.cornerRadius = 4.0
        // When the cell is first selected
        if !cell.didSelectedRow {
            cell.nameLabel.textColor = UIColor.black
            cell.jobTitleLabel.textColor = UIColor.black
            cell.whiteRoundedView.backgroundColor = UIColor.white
            cell.whiteRoundedView.layer.showShadow()
            // Store the information of selected table cell
            currentCheckingInOutFirstName = staff!.firstName
            currentCheckingInOutLastName = staff!.lastName
            currentCheckingInOutJobTitle = staff!.jobTitle
            cell.didSelectedRow = true
            enableConfirmButton()
        } else { // When the cell is double selected (cancel the cell)
            cell.nameLabel.textColor = UIColor.black.withAlphaComponent(0.3)
            cell.jobTitleLabel.textColor = UIColor.black.withAlphaComponent(0.3)
            cell.whiteRoundedView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
            cell.whiteRoundedView.layer.hideShadow()
            currentCheckingInOutFirstName = ""
            currentCheckingInOutLastName = ""
            currentCheckingInOutJobTitle = ""
            cell.didSelectedRow = false
            disableConfirmButton()
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
        cell.nameLabel.text = staff!.firstName + " " + staff!.lastName
        cell.jobTitleLabel.text = staff!.jobTitle
        cell.nameLabel.textColor = UIColor.black.withAlphaComponent(0.3)
        cell.jobTitleLabel.textColor = UIColor.black.withAlphaComponent(0.3)
        cell.selectionStyle = .none
        cell.whiteRoundedView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        cell.whiteRoundedView.layer.hideShadow()
        cell.didSelectedRow = false
    }
    
    
    
    // MARK: Private Methods
    
    // Update Confirm Button State
    private func enableConfirmButton() {
        confirmButton.isEnabled = true
        confirmButton.setTitleColor(publicFunctions().hexStringToUIColor(hex: "#2E4365").withAlphaComponent(1), for: .normal)
        confirmButton.backgroundColor = UIColor.white.withAlphaComponent(1)
        confirmButton.layer.showShadow()
    }
    
    private func disableConfirmButton() {
        confirmButton.isEnabled = false
        confirmButton.setTitleColor(publicFunctions().hexStringToUIColor(hex: "#2E4365").withAlphaComponent(0.1), for: .normal)
        confirmButton.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        confirmButton.layer.hideShadow()
    }
    
    
    // MARK: Navigation

    // Back to Sign In Page when user presses Confirm Button with Check In / Out status updated
    @IBAction func pressedConfirmButton(_ sender: UIButton) {
        if let index = staffNameList.firstIndex(where: { $0.firstName == currentCheckingInOutFirstName && $0.lastName == currentCheckingInOutLastName && $0.jobTitle == currentCheckingInOutJobTitle }) {
            if staffNameList[index].isCheckedIn {
                staffNameList[index].isCheckedIn = false
                self.view.window?.hideAllToasts()
                self.view.window?.makeToast(currentCheckingInOutFirstName! + " " + currentCheckingInOutLastName! + " Check Out Successfully", duration: 5.0, point: toast_postion, title: nil, image: nil, style: publicFunctions().toastStyleSetUp(), completion: nil)
            } else {
                staffNameList[index].isCheckedIn = true
                self.view.window?.hideAllToasts()
                self.view.window?.makeToast(currentCheckingInOutFirstName! + " " + currentCheckingInOutLastName! + " Check In Successfully", duration: 5.0, point: toast_postion, title: nil, image: nil, style: publicFunctions().toastStyleSetUp(), completion: nil)
            }
        } else {
            print("ERROR: There is no selected staff in the staffNameList.")
        }
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    // Back to Sign In Page when user presses Confirm Button without any status updated
    @IBAction func pressedBackButton(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
}
