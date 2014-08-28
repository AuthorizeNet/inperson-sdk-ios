//
//  SwiperDataType.h
//  ANMobilePaymentLib
//
//  Created by Rajesh T on 1/29/13.
//
//

#import <Foundation/Foundation.h>

@interface SwiperDataType : NSObject
{
    NSString *deviceDescription;
    NSString *encryptedValue;
    NSString *encryptionType;

}
@property (nonatomic, strong) NSString *deviceDescription;
@property (nonatomic, strong) NSString *encryptedValue;
@property (nonatomic, strong) NSString *encryptionType;

/**
 * Creates an autoreleased  object
 * @return  an autoreleased  object.
 */
+ (SwiperDataType *) swiperDataType;

/**
 * NSString of the XML Request for this class
 * @return NSString of the XML Request structure for this class.
 */
- (NSString *) stringOfXMLRequest;

@end
