//
//  detailCell.m
//  iNeed
//
//  Created by Anna Turner on 4/26/14.
//  Copyright (c) 2014 121. All rights reserved.
//

#import "detailCell.h"

@implementation detailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
