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
    @IBOutlet weak var pasword: UITextField!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var switchButton: UISwitch!

    var sessionToken:String? = nil
    var context = LAContext()
    var authnet = AuthNet(environment: ENV_TEST);
    
    override func viewWillAppear(_ animated: Bool) {
        AnetEMVDemoUISettings.sharedInstance().registerDefaultsFromSettingsBundle()
        //AnetEMVUISettings.shared().signaturePadBackgroundImage = UIImage.init(named: "image2_bg.png")
        AnetEMVUISettings.shared().signaturePadCornerRadius = 5
        AnetEMVUISettings.shared().signaturePadBorderWidth  = 5
        AnetEMVUISettings.shared().signaturePadBorderColor = UIColor.black
        //AnetEMVUISettings.shared().signatureScreenBackgroundImage = UIImage.init(named: "bg.jpg")
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
        AuthNet.getInstance().setLoggingEnabled(true)

        self.activity.startAnimating()
        let mobileDeviceLoginRequest = MobileDeviceLoginRequest()
        
        mobileDeviceLoginRequest.anetApiRequest.merchantAuthentication.name = self.login.text
        mobileDeviceLoginRequest.anetApiRequest.merchantAuthentication.password = self.pasword.text
        
//        mobileDeviceLoginRequest.anetApiRequest.merchantAuthentication.name = "vitalretailowner1"
//        mobileDeviceLoginRequest.anetApiRequest.merchantAuthentication.password = "Authnet102"
        
        mobileDeviceLoginRequest.anetApiRequest.merchantAuthentication.mobileDeviceId = "454545454545454545454"
        AuthNet.getInstance().mobileDeviceLoginRequest(mobileDeviceLoginRequest)
    }
    
    func mobileDeviceLoginSucceeded(_ response: MobileDeviceLoginResponse) {
        self.activity.stopAnimating()
        self.sessionToken = response.sessionToken
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
        addProduct.sessionToken = self.sessionToken
    }
}

