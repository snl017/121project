//
//  Hours.m
//  iNeed
//
//  Created by Anna Turner on 2/22/14.
//  Copyright (c) 2014 121. All rights reserved.
//

#import "Hours.h"
#import "SingleHourSet.h"

@implementation Hours

//This init method is used when a place is not open at all during this day
//There are no hours to store in the array; instead, a property of a boolean is set to true.
-(id) initAsClosedAllDay{
    self.closedAllDay = true;
    return self;
}


//This method is used to initial an hours object with 1 or more sets of opening and closing hours
//This string could have a lot of opening-closing hours in it, serparated by a percentage sign
//(we can format it to have a % sign between instances when we store it in the database)
//Also works with the idea of having pulled text from the database to convert into an hours object
-(id) initWithOneString:(NSString *)stringOfHours{
    self.hoursArray = [[NSMutableArray alloc] init];
    if(![stringOfHours isEqualToString:@"Closed"]){
        NSArray *setsOfHours = [stringOfHours componentsSeparatedByString:@"%"];
        for (NSString* hour in setsOfHours){
            SingleHourSet *hourSet = [[SingleHourSet alloc] initWithOneString: hour];
            if(hourSet != NULL){
                [self.hoursArray addObject: hourSet];
            }else{
                return NULL;
            }
        }
    }else{
        self.closedAllDay = true;
    }
    return self;
}

//This method used to convert hours to string object to place into a database.
-(NSString *) hoursToDatabaseString{
    NSMutableString *dbString = [NSMutableString string];
    if(!self.closedAllDay){
        for (int i = 0; i < [self.hoursArray count]; i++){
            NSString *openClose = [[self.hoursArray objectAtIndex:i] hoursToDatabaseString];
            if (i==0){
                [dbString appendString: [NSMutableString stringWithString: openClose]];
            } else {
                [dbString appendString: [NSMutableString stringWithString: [@"%" stringByAppendingString: openClose]]];
            }
        }
    }else{
        dbString = [NSMutableString stringWithString:@"Closed"];
    }
    NSString *returnString;
    if(dbString){
        returnString = [NSString stringWithString: dbString];
    }else{
        returnString = @"Error";
    }
    return returnString;
}

//This method used to convert hours into user-friendly displayable string
//I.e. something that's 1200-2300 in a database format becomes 12:00-23:00
-(NSString *) hoursToDisplayString{
    NSMutableString *displayString = [NSMutableString string];
    if(!self.closedAllDay){
        for (int i = 0; i < [self.hoursArray count]; i++){
            NSString *openClose = [[self.hoursArray objectAtIndex:i] hoursToDisplayString];
            if (i==0){
                [displayString appendString: [NSMutableString stringWithString: openClose]];
            } else {
                [displayString appendString: [NSMutableString stringWithString: [@"\n" stringByAppendingString: openClose]]];
            }
        }
    }else{
        displayString = [NSMutableString stringWithString:@"Closed"];
    }
    NSString *returnString;
    if(displayString){
        returnString = [NSString stringWithString: displayString];
    }else{
        returnString = @"Error";
    }
    return returnString;
}



@end



