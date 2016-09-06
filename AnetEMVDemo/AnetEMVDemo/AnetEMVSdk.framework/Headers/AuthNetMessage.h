//
//  Message.h
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 1/18/11.
//  Copyright 2011 none. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"

@interface AuthNetMessage : NSObject {

	NSString *code;
	NSString *text;
	NSString *mDescription;
}

@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *mDescription;

/**
 * Creates an autoreleased  object
 * @return  an autoreleased  object.
 */
+ (AuthNetMessage *) message;

/**
 * Class method that takes in GDataXMLElement and returns a fully parsed
 * AuthNetMessage.  If the method was not able to parse the response,
 * a nil object is returned.
 * @return The parsed AuthNetMessage from parsing the GDataXMLElement or nil if unable
 * to parse the data.
 */
+ (AuthNetMessage *) buildMessage:(GDataXMLElement *)element;

@end
