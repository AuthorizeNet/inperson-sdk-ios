//
//  PaymentType.h
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 3/23/11.
//  Copyright 2011 none. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CreditCardType.h"
#import "BankAccountType.h"
#import "CreditCardTrackType.h"
#import "SwiperDataType.h"
#import "OpaqueDataType.h"

@interface PaymentType : NSObject {
    CreditCardType *creditCard;
    BankAccountType *bankAccount;
    CreditCardTrackType *trackData;
    SwiperDataType *swiperData;
    OpaqueDataType *opdata;
    
}

@property (nonatomic, strong) CreditCardType *creditCard;
@property (nonatomic, strong) BankAccountType *bankAccount;
@property (nonatomic, strong) CreditCardTrackType *trackData;
@property (nonatomic, strong) SwiperDataType *swiperData;
@property (nonatomic, strong) OpaqueDataType *opData;

/**
 * Creates an autoreleased  object
 * @return  an autoreleased  object.
 */
+ (PaymentType *) paymentType;

/**
 * NSString of the XML Request for this class
 * @return NSString of the XML Request structure for this class.
 */
- (NSString *) stringOfXMLRequest;

@end
