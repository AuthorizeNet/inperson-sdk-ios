//
//  AnetBTObject.h
//  AnetEMVSdk
//
//  Created by Taneja, Pankaj on 5/23/17.
//  Copyright © 2017 Pankaj Taneja. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnetBTObject : NSObject <NSCoding>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) id UUID;
@end
