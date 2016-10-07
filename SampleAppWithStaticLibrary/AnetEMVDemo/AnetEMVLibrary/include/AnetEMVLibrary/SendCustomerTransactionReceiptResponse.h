//
//  SendCustomerTransactionReceiptResponse.h
//  ANMobilePaymentLib
//
//  Created by Shiun Hwang on 6/16/11.
//  Copyright 2011 none. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AuthNetResponse.h"
#import "GDataXMLNode.h"

@interface SendCustomerTransactionReceiptResponse : AuthNetResponse {
    
}


+ (SendCustomerTransactionReceiptResponse *) sendCustomerTransactionReceiptResponse;
+ (SendCustomerTransactionReceiptResponse *) parseSendCustomerTransactionReceiptResponse:(NSData *)xmlData;
+ (SendCustomerTransactionReceiptResponse *) loadSendCustomerTransactionReceiptResponseFromFilename:(NSString *)filename;

@end
