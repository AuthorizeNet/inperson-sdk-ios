//
//  Messages.h
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 1/17/11.
//  Copyright 2011 none. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"

@class AuthNetMessage;

@interface Messages : NSObject {
	
	NSString *resultCode;
	NSMutableArray *messageArray;

}

@property (nonatomic, strong) NSString *resultCode;
@property (nonatomic, strong) NSMutableArray *messageArray;

/**
 * Creates an autoreleased  object
 * @return  an autoreleased  object.
 */
+ (Messages *) messages;
+ (Messages *) buildMessages:(GDataXMLElement *)element;


+ (Messages *) buildMessagesForCaptchaResponse:(GDataXMLElement *)element;
+ (Messages *) buildMessagesForTestAccountRegistrationResponse:(GDataXMLElement *)element;
@end
