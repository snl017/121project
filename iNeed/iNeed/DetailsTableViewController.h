//
//  DetailsTableViewController.h
//  iNeed
//
//  Created by jarthurcs on 2/20/14.
//  Copyright (c) 2014 121. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "detailCell.h"

@interface DetailsTableViewController : UITableViewController


@property NSString *specificCategory;
@property NSMutableArray *places;

//Background properties
@property UIImageView *backgroundImageView;
@end
