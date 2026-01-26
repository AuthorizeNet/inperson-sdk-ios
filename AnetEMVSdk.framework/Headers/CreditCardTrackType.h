//
//  CreditCardTrackType.h
//  ANMobilePaymentLib
//
//  Created by Authorize.Net on 3/23/11.
//  Copyright 2011 none. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CreditCardTrackType : NSObject {
    NSString *track1;
    NSString *track2;
}

@property (nonatomic, strong) NSString *track1;
@property (nonatomic, strong) NSString *track2;

/**
 * Creates an autoreleased  object
 * @return  an autoreleased  object.
 */
+ (CreditCardTrackType *) creditCardTrackType;

/**
 * NSString of the XML Request for this class
 * @return NSString of the XML Request structure for this class.
 */
- (NSString *) stringOfXMLRequest;

@end
