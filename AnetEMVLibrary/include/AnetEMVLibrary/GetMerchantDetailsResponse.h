//
//  GetMerchantDetailsResponse.h
//  AnetEMVSdk
//
//  Created by Taneja, Pankaj on 7/5/17.
//  Copyright © 2017 Pankaj Taneja. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AuthNetResponse.h"
#import "Processor.h"
#import "MarketType.h"
#import "ProductCode.h" 
#import "PaymentMethod.h"
#import "Currency.h"

@interface GetMerchantDetailsResponse : AuthNetResponse

@property (nonatomic, strong) NSString *gatewayId;
@property (nonatomic, strong) NSString *merchantName;
@property (nonatomic, strong) NSString *publicClientKey;

@property (nonatomic, assign) BOOL isTestMode;

@property (nonatomic, strong) NSMutableArray *processors;
@property (nonatomic, strong) NSMutableArray *marketTypes;
@property (nonatomic, strong) NSMutableArray *productCodes;
@property (nonatomic, strong) NSMutableArray *paymentMethods;
@property (nonatomic, strong) NSMutableArray *currencies;

+ (GetMerchantDetailsResponse *) getMerchantDetailsResponse;

+ (GetMerchantDetailsResponse *)parseMerchantDetailsDetail:(NSData *)xmlData;
@end
