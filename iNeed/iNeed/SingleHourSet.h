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

//This method is used to initial an hours object with a set of opening and closing hours
//This string is formatted as opening-closing hours, where each is 4 digits in military time
//Also works with the idea of having pulled text from the database to convert into an hours object
-(id) initWithOneString:(NSString *)fourDigitsDashFourDigits;

//This method used to convert hours to string object to place into a database.
-(NSString *) hoursToDatabaseString;

//This method used to convert hours into user-friendly displayable string
-(NSString *) hoursToDisplayString;

@end
