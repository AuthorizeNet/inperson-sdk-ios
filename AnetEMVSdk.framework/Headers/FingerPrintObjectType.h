//
//  FingerPrintObjectType.h
//  Anet SDK
//
//  Created by Authorize.Net on 25/06/14.
//  Copyright (c) 2014 MMA. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 * Credit Card related Finger Print information
 */

@interface FingerPrintObjectType : NSObject {
	NSString *hashValue;
	int sequenceNumber;
	long long timeStamp;
}

@property (nonatomic, strong) NSString *hashValue;
@property (nonatomic) int sequenceNumber;
@property (nonatomic) long long timeStamp;


/**
 * Creates an autoreleased FingerPrintObjectType object;
 * @return FingerPrintObjectType an autoreleased FingerPrintObjectType object.
 */
+ (id) fingerPrintObjectType;

/**
 * NSString of the XML Request for this class
 * @return NSString of the XML Request structure for this class.
 */
- (NSString *) stringOfXMLRequest;

@end
