//
//  SingleHourSet.m
//  iNeed
//
//  Created by Shannon Lubetich on 3/30/14.
//  Copyright (c) 2014 121. All rights reserved.
//

#import "SingleHourSet.h"

@implementation SingleHourSet

//helper method to check the legal format of hours
-(bool) inLegalHourFormat:(NSString *) hours{
    //change into ints
    NSInteger hoursDigits = [hours integerValue];
    //get last 2 digits
    NSInteger minutes = hoursDigits % 100;
    //check that has 4 digits, is < 2400, and minutes are < 60
    return ([hours length] == 4 && hoursDigits < 2400 && minutes < 60);
}

//This method is used to initial an hours object with a set of opening and closing hours
//This string is formatted as opening-closing hours, where each is 4 digits in military time
//Also works with the idea of having pulled text from the database to convert into an hours object
-(id) initWithOneString:(NSString *)fourDigitsDashFourDigits{
    if(![fourDigitsDashFourDigits isEqualToString:@"Closed"]){
        NSArray *openClose = [fourDigitsDashFourDigits componentsSeparatedByString:@"-"];
        NSString *openDigits = [openClose objectAtIndex:0];
        NSString *closeDigits = [openClose objectAtIndex:1];
        if([self inLegalHourFormat:openDigits] && [self inLegalHourFormat:closeDigits]){
            self.openingHours = [openDigits integerValue];
            self.closingHours = [closeDigits integerValue];
            self.closedAllDay = false;
        }else{
            NSLog(@"ERROR: hours are not in proper format");
            return NULL;
        }
    }else{
        self.closedAllDay = true;
    }
    return self;
}

//This method used to convert hours to string object to place into a database.
-(NSString *) hoursToDatabaseString{
    NSString *concatString;
    if(!self.closedAllDay){
        NSString *open = [NSString stringWithFormat:@"%04d", [self openingHours]];
        NSString *closed = [NSString stringWithFormat:@"%04d", [self closingHours]];
        concatString = [NSString stringWithFormat:@"%@-%@", open, closed];
    }else{
        concatString = @"Closed";
    }
    return concatString;
}

//This method used to convert hours into user-friendly displayable string
//I.e. something that's 1200-2300 in a database format becomes 12:00-23:00
-(NSString *) hoursToDisplayString{
    if(!self.closedAllDay){
        NSString *openAm, *closedAm;
        int standardOpenHrs, standardClosedHrs;
        int militaryOpen = [self openingHours];
        int militaryClosed = [self closingHours];
        
        int openHrs = militaryOpen/100;
        if(openHrs < 12){
            openAm = @"am";
        }else{
            openAm = @"pm";
        }
        if(openHrs == 12) {
            standardOpenHrs = 12;
        }else if(openHrs == 0){
            standardOpenHrs = 12;
        }else{
            standardOpenHrs = openHrs % 12;
        }
        int standardOpenMin = militaryOpen%100;
        int standardOpen = (standardOpenHrs*100) + standardOpenMin;
        
        int closedHrs = militaryClosed/100;
        if(closedHrs < 12){
            closedAm = @"am";
        }else{
            closedAm = @"pm";
        }
        if(closedHrs == 12) {
            standardClosedHrs = 12;
        }else if(closedHrs == 0){
            standardClosedHrs = 12;
        }else{
            standardClosedHrs = closedHrs % 12;
        }
        int standardClosedMin = militaryClosed%100;
        int standardClosed = (standardClosedHrs*100) + standardClosedMin;
        NSMutableString *openHours = [NSMutableString stringWithFormat:@"%d %@", standardOpen, openAm];
        NSMutableString *closedHours = [NSMutableString stringWithFormat:@"%d %@", standardClosed, closedAm];
        [openHours insertString:@":" atIndex:(openHours.length-5)];
        [closedHours insertString:@":" atIndex:(closedHours.length-5)];
        NSMutableString *concatString = [NSMutableString stringWithFormat:@"%@ - %@", openHours, closedHours];
        return [NSString stringWithString:concatString];
    }else{
        return @"Closed";
    }
}

@end
