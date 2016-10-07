//
//  AuthNetRequest.h
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 12/30/10.
//  Copyright 2010 none. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ANetApiRequest.h"

@interface AuthNetRequest : NSObject {
    ANetApiRequest *anetApiRequest;
}

@property (nonatomic, strong) ANetApiRequest *anetApiRequest;

/**
 * NSString of the XML Request for this class
 * @return NSString of the XML Request structure for this class.
 */
- (NSString *) stringOfXMLRequest;
@end
