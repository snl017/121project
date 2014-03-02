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

//This consolidates same hours and returns
-(NSMutableArray *)getAllHours{
    NSMutableArray *allHoursArray = [[NSMutableArray alloc] init];
    
    //convert Hours to strings
    NSString *monString = [self.mondayHours hoursToDisplayString];
    NSString *tuesString = [self.tuesdayHours hoursToDisplayString];
    NSString *wedString = [self.wednesdayHours hoursToDisplayString];
    NSString *thurString = [self.thursdayHours hoursToDisplayString];
    NSString *friString = [self.fridayHours hoursToDisplayString];
    NSString *satString = [self.saturdayHours hoursToDisplayString];
    NSString *sunString = [self.sundayHours hoursToDisplayString];
    
    //Convert monday string into array object. Insert into array.
    NSString *monObj = [NSString stringWithFormat:@"%@%@", @"Mo ", monString];
    [allHoursArray addObject:monObj];
    
    //Check tuesday.
        //Get last 11 digits of monday string
    NSString *prevHours = [[allHoursArray lastObject] substringFromIndex:[[allHoursArray lastObject] length] - 11];
        //Compare to tuesday string
    if ([tuesString isEqualToString: prevHours]) {
        //modify last object
        NSString *lastObj = [allHoursArray lastObject];
        [allHoursArray removeLastObject];
        NSString *newLastObj = [NSString stringWithFormat:@"%@%@%@", [lastObj substringToIndex:2], @"-Tu ", prevHours];
        [allHoursArray addObject:newLastObj];
    } else {
        NSString *tuesObj = [NSString stringWithFormat:@"%@%@", @"Tu ", tuesString];
        [allHoursArray addObject:tuesObj];
    }
    
    //Check Wednesday
        //Get last 11 digits of last string
    prevHours = [[allHoursArray lastObject] substringFromIndex:[[allHoursArray lastObject] length] - 11];
        //Compare Wednesday hours last object in array
    if ([wedString isEqualToString: prevHours]) {
        //modify last object
        NSString *lastObj = [allHoursArray lastObject];
        [allHoursArray removeLastObject];
        NSString *newLastObj = [NSString stringWithFormat:@"%@%@%@", [lastObj substringToIndex:2], @"-We ", prevHours];
        [allHoursArray addObject:newLastObj];
    } else {
        NSString *wedObj = [NSString stringWithFormat:@"%@%@", @"We ", wedString];
        [allHoursArray addObject:wedObj];
    }
    
    //Check Thursday
    //Get last 11 digits of last string
    prevHours = [[allHoursArray lastObject] substringFromIndex:[[allHoursArray lastObject] length] - 11];
    //Compare Thursday hours last object in array
    if ([thurString isEqualToString: prevHours]) {
        //modify last object
        NSString *lastObj = [allHoursArray lastObject];
        [allHoursArray removeLastObject];
        
        NSString *newLastObj = [NSString stringWithFormat:@"%@%@%@", [lastObj substringToIndex:2], @"-Th ", prevHours];
        [allHoursArray addObject:newLastObj];
    } else {
        NSString *thursObj = [NSString stringWithFormat:@"%@%@", @"Th ", thurString];
        [allHoursArray addObject:thursObj];
    }
    
    //Check Friday
    //Get last 11 digits of last string
    prevHours = [[allHoursArray lastObject] substringFromIndex:[[allHoursArray lastObject] length] - 11];
    //Compare Thursday hours last object in array
    if ([friString isEqualToString: prevHours]) {
        //modify last object
        NSString *lastObj = [allHoursArray lastObject];
        [allHoursArray removeLastObject];
        
        NSString *newLastObj = [NSString stringWithFormat:@"%@%@%@", [lastObj substringToIndex:2], @"-Fr ", prevHours];
        [allHoursArray addObject:newLastObj];
    } else {
        NSString *friObj = [NSString stringWithFormat:@"%@%@", @"Fr ", friString];
        [allHoursArray addObject:friObj];
    }
    
    //Check Saturday
    //Get last 11 digits of last string
    prevHours = [[allHoursArray lastObject] substringFromIndex:[[allHoursArray lastObject] length] - 11];
    //Compare Thursday hours last object in array
    if ([satString isEqualToString: prevHours]) {
        //modify last object
        NSString *lastObj = [allHoursArray lastObject];
        [allHoursArray removeLastObject];
        
        NSString *newLastObj = [NSString stringWithFormat:@"%@%@%@", [lastObj substringToIndex:2], @"-Sa ", prevHours];
        [allHoursArray addObject:newLastObj];
    } else {
        NSString *satObj = [NSString stringWithFormat:@"%@%@", @"Sa ", satString];
        [allHoursArray addObject:satObj];
    }

    //Check Sunday
    //Get last 11 digits of last string
    prevHours = [[allHoursArray lastObject] substringFromIndex:[[allHoursArray lastObject] length] - 11];
    //Compare Thursday hours last object in array
    if ([sunString isEqualToString: prevHours]) {
        //modify last object
        NSString *lastObj = [allHoursArray lastObject];
        [allHoursArray removeLastObject];
        
        NSString *newLastObj = [NSString stringWithFormat:@"%@%@%@", [lastObj substringToIndex:2], @"-Su ", prevHours];
        [allHoursArray addObject:newLastObj];
    } else {
        NSString *sunObj = [NSString stringWithFormat:@"%@%@", @"Su ", sunString];
        [allHoursArray addObject:sunObj];
    }
    
    return allHoursArray;
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
