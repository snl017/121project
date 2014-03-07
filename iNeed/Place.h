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
@property NSString *location;
@property Hours *mondayHours;
@property Hours *tuesdayHours;
@property Hours *wednesdayHours;
@property Hours *thursdayHours;
@property Hours *fridayHours;
@property Hours *saturdayHours;
@property Hours *sundayHours;
@property NSString *phone;
@property NSString *email;
@property NSString *webLink;
@property NSString *extraInfo;




//Methods
-(id)initWithSchool:(NSString *)school andName:(NSString *)name andLocation:(NSString *)location andMondayHours:(Hours *)monday andTuesdayHours:(Hours *)tuesday andWednesdayHours:(Hours *)wednesday andThursdayHours:(Hours *)thursday andFridayHours:(Hours *)friday andSaturdayHours:(Hours *)saturday andSundayHours:(Hours *)sunday andPhoneString:(NSString *)phone andEmailString:(NSString *)email andLinkString:(NSString *)link andExtraInfo:(NSString *)extraInfo;

-(void)printPlace; //This just prints out a nice formatted version of place

-(NSMutableArray *)getAllHours;//This consolidates same hours and returns

-(NSString *)getAllHoursAsString;



@end
