//
//  Place.h
//  iNeed
//
//  Created by Anna Turner on 2/17/14.
//  Copyright (c) 2014 Anna Turner. All rights reserved.
//
// This class is the place object. It holds all necessary information about the object, as listed by the variables below.
// Variable types are open to change.

#import <Foundation/Foundation.h>

@interface Place : NSObject

//Variables

//Anything in the database: School - name - specific category - location - monday - tuesday - wednesday - thursday - friday - saturday - sunday - allhours - phone - email - link//
@property NSString *school;
@property NSString *name;
@property NSString *specificCategory;
@property NSString *location;
@property NSString *mondayHours;
@property NSString *tuesdayHours;
@property NSString *wednesdayHours;
@property NSString *thursdayHours;
@property NSString *fridayHours;
@property NSString *saturdayHours;
@property NSString *sundayHours;
@property NSString *allHours;
@property NSString *phone;
@property NSString *email;
@property NSString *webLink;
//Broad category in the database. Do we want this?
@property NSString *broadCategory;




//Methods
-(id)initWithSchool:(NSString *)school andName:(NSString *)name andBroadCategory:(NSString *)broadCategory andSpecificCategory:(NSString *)specificCategory andLocation:(NSString *)location andMondayHours:(NSString *)monday andTuesdayHours:(NSString *)tuesday andWednesdayHours:(NSString *)wednesday andThursdayHours:(NSString *)thursday andFridayHours:(NSString *)friday andSaturdayHours:(NSString *)saturday andSundayHours:(NSString *)sunday andAllHours:(NSString *)allhours andPhoneString:(NSString *)phone andEmailString:(NSString *)email andLinkString:(NSString *)link;



@end
