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
-(id)initWithSchool:(NSString *)school andName:(NSString *)name andLocation:(NSString *)location andMondayHours:(Hours *)monday andTuesdayHours:(Hours *)tuesday andWednesdayHours:(Hours *)wednesday andThursdayHours:(Hours *)thursday andFridayHours:(Hours *)friday andSaturdayHours:(Hours *)saturday andSundayHours:(Hours *)sunday andPhoneString:(NSString *)phone andEmailString:(NSString *)email andLinkString:(NSString *)webLink andExtraInfo:(NSString *)extraInfo{
    
    self.school = school;
    self.name = name;
    self.location = location;
    self.mondayHours = monday;
    self.tuesdayHours = tuesday;
    self.wednesdayHours = wednesday;
    self.thursdayHours = thursday;
    self.fridayHours = friday;
    self.saturdayHours = saturday;
    self.sundayHours = sunday;
    self.phone = phone;
    self.email = email;
    self.webLink = webLink;
    self.extraInfo = extraInfo;
    
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
    NSString *monObj = [NSString stringWithFormat:@"%@%@", @"Mon ", monString];
    [allHoursArray addObject:monObj];
    
    //Check tuesday.
        //Get all of monday string that occurs after the "Mon" day identifier. This will consist of either "Closed" or hyphenated hours
    //this finds the first space and substrings up to that point
    NSString *prevHours = [[allHoursArray lastObject] substringFromIndex:[[allHoursArray lastObject] rangeOfString:@" "].location+1];
        //Compare to tuesday string
    if ([tuesString isEqualToString: prevHours]) {
        //modify last object
        NSString *lastObj = [allHoursArray lastObject];
        [allHoursArray removeLastObject];
        
        //FUN NOTE: this is the code if you want to substring up to the first space: [lastObj substringToIndex:[lastObj rangeOfString:@" "].location] but for now we're just doing 3 letters for everything
        NSString *newLastObj = [NSString stringWithFormat:@"%@%@%@", [lastObj substringToIndex:3], @"-Tue ", prevHours];
        [allHoursArray addObject:newLastObj];
    } else {
        NSString *tuesObj = [NSString stringWithFormat:@"%@%@", @"Tue ", tuesString];
        [allHoursArray addObject:tuesObj];
    }
    
    //Check Wednesday
    //Get all of last string that occurs after the day identifier. This will consist of either "Closed" or hyphenated hours
    prevHours = [[allHoursArray lastObject] substringFromIndex:[[allHoursArray lastObject] rangeOfString:@" "].location+1];
    //Compare Wednesday hours last object in array
    if ([wedString isEqualToString: prevHours]) {
        //modify last object
        NSString *lastObj = [allHoursArray lastObject];
        [allHoursArray removeLastObject];
        NSString *newLastObj = [NSString stringWithFormat:@"%@%@%@", [lastObj substringToIndex:3], @"-Wed ", prevHours];
        [allHoursArray addObject:newLastObj];
    } else {
        NSString *wedObj = [NSString stringWithFormat:@"%@%@", @"Wed ", wedString];
        [allHoursArray addObject:wedObj];
    }
    
    //Check Thursday
    //Get all of last string that occurs after the day identifier. This will consist of either "Closed" or hyphenated hours
    prevHours = [[allHoursArray lastObject] substringFromIndex:[[allHoursArray lastObject] rangeOfString:@" "].location+1];
    //Compare Thursday hours last object in array
    if ([thurString isEqualToString: prevHours]) {
        //modify last object
        NSString *lastObj = [allHoursArray lastObject];
        [allHoursArray removeLastObject];
        
        NSString *newLastObj = [NSString stringWithFormat:@"%@%@%@", [lastObj substringToIndex:3], @"-Thu ", prevHours];
        [allHoursArray addObject:newLastObj];
    } else {
        NSString *thursObj = [NSString stringWithFormat:@"%@%@", @"Thu ", thurString];
        [allHoursArray addObject:thursObj];
    }
    
    //Check Friday
    //Get all of last string that occurs after the day identifier. This will consist of either "Closed" or hyphenated hours
    prevHours = [[allHoursArray lastObject] substringFromIndex:[[allHoursArray lastObject] rangeOfString:@" "].location+1];
    //Compare Thursday hours last object in array
    if ([friString isEqualToString: prevHours]) {
        //modify last object
        NSString *lastObj = [allHoursArray lastObject];
        [allHoursArray removeLastObject];
        
        NSString *newLastObj = [NSString stringWithFormat:@"%@%@%@", [lastObj substringToIndex:3], @"-Fri ", prevHours];
        [allHoursArray addObject:newLastObj];
    } else {
        NSString *friObj = [NSString stringWithFormat:@"%@%@", @"Fri ", friString];
        [allHoursArray addObject:friObj];
    }
    
    //Check Saturday
    //Get all of last string that occurs after the day identifier. This will consist of either "Closed" or hyphenated hours
    prevHours = [[allHoursArray lastObject] substringFromIndex:[[allHoursArray lastObject] rangeOfString:@" "].location+1];
    //Compare Thursday hours last object in array
    if ([satString isEqualToString: prevHours]) {
        //modify last object
        NSString *lastObj = [allHoursArray lastObject];
        [allHoursArray removeLastObject];
        
        NSString *newLastObj = [NSString stringWithFormat:@"%@%@%@", [lastObj substringToIndex:3], @"-Sat ", prevHours];
        [allHoursArray addObject:newLastObj];
    } else {
        NSString *satObj = [NSString stringWithFormat:@"%@%@", @"Sat ", satString];
        [allHoursArray addObject:satObj];
    }

    //Check Sunday
    //Get all of last string that occurs after the day identifier. This will consist of either "Closed" or hyphenated hours
    prevHours = [[allHoursArray lastObject] substringFromIndex:[[allHoursArray lastObject] rangeOfString:@" "].location+1];
    //Compare Thursday hours last object in array
    if ([sunString isEqualToString: prevHours]) {
        //modify last object
        NSString *lastObj = [allHoursArray lastObject];
        [allHoursArray removeLastObject];
        
        NSString *newLastObj = [NSString stringWithFormat:@"%@%@%@", [lastObj substringToIndex:3], @"-Sun ", prevHours];
        [allHoursArray addObject:newLastObj];
    } else {
        NSString *sunObj = [NSString stringWithFormat:@"%@%@", @"Sun ", sunString];
        [allHoursArray addObject:sunObj];
    }
    
    return allHoursArray;
}

