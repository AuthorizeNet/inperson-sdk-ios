//
//  CreditCardViewController.h
//  AuthnetLab
//
//  Created by Shankar Gosain on 07/23/14.
//  Copyright (c) 2014. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PassKit/PKPaymentRequest.h>
#import <PassKit/PKPaymentToken.h>
#import <PassKit/PKPayment.h>
#import <PassKit/PKPaymentAuthorizationViewController.h>

#import "DecimalKeypadView.h"
#import "CreditCardType.h"
#import "AuthNet.h"
#import "Address.h"


@interface CreditCardViewController : UIViewController

@property (nonatomic, strong) IBOutlet DecimalKeypadView *keypad;
@property (nonatomic, assign) UIActivityIndicatorView *activityIndicator;

@property (nonatomic, strong) IBOutlet UITextField *creditCardTextField;
@property (nonatomic, strong) IBOutlet UITextField *expirationTextField;
@property (nonatomic, strong) IBOutlet UITextField *cvv2TextField;
@property (nonatomic, strong) IBOutlet UITextField *zipTextField;
@property (nonatomic, strong) IBOutlet UIButton *signAuthButton;
@property (nonatomic, strong) IBOutlet UIButton *swipeNowButton;

@property (nonatomic, strong) NSString *creditCardBuf;
@property (nonatomic, strong) NSString *expirationBuf;
@property (nonatomic, strong) NSString *sessionToken;


@property (nonatomic, strong) UITextField *currentField;

@property (nonatomic, assign) Address *billingAddress;
@property (nonatomic, assign) Address *shippingAddress;



// Designated initalizer
// -- this view is only meant to be put in nibs.
// (Although it would be easy to modify it to be instantiated in code.)
//- (id)initWithCoder:(NSCoder *)aDecoder;
- (IBAction)onClickLogoutPressed:(id)sender;
- (IBAction) infoPressed;
- (IBAction) swipePressed;
- (IBAction) continuePressed;
- (IBAction)onClickBarItemInfo:(id)sender;
- (IBAction)buyWithApplePayButtonPressed:(id)sender;

// Called during view load to initialize the view
//- (void)initializeViews:(DecimalKeypadView *)keypad;

// Called to clear the input fields
- (void)clearInputFields;

// Returns expiration data without separator
- (NSString*) expirationDateWithoutSeparator;

@end

//@protocol CreditCardInfoViewDelegate
//@required
//- (void)creditCardInfoView:(CreditCardInfoView *)sender continuePressed:(UIButton *)button;
//- (void)creditCardInfoView:(CreditCardInfoView *)sender swipePressed:(UIButton *)button;

//@end
