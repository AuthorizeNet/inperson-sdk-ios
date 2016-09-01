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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginAction() {
        if self.switchButton.on {
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
        
        mobileDeviceLoginRequest.anetApiRequest.merchantAuthentication.mobileDeviceId = "454545454545454545454"
        AuthNet.getInstance().mobileDeviceLoginRequest(mobileDeviceLoginRequest)
    }
    
    func mobileDeviceLoginSucceeded(response: MobileDeviceLoginResponse) {
        self.activity.stopAnimating()
        self.sessionToken = response.sessionToken
        self.performSegueWithIdentifier("showCart", sender: self)
    }
    
    func requestFailed(response: AuthNetResponse!) {
        self.activity.stopAnimating()
        
        let alertAction:UIAlertAction = UIAlertAction(title: "Ok", style: .Default, handler: ({(action:UIAlertAction) -> Void  in
            
            }))
        let alert:UIAlertController = UIAlertController(title: "Login failed", message: response.responseReasonText, preferredStyle: .Alert)
        alert.addAction(alertAction)
        self.presentViewController(alert, animated: true, completion: { () -> () in
            
        })
    }
    
    func connectionFailed(response: AuthNetResponse!) {
        self.activity.stopAnimating()
        
        let alertAction:UIAlertAction = UIAlertAction(title: "Ok", style: .Default, handler: ({(action:UIAlertAction) -> Void  in
            
        }))
        let alert:UIAlertController = UIAlertController(title: "Login failed", message: response.responseReasonText, preferredStyle: .Alert)
        alert.addAction(alertAction)
        self.presentViewController(alert, animated: true, completion: { () -> () in
            
        })
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let addProduct = segue.destinationViewController as! AddProductViewController
        addProduct.sessionToken = self.sessionToken
    }
}

