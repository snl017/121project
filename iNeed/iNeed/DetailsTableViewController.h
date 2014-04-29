//
//  DetailsTableViewController.h
//  iNeed
//
//  Created by jarthurcs on 2/20/14.
//  Copyright (c) 2014 121. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "detailCell.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface DetailsTableViewController : UITableViewController


@property NSString *specificCategory;
@property NSMutableArray *places;

//Background properties
@property UIImageView *backgroundImageView;
@end
