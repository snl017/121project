//
//  Hours.h
//  iNeed
//
//  Created by Anna Turner on 2/22/14.
//  Copyright (c) 2014 121. All rights reserved.
//
//  This class is an object representing the opening hours of any given day. We are writing in european/military time format
//  i.e. 6pm is written as 1800.


#import <Foundation/Foundation.h>

@interface Hours : NSObject

//This init method used when have opening and closing hours as separate strings
-(id) initWithOpeningDigits:(NSString *)openingDigits andClosingDigits:(NSString *)closingDigits;

//The idea behind this is to have pulled text from the database to convert into an hours object
-(id) initWithOneString:(NSString *)fourDigitsDashFourDigits;

//This method used to convert hours to string object to either display or place into a database.
-(NSString *) hoursToString:(Hours *) hoursObject;

@end
