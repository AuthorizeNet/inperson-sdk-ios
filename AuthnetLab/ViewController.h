//
//  ViewController.h
//  AuthnetLab
//
//  Created by Shankar Gosain on 07/23/14.
//  Copyright (c) 2014. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuthNet.h"
#import "CreditCardViewController.h"

@interface ViewController : UIViewController<UITextFieldDelegate,AuthNetDelegate>{
    
}

@property (nonatomic, assign) UIActivityIndicatorView *activityIndicator;

@property (retain, nonatomic) IBOutlet UITextField *loginTextView;
@property (retain, nonatomic) IBOutlet UITextField *paswordTextView;
@property (retain, nonatomic) IBOutlet UIImageView *loginFieldEmptyImage;
@property (retain, nonatomic) IBOutlet UIImageView *passwordFieldEmptyImage;
@property (retain, nonatomic) IBOutlet UIButton *loginButton;

- (IBAction)onClickLoginAction:(id)sender;
- (IBAction)onClickInfoButton:(id)sender;

@property (nonatomic, strong) NSString *sessionToken;
@end
