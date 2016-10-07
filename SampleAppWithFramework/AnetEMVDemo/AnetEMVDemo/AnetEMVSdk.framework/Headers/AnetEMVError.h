//
//  AnetEMVError.h
//  AnetEMVSdk
//
//  Created by Pankaj Taneja on 10/27/15.
//  Copyright © 2015 Authorize.Net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnetEMVManager.h"

@interface AnetEMVError : NSError

@property (nonatomic, assign) ANETEmvErrorCode errorCode;
@property (nonatomic, strong) NSString *errorMessage;

- (instancetype)initWithErrorCode:(ANETEmvErrorCode)iErrorCode
                       andMessage:(NSString *)iMessage;
@end