/**
 * Gives the hours for the entire week as a string, where each set of hours is on a different line
 */
-(NSString*) getAllHoursAsString{
    NSString *hoursString = @"";
    NSMutableArray *hoursArray = self.getAllHours;
    for (id object in hoursArray){
        NSString *hour = (NSString*) object;
        hoursString =[hoursString stringByAppendingString:hour];
        hoursString = [hoursString stringByAppendingString:@"\n"];
    }
    return hoursString;
}

-(void)printPlace{
    NSString *monString = [self.mondayHours hoursToDisplayString];
    NSString *tueString = [self.tuesdayHours hoursToDisplayString];
    NSString *wedString = [self.wednesdayHours hoursToDisplayString];
    NSString *thuString = [self.thursdayHours hoursToDisplayString];
    NSString *friString = [self.fridayHours hoursToDisplayString];
    NSString *satString = [self.saturdayHours hoursToDisplayString];
    NSString *sunString = [self.sundayHours hoursToDisplayString];
    
    
    NSString *printStrOne = [NSString stringWithFormat: @"%@ %@ %@ %@", @"School: ", self.school, @" Name: ", self.name];
    NSString *printStrTwo = [NSString stringWithFormat: @"%@ %@ %@ %@ %@ %@ %@ %@", @" Location: ", self.location, @" Monday Hours: ", monString, @" Tuesday: ", tueString, @" Wednesday: ", wedString];
    NSString *printStrThr = [NSString stringWithFormat: @"%@ %@ %@ %@ %@ %@ %@ %@", @" Thursday: ", thuString, @" Friday: ", friString, @" Saturday: ", satString, @" Sunday: ", sunString];
    NSString *printStrFou = [NSString stringWithFormat: @"%@ %@ %@ %@ %@ %@", @" Phone: ", self.phone, @" Email: ", self.email, @" Link: ", self.webLink];
    
    NSString *printString = [NSString stringWithFormat:@"%@ %@ %@ %@", printStrOne, printStrTwo, printStrThr, printStrFou];
    
    NSLog(@"%@", @" PLACE: ");
    NSLog(@"%@", printString);
    

}

@end
