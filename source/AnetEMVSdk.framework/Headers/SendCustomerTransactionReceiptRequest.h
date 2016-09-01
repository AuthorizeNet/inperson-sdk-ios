//
//  SendCustomerTransactionReceiptRequest.h
//  ANMobilePaymentLib
//
//  Created by Shiun Hwang on 6/16/11.
//  Copyright 2011 none. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AuthNetRequest.h"
#import "SettingType.h"

@interface SendCustomerTransactionReceiptRequest : AuthNetRequest {
    NSString *transId;
    NSString *customerEmail;
    NSMutableArray *emailSettings;
}


@property (nonatomic, strong) NSString *transId;
@property (nonatomic, strong) NSString *customerEmail;
@property (nonatomic, strong) NSMutableArray *emailSettings;

/**
 * Creates an autoreleased  object
 * @return  an autoreleased  object.
 */
+ (SendCustomerTransactionReceiptRequest *) sendCustomerTransactionReceiptRequest;
/**
 * NSString of the XML Request for this class
 * @return NSString of the XML Request structure for this class.
 */
- (NSString *) stringOfXMLRequest;
@end
