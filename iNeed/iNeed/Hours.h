//
//  Hours.h
//  iNeed
//
//  Created by Anna Turner on 2/22/14.
//  Copyright (c) 2014 121. All rights reserved.
//
//  This class stores an array of SingleHourSet instances, which represent all the open hours for a single day.
//  This is in military time.
//  There are initialization methods and accessor methods. 


#import <Foundation/Foundation.h>

@interface Hours : NSObject

//Properties

//I have to get rid of opening and closing hours, because there are multiple sets now.
//If this breaks something written in accessors somewhere else, we will have to change things there.
//@property NSInteger openingHours;
//@property NSInteger closingHours;

@property NSMutableArray* hoursArray;
@property bool closedAllDay;



//This init method used when have opening and closing hours as separate strings
-(id) initWithOpeningDigits:(NSString *)openingDigits andClosingDigits:(NSString *)closingDigits;

//This init method used when a place has no hours for a day, because it is closed.
-(id) initAsClosedAllDay;

//The idea behind this is to have pulled text from the database to convert into an hours object
//This string could have a lot of opening-closing hours in it, serparated by a percentage sign
//(we can format it to have a % sign between instances when we store it in the database
-(id) initWithOneString:(NSString *)stringOfHours;

//This method used to convert hours to string object to place into a database.
-(NSString *) hoursToDatabaseString;

//This method used to convert hours into user-friendly displayable string
-(NSString *) hoursToDisplayString;

@end
