//
//  Hours.m
//  iNeed
//
//  Created by Anna Turner on 2/22/14.
//  Copyright (c) 2014 121. All rights reserved.
//

#import "Hours.h"

@implementation Hours


//This init method used when have opening and closing hours as separate strings.
//Double check digit string lengths
-(id) initWithOpeningDigits:(NSString *)openingDigits andClosingDigits:(NSString *)closingDigits{
    if ([openingDigits length] != 4) {
        NSLog(@"Opening digits string must be 4 characters in length");
        return NULL;
    } else if ([closingDigits length] != 4){
        NSLog(@"Closing digits string must be 4 characters in length");
        return NULL;
    } else {
        self.openingHours = [openingDigits integerValue];
        self.closingHours = [closingDigits integerValue];
        return self;
    }
}


//The idea behind this is to have pulled text from the database to convert into an hours object
-(id) initWithOneString:(NSString *)fourDigitsDashFourDigits{
    return self;
}

//This method used to convert hours to string object to either display or place into a database.
-(NSString *) hoursToString:(Hours *) hoursObject{
    return @"";
}
@end
