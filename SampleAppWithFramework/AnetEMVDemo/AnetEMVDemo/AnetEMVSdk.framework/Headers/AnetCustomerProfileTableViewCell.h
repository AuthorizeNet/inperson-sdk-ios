//
//  AnetCustomerProfileTableViewCell.h
//  AnetEMVSdk
//
//  Created by Manjappa, Chinthan on 8/17/18.
//  Copyright © 2018 Pankaj Taneja. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnetCustomerProfileTableViewCell : UITableViewCell <NSCoding>

@property (nonatomic, weak) IBOutlet UITextField *textField;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;



@end
