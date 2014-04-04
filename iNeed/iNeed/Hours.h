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
@property NSMutableArray* hoursArray;
@property bool closedAllDay;


//This init method used when a place has no hours for a day, because it is closed.
-(id) initAsClosedAllDay;

//This method is used to initial an hours object with 1 or more sets of opening and closing hours
//This string could have a lot of opening-closing hours in it, serparated by a percentage sign
//(we can format it to have a % sign between instances when we store it in the database)
//Also works with the idea of having pulled text from the database to convert into an hours object
-(id) initWithOneString:(NSString *)stringOfHours;

//This method used to convert hours to string object to place into a database.
-(NSString *) hoursToDatabaseString;

//This method used to convert hours into user-friendly displayable string
-(NSString *) hoursToDisplayString;

@end
