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
#import "Hours.h"

@interface Place : NSObject

//Variables

//Anything in the database: School - name - specific category - location - monday - tuesday - wednesday - thursday - friday - saturday - sunday - allhours - phone - email - link//
@property NSString *school;
@property NSString *name;
@property NSString *specificCategory;
@property NSString *location;
@property Hours *mondayHours;
@property Hours *tuesdayHours;
@property Hours *wednesdayHours;
@property Hours *thursdayHours;
@property Hours *fridayHours;
@property Hours *saturdayHours;
@property Hours *sundayHours;
@property NSString *allHours;
@property NSString *phone;
@property NSString *email;
@property NSString *webLink;

//Broad category in the database. Do we want this?
@property NSString *broadCategory;




//Methods
-(id)initWithSchool:(NSString *)school andName:(NSString *)name andBroadCategory:(NSString *)broadCategory andSpecificCategory:(NSString *)specificCategory andLocation:(NSString *)location andMondayHours:(Hours *)monday andTuesdayHours:(Hours *)tuesday andWednesdayHours:(Hours *)wednesday andThursdayHours:(Hours *)thursday andFridayHours:(Hours *)friday andSaturdayHours:(Hours *)saturday andSundayHours:(Hours *)sunday andAllHours:(NSString *)allhours andPhoneString:(NSString *)phone andEmailString:(NSString *)email andLinkString:(NSString *)link;

-(void)printPlace; //This just prints out a nice formatted version of place

-(NSMutableArray *)getAllHours;//This consolidates same hours and returns

-(NSString *)getAllHoursAsString;



@end
