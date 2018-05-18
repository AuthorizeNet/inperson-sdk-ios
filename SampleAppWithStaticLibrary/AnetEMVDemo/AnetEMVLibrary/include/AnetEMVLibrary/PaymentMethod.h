//
//  PaymentMethod.h
//  AnetEMVSdk
//
//  Created by Taneja, Pankaj on 7/5/17.
//  Copyright © 2017 Pankaj Taneja. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PaymentMethod : NSObject {
    NSString *value;
}

@property (nonatomic, strong) NSString *value;
+ (PaymentMethod *)paymentMethod;
@end
