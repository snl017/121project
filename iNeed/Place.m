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
-(id)initWithSchool:(NSString *)school andName:(NSString *)name andBroadCategory:(NSString *)broadCategory andSpecificCategory:(NSString *)specificCategory andLocation:(NSString *)location andMondayHours:(Hours *)monday andTuesdayHours:(Hours *)tuesday andWednesdayHours:(Hours *)wednesday andThursdayHours:(Hours *)thursday andFridayHours:(Hours *)friday andSaturdayHours:(Hours *)saturday andSundayHours:(Hours *)sunday andAllHours:(NSString *)allhours andPhoneString:(NSString *)phone andEmailString:(NSString *)email andLinkString:(NSString *)webLink{
    
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
    NSString *monString = [self.mondayHours hoursToDisplayString];
    NSString *tueString = [self.tuesdayHours hoursToDisplayString];
    NSString *wedString = [self.wednesdayHours hoursToDisplayString];
    NSString *thuString = [self.thursdayHours hoursToDisplayString];
    NSString *friString = [self.fridayHours hoursToDisplayString];
    NSString *satString = [self.saturdayHours hoursToDisplayString];
    NSString *sunString = [self.sundayHours hoursToDisplayString];
    
    
    NSString *printStrOne = [NSString stringWithFormat: @"%@ %@ %@ %@ %@ %@ %@ %@", @"School: ", self.school, @" Name: ", self.name, @" Specific Category: ", self.specificCategory, @" Broad Category: ", self.broadCategory];
    NSString *printStrTwo = [NSString stringWithFormat: @"%@ %@ %@ %@ %@ %@ %@ %@", @" Location: ", self.location, @" Monday Hours: ", monString, @" Tuesday: ", tueString, @" Wednesday: ", wedString];
    NSString *printStrThr = [NSString stringWithFormat: @"%@ %@ %@ %@ %@ %@ %@ %@", @" Thursday: ", thuString, @" Friday: ", friString, @" Saturday: ", satString, @" Sunday: ", sunString];
    NSString *printStrFou = [NSString stringWithFormat: @"%@ %@ %@ %@ %@ %@ %@ %@", @" All Hours: ", self.allHours, @" Phone: ", self.phone, @" Email: ", self.email, @" Link: ", self.webLink];
    
    NSString *printString = [NSString stringWithFormat:@"%@ %@ %@ %@", printStrOne, printStrTwo, printStrThr, printStrFou];
    
    NSLog(@"%@", @" PLACE: ");
    NSLog(@"%@", printString);
    



}

@end
