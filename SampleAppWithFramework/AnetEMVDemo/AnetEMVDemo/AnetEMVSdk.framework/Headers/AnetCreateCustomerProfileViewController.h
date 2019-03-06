//
//  AnetCreateCustomerProfileViewController.h
//  AnetEMVSdk
//
//  Created by Manjappa, Chinthan on 8/8/18.
//  Copyright © 2018 Pankaj Taneja. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnetViewController.h"
#import "AnetEMVConstants.h"

@protocol AnetCreateCustomerFromTransactionViewDelegate <NSObject>
@optional
- (void)dismissMe;
- (void)customerProfileCreationSuccessfull:(id)object;
- (void)customerProfileCreationFailed:(id)object;
- (void)customerProfileCancelAction:(id)object;

@end

@interface AnetCreateCustomerProfileViewController : AnetViewController<UITextFieldDelegate>

@property (assign, nonatomic) id <AnetCreateCustomerFromTransactionViewDelegate> delegate;
@property (nonatomic, strong) NSString *transactionID;
@property (nonatomic, strong) NSString *customerProfileID;

@property (nonatomic, strong) NSString *sessionToken;
@property (nonatomic, strong) NSString *mobileDeviceId;
@property (nonatomic, strong) NSString *name;

@property (assign, nonatomic) BOOL isAdditionalPaymentProfile;

@end
