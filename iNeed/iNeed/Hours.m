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
//Double check digit string lengths, and values as numbers (nothing higher than 2359 and nothing with greater than 59 in last two digits)
-(id) initWithOpeningDigits:(NSString *)openingDigits andClosingDigits:(NSString *)closingDigits{
    //As integers
    NSInteger openingDigitsInteger = [openingDigits integerValue];
    NSInteger closingDigitsInteger = [closingDigits integerValue];
    NSInteger openingLastTwo = openingDigitsInteger % 100;
    NSInteger closingLastTwo = closingDigitsInteger % 100;
    
    if ([openingDigits length] != 4) {
        NSLog(@"ERROR: Opening digits string must be 4 characters in length");
        return NULL;
    } else if ([closingDigits length] != 4){
        NSLog(@"ERROR: Closing digits string must be 4 characters in length");
        return NULL;
    } else if (openingDigitsInteger > 2359){
        NSLog(@"ERROR: Opening digits string must be a valid time");
        return NULL;
    } else if (closingDigitsInteger > 2359){
        NSLog(@"ERROR: Closing digits string must be a valid time");
        return NULL;
    } else if (openingLastTwo > 59){
        NSLog(@"ERROR: Opening hours' last two digits must be < 60");
        return NULL;
    } else if (closingLastTwo > 59){
        NSLog(@"ERROR: Closing hours' last two digits must be < 60");
        return NULL;
    } else { //all is okay
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
-(NSString *) hoursToDatabaseString{
    NSString *open = [NSString stringWithFormat:@"%04d", [self openingHours]];
    NSString *closed = [NSString stringWithFormat:@"%04d", [self closingHours]];
    NSString *concatString = [NSString stringWithFormat:@"%@-%@", open, closed];
    return concatString;
}

//This method used to convert hours into user-friendly displayable string
//I.e. something that's 1200-2300 in a database format becomes 12:00-23:00
-(NSString *) hoursToDisplayString{
    NSMutableString *openHours = [NSMutableString stringWithFormat:@"%04d", [self openingHours]];
    NSMutableString *closedHours = [NSMutableString stringWithFormat:@"%04d", [self closingHours]];
    NSMutableString *concatString = [NSMutableString stringWithFormat:@"%@-%@", openHours, closedHours];
    [concatString insertString:@":" atIndex:2];
    [concatString insertString:@":" atIndex:8];
    return [NSString stringWithString:concatString];
}
@end



