//
//  ANetApiResponse.h
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 3/3/11.
//  Copyright 2011 none. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"
#import "Messages.h"


@interface ANetApiResponse : NSObject {
	NSString *refId;
	Messages *messages;
}


@property (nonatomic, strong) NSString *refId;
@property (nonatomic, strong) Messages *messages;

/**
 * Creates an autoreleased  object
 * @return  an autoreleased  object.
 */
+ (ANetApiResponse *) anetApiResponse;

/**
 * Class method that takes in GDataXMLElement and returns a fully parsed
 * ANetApiResponse.  If the method was not able to parse the response,
 * a nil object is returned.
 * @return The parsed ANetApiResponse from parsing the GDataXMLElement or nil if unable
 * to parse the data.
 */
+ (ANetApiResponse *) buildANetApiResponse:(GDataXMLElement *)element;

/**
 * Class method that takes in GDataXMLElement and returns a fully parsed
 * ANetApiResponse for captcha.  If the method was not able to parse the response,
 * a nil object is returned.
 */
+ (ANetApiResponse *) buildANetApiResponseForCaptcha:(GDataXMLElement *)element;
+ (ANetApiResponse *) buildANetApiResponseTestAccountregistration:(GDataXMLElement *)element;
@end
