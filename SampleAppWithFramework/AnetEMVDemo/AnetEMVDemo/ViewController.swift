//
//  ViewController.swift
//  AnetEMVDemo
//
//  Created by Pankaj Taneja on 10/27/15.
//  Copyright © 2015 Pankaj Taneja. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController, AuthNetDelegate {

    @IBOutlet weak var login: UITextField!
    @IBOutlet weak var transactionKey: UITextField!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var switchButton: UISwitch!

    var apiLoginID:String? = nil
    var transactionKeyValue:String? = nil
    var context = LAContext()
    var authnet = AuthNet(environment: ENV_TEST);
    
    override func viewWillAppear(_ animated: Bool) {
        AnetEMVDemoUISettings.sharedInstance().registerDefaultsFromSettingsBundle()
        //AnetEMVUISettings.shared().signaturePadBackgroundImage = UIImage.init(named: "image1_bg.png")
        AnetEMVUISettings.shared().signaturePadCornerRadius = 5
        AnetEMVUISettings.shared().signaturePadBorderWidth  = 5
        AnetEMVUISettings.shared().signaturePadBorderColor = UIColor.black;
        //AnetEMVUISettings.shared().signatureScreenBackgroundImage = UIImage.init(named: "image2_bg.png")
        super.viewWillAppear(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginAction() {
        if self.switchButton.isOn {
            authnet = AuthNet(environment: ENV_TEST);
        } else {
            authnet = AuthNet(environment: ENV_LIVE);
        }
        AuthNet.getInstance().delegate = self
        AuthNet.getInstance().setLoggingEnabled(false)

        self.activity.startAnimating()

        // Store credentials for use in transactions
        self.apiLoginID = self.login.text
        self.transactionKeyValue = self.transactionKey.text

        // Validate credentials are provided
        guard let loginID = self.apiLoginID, !loginID.isEmpty,
              let transKey = self.transactionKeyValue, !transKey.isEmpty else {
            self.activity.stopAnimating()
            let alert = UIAlertController(title: "Invalid Input", message: "Please enter both API Login ID and Transaction Key", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }

        // No login request needed with transaction key authentication
        self.activity.stopAnimating()
        self.performSegue(withIdentifier: "showCart", sender: self)
    }
    
    func requestFailed(_ response: AuthNetResponse!) {
        self.activity.stopAnimating()
        
        let alertAction:UIAlertAction = UIAlertAction(title: "Ok", style: .default, handler: ({(action:UIAlertAction) -> Void  in
            
            }))
        let alert:UIAlertController = UIAlertController(title: "Login failed", message: response.responseReasonText, preferredStyle: .alert)
        alert.addAction(alertAction)
        self.present(alert, animated: true, completion: { () -> () in
            
        })
    }
    
    func connectionFailed(_ response: AuthNetResponse!) {
        self.activity.stopAnimating()
        
        let alertAction:UIAlertAction = UIAlertAction(title: "Ok", style: .default, handler: ({(action:UIAlertAction) -> Void  in
            
        }))
        let alert:UIAlertController = UIAlertController(title: "Login failed", message: response.responseReasonText, preferredStyle: .alert)
        alert.addAction(alertAction)
        self.present(alert, animated: true, completion: { () -> () in
            
        })
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let addProduct = segue.destination as! AddProductViewController
        addProduct.apiLoginID = self.apiLoginID
        addProduct.transactionKeyValue = self.transactionKeyValue
    }
}

