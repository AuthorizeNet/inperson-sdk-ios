//
//  CreateProfileHeadlessViewController.swift
//  AnetEMVSdk
//
//  Created by Manjappa, Chinthan on 8/24/18.
//  Copyright © 2018 Pankaj Taneja. All rights reserved.
//

import UIKit

class CreateProfileHeadlessViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var settingItems: [String] = []
    var tableData = [String:String?]()
    var tableTextFieldData = [String]()
    var sessionToken: String? = nil
    var mobileDeviceID: String? = nil
    var mobileDeviceName: String? = nil
    var transactionID: String? = nil
    var isConsentBefore: Bool = false
    var transactionObject: AnetEMVTransactionRequest? = nil
    var isAdditionalProfile: Bool = false
    var profileID: String? = nil
    
    func showAlert(alertTitle: String, alertMessage: String, alertAction: String) {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func getTextFeildValuesFromTableView() ->[String:String?]?{
        var values = [String:String?]()
        for (index, value) in settingItems.enumerated() {
            let indexPath = IndexPath(row: index, section: 0)
            let cell = tableView.cellForRow(at: indexPath) as? HeadlessTableViewCell
            if let text = cell?.textField.text, !text.isEmpty {
                values[value] = text
            }
            else {
                values[value] = self.tableTextFieldData[index]
            }
        }
        return values
    }
    
    @IBAction func submitAction() {
        tableData = getTextFeildValuesFromTableView()!
        if (isAdditionalProfile) {
            self.createAdditionalPaymentProfile()
        }
        else {
            if ((tableData["Email ID"] as! String == "") &&  (tableData["Merchant Customer ID"]as! String == "") && (tableData["Description"] as! String == "")) {
                let alert = UIAlertController(title: "Alert", message: "At least one of the fields Customer ID, Description, or Email are required to save a Customer Profile", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    
                }))
                self.present(alert, animated: true, completion: nil)
            }
            else {
                if self.isConsentBefore {
                    
                }
                else {
                    self.createCustomerProfileAndPaymentProfile()
                }
            }
        }
        
    }
    
    func showConsentAlert() {
        let alert = UIAlertController(title: "Alert", message: "Message", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (isAdditionalProfile) {
            settingItems += ["First Name", "Last Name", "Company", "Address", "City", "State", "Zip", "Country", "Fax number", "Phone number" ]
        }
        else {
            settingItems += ["Email ID", "Merchant Customer ID", "Description","First Name", "Last Name", "Company", "Address", "City", "State", "Zip", "Country", "Fax number", "Phone number" ]
        }
        for (index, value) in settingItems.enumerated() {
            self.tableTextFieldData += [""]
            self.tableData[value] = ""
        }
    }
    
    
    // MARK: - Table View Delegate Methods
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.settingItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell: HeadlessTableViewCell = tableView.dequeueReusableCell(withIdentifier: "headlessCell") as! HeadlessTableViewCell
        tableViewCell.selectionStyle = UITableViewCellSelectionStyle.none
        tableViewCell.layoutMargins = UIEdgeInsets.zero
        tableViewCell.accessoryType = .none
        tableViewCell.label?.text = settingItems[indexPath.row]
        tableViewCell.textField.delegate = self
        tableViewCell.textField.text = tableTextFieldData[indexPath.row]
        return tableViewCell
    }
    
    
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? HeadlessTableViewCell {
            if let text = cell.textField.text {
                self.tableTextFieldData[indexPath.row] = text
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let pointInTable:CGPoint = textField.superview!.convert(textField.frame.origin, to:self.tableView)
        var contentOffset:CGPoint = self.tableView.contentOffset
        contentOffset.y  = pointInTable.y
        if let accessoryView = textField.inputAccessoryView {
            contentOffset.y -= accessoryView.frame.size.height
        }
        contentOffset.y -= 40
        self.tableView.contentOffset = contentOffset
        return true;
    }
    
    
    func createProfileRequest() -> AnetCreateCustomerProfileFromTransactionRequest {
        
        let customer:CustomerProfileBaseType = CustomerProfileBaseType()
        
        if let email = self.tableData["Email ID"] as? String {
            customer.email = email
        }
        if let customerID = self.tableData["Merchant Customer ID"] as? String {
            customer.merchantCustomerId = customerID
        }
        if let desc = self.tableData["Description"] as? String {
            customer.desc = desc
        }
        
        let aRequest:AnetCreateCustomerProfileFromTransactionRequest = AnetCreateCustomerProfileFromTransactionRequest()
        aRequest.customer = customer
        
        return aRequest
    }
    
    func createAddressBillto() -> CustomerAddressType {
        
        let billTo: CustomerAddressType = CustomerAddressType()
        
        if let firstName = self.tableData["First Name"] as? String {
            billTo.firstName = firstName
        }
        if let lastName = self.tableData["Last Name"] as? String {
            billTo.lastName = lastName
        }
        if let company = self.tableData["Company"] as? String {
            billTo.company = company
        }
        if let address = self.tableData["Address"] as? String {
            billTo.address = address
        }
        if let city = self.tableData["City"] as? String {
            billTo.city = city
        }
        if let state = self.tableData["State"] as? String {
            billTo.state = state
        }
        if let zip = self.tableData["Zip"] as? String {
            billTo.zip = zip
        }
        if let country = self.tableData["Country"] as? String {
            billTo.country = country
        }
        if let faxNumber = self.tableData["Fax number"] as? String {
            billTo.faxNumber = faxNumber
        }
        if let phoneNumber = self.tableData["Phone number"] as? String {
            billTo.phoneNumber = phoneNumber
        }
        
        return billTo
    }
    
    func createAdditionalPaymentProfile() -> Void {
        
        let req:AnetCreateCustomerProfileFromTransactionRequest = AnetCreateCustomerProfileFromTransactionRequest()
        req.transId = self.transactionID
        req.anetApiRequest.merchantAuthentication.sessionToken = self.sessionToken
        req.anetApiRequest.merchantAuthentication.mobileDeviceId = "454545454545454545454"
        
        let customerPaymentProfile: CustomerPaymentProfileType = CustomerPaymentProfileType()
        customerPaymentProfile.billTo = self.createAddressBillto()
        
        AnetCustomerProfileManager.sharedInstance().createAdditionalPaymentProfile(withProfileID: self.profileID!, with: customerPaymentProfile, withTransactionID: self.transactionID!, with: req.anetApiRequest.merchantAuthentication, successBlock: { response in
            
            if let resp: AnetCustomerProfileTransactionResponse = response as? AnetCustomerProfileTransactionResponse {
                let message: String = "Profile ID: \(resp.customerProfileId) Payment Profile ID: \(resp.customerPaymentProfileIdList)"
                self.showAlert(alertTitle: "Alert", alertMessage: message, alertAction: "OK")

            }
            
        }, failureBlock: { error in
            let message = error?.errorMessage
            self.showAlert(alertTitle: "Error", alertMessage: message!, alertAction: "OK")
        })
        
    }
    
    func createCustomerProfileAndPaymentProfile() -> Void {
        let customer:CustomerProfileBaseType = CustomerProfileBaseType()
        if let email = self.tableData["Email ID"] as? String {
            customer.email = email
        }
        if let customerID = self.tableData["Merchant Customer ID"] as? String {
            customer.merchantCustomerId = customerID
        }
        if let desc = self.tableData["Description"] as? String {
            customer.desc = desc
        }
        
        let req:AnetCreateCustomerProfileFromTransactionRequest = AnetCreateCustomerProfileFromTransactionRequest()
        req.transId = self.transactionID
        req.customer = customer
        req.anetApiRequest.merchantAuthentication.sessionToken = self.sessionToken
        req.anetApiRequest.merchantAuthentication.mobileDeviceId = "454545454545454545454"
        
        let customerPaymentProfile: CustomerPaymentProfileType = CustomerPaymentProfileType()
        customerPaymentProfile.billTo = self.createAddressBillto()
        
        AnetCustomerProfileManager.sharedInstance().createCustomerProfileAndPaymentProfile(self.transactionID!, with: req.anetApiRequest.merchantAuthentication, withCustomerProfile: customer, with: customerPaymentProfile, successBlock:{ (success) -> Void in
            // When download completes,control flow goes here.
            // download success
            if let resp: AnetCustomerProfileTransactionResponse = success as? AnetCustomerProfileTransactionResponse {
                print("success \(String(describing: success))")
                let message: String = "Profile ID: \(resp.customerProfileId) Payment Profile ID: \(resp.customerPaymentProfileIdList)"
                
                self.showAlert(alertTitle: "Alert", alertMessage: message, alertAction: "OK")
            }
        }, failureBlock: {(error) -> Void in
            let message = error?.errorMessage
            self.showAlert(alertTitle: "Error", alertMessage: message!, alertAction: "OK")
        })
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
