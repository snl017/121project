//
//  Place.m
//  iNeed
//
//  Created by Anna Turner on 2/17/14.
//  Copyright (c) 2014 Anna Turner. All rights reserved.
//

#import "Place.h"

@implementation Place

//Init method. Creation of a new Place object with all parameters.
-(id)initWithSchool:(NSString *)school andName:(NSString *)name andBroadCategory:(NSString *)broadCategory andSpecificCategory:(NSString *)specificCategory andLocation:(NSString *)location andMondayHours:(NSString *)monday andTuesdayHours:(NSString *)tuesday andWednesdayHours:(NSString *)wednesday andThursdayHours:(NSString *)thursday andFridayHours:(NSString *)friday andSaturdayHours:(NSString *)saturday andSundayHours:(NSString *)sunday andAllHours:(NSString *)allhours andPhoneString:(NSString *)phone andEmailString:(NSString *)email andLinkString:(NSString *)webLink{
    
    self.school = school;
    self.name = name;
    self.specificCategory = specificCategory;
    self.broadCategory = broadCategory;
    self.location = location;
    self.mondayHours = monday;
    self.tuesdayHours = tuesday;
    self.wednesdayHours = wednesday;
    self.thursdayHours = thursday;
    self.fridayHours = friday;
    self.saturdayHours = saturday;
    self.sundayHours = sunday;
    self.allHours = allhours;
    self.phone = phone;
    self.email = email;
    self.webLink = webLink;
    
    return self;
    
}

-(void)printPlace{
    NSString *printStrOne = [NSString stringWithFormat: @"%@ %@ %@ %@ %@ %@ %@ %@", @"School: ", self.school, @" Name: ", self.name, @" Specific Category: ", self.specificCategory, @" Broad Category: ", self.broadCategory];
    NSString *printStrTwo = [NSString stringWithFormat: @"%@ %@ %@ %@ %@ %@ %@ %@", @" Location: ", self.location, @" Monday Hours: ", self.mondayHours, @" Tuesday: ", self.tuesdayHours, @" Wednesday: ", self.wednesdayHours];
    NSString *printStrThr = [NSString stringWithFormat: @"%@ %@ %@ %@ %@ %@ %@ %@", @" Thursday: ", self.thursdayHours, @" Friday: ", self.fridayHours, @" Saturday: ", self.saturdayHours, @" Sunday: ", self.sundayHours];
    NSString *printStrFou = [NSString stringWithFormat: @"%@ %@ %@ %@ %@ %@ %@ %@", @" All Hours: ", self.allHours, @" Phone: ", self.phone, @" Email: ", self.email, @" Link: ", self.webLink];
    
    NSString *printString = [NSString stringWithFormat:@"%@ %@ %@ %@", printStrOne, printStrTwo, printStrThr, printStrFou];
    
    NSLog(@"%@", @" PLACE: ");
    NSLog(@"%@", printString);
    



}

@end
