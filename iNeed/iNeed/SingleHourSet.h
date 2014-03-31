//
//  SingleHourSet.h
//  iNeed
//
//  Created by Shannon Lubetich on 3/30/14.
//  Copyright (c) 2014 121. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SingleHourSet : NSObject

//Properties
@property NSInteger openingHours;
@property NSInteger closingHours;
@property bool closedAllDay;

//This init method used when have opening and closing hours as separate strings
-(id) initWithOpeningDigits:(NSString *)openingDigits andClosingDigits:(NSString *)closingDigits;

//This init method used when a place has no hours for a day, because it is closed.
-(id) initAsClosedAllDay;

//The idea behind this is to have pulled text from the database to convert into an hours object
-(id) initWithOneString:(NSString *)fourDigitsDashFourDigits;

//This method used to convert hours to string object to place into a database.
-(NSString *) hoursToDatabaseString;

//This method used to convert hours into user-friendly displayable string
-(NSString *) hoursToDisplayString;

@end
