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
//Double check digit string lengths, and values as numbers
-(id) initWithOpeningDigits:(NSString *)openingDigits andClosingDigits:(NSString *)closingDigits{
    if ([openingDigits length] != 4) {
        NSLog(@"Opening digits string must be 4 characters in length");
        return NULL;
    } else if ([closingDigits length] != 4){
        NSLog(@"Closing digits string must be 4 characters in length");
        return NULL;
    } else if ([openingDigits integerValue] > 2359){
        NSLog(@"Opening digits string must be be a valid time");
        return NULL;
    } else if ([closingDigits integerValue] > 2359){
        NSLog(@"Closing digits string must be be a valid time");
        return NULL;
    } else {
        self.openingHours = [openingDigits integerValue];
        self.closingHours = [closingDigits integerValue];
        return self;
    }
}


//The idea behind this is to have pulled text from the database to convert into an hours object
-(id) initWithOneString:(NSString *)fourDigitsDashFourDigits{
    NSArray *openClose = [fourDigitsDashFourDigits componentsSeparatedByString:@"-"];
    self.openingHours = [[openClose objectAtIndex:0] integerValue];
    self.closingHours = [[openClose objectAtIndex:1] integerValue];
    return self;
}

//This method used to convert hours to string object to place into a database.
-(NSString *) hoursToDatabaseString:(Hours *) hoursObject{
    NSString *open = [NSString stringWithFormat:@"%d", [hoursObject openingHours]];
    NSString *closed = [NSString stringWithFormat:@"%d", [hoursObject closingHours]];
    NSString *concatString = [NSString stringWithFormat:@"%@-%@", open, closed];
    return concatString;
}

//This method used to convert hours into user-friendly displayable string
//I.e. something that's 1200-2300 in a database format becomes 12:00-23:00
-(NSString *) hoursToDisplayString:(Hours *) hoursObject{
    NSMutableString *openHours = [NSMutableString stringWithFormat:@"%d", [hoursObject openingHours]];
    NSMutableString *closedHours = [NSMutableString stringWithFormat:@"%d", [hoursObject closingHours]];
    NSMutableString *concatString = [NSMutableString stringWithFormat:@"%@-%@", openHours, closedHours];
    [concatString insertString:@":" atIndex:2];
    [concatString insertString:@":" atIndex:8];
    return [NSString stringWithString:concatString];
}
@end



