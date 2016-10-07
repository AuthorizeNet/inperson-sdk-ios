//
//  AnetEMVResponse.h
//  AnetEMVSdk
//
//  Created by Senthil Kumar Periyasamy on 12/2/15.
//  Copyright © 2015 Authorize.Net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"
#import "AnetEMVTag.h"

@interface AnetEMVResponse : NSObject
{
    NSString * tlvData;
    NSMutableArray * tags;
}

@property (nonatomic, strong) NSString *tlvData;
@property (nonatomic, strong) NSMutableArray *tags;

+ (AnetEMVResponse *) emvResponse;
+ (AnetEMVResponse *) buildEMVResponse:(GDataXMLElement *)element;
- (NSString *)tagValue:(NSString *)iTagDescription;
@end
