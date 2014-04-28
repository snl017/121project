//
//  iNeedAppDelegate.m
//  iNeed
//
//  Created by jarthurcs on 2/18/14.
//  Copyright (c) 2014 121. All rights reserved.
//

#import "iNeedAppDelegate.h"

@implementation iNeedAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //To test prettyness of launch screen uncomment below
    //sleep(5);
    
    //(written by) SHANNON - idk if we even need any of the things below here or the testDatabase function
    //we should figure this out at some point....
    
    
    //Create database. Call tester function to make sure they work.
    [PlaceDatabase createEditableCopyOfDatabaseIfNeeded];
    [PlaceDatabase initDatabase];
    [self testDatabase];
    

    
    
    
    return YES;
}

//Test out database functions
- (void)testDatabase{
    //Create some test Hours
    Hours *h1 = [[Hours alloc] initWithOneString:@"0100-0200"];
    Hours *h2 = [[Hours alloc] initWithOneString:@"0200-0300"];
    Hours *h3 = [[Hours alloc] initWithOneString:@"0300-0400"];
    Hours *h4 = [[Hours alloc] initWithOneString:@"0400-0500"];
    Hours *h5 = [[Hours alloc] initWithOneString:@"0500-0600"];
    Hours *h6 = [[Hours alloc] initWithOneString:@"0600-0700"];
    Hours *h7 = [[Hours alloc] initWithOneString:@"0700-0800"];
        
    //First create some test Places
    
    //Testing frary with multiple hours
    Hours *fraryMulti = [[Hours alloc] initWithOneString:@"0730-1000%1100-1400%1700-2000"];
    Place *fraryDining = [[Place alloc] initWithSchool:PomonaSchool andName:@"Frary Dining Hall" andLocation:@"Pomona College" andMondayHours:fraryMulti andTuesdayHours:fraryMulti andWednesdayHours:h3 andThursdayHours:h3 andFridayHours:h3 andSaturdayHours:h3 andSundayHours:h4 andPhoneString:@"123-456-7890" andEmailString:@"frarysomething@pomona.edu" andLinkString:None andExtraInfo:@"Snack M-Th"];
    
    Place *frankDining = [[Place alloc] initWithSchool:PomonaSchool andName:@"Frank Dining Hall" andLocation:@"Pomona College" andMondayHours:h1 andTuesdayHours:h2 andWednesdayHours:h3 andThursdayHours:h4 andFridayHours:h5 andSaturdayHours:h6 andSundayHours:h7 andPhoneString:@"frank-456-7890" andEmailString:@"franksomething@pomona.edu" andLinkString:@"www.google.com" andExtraInfo:None];
    
    Hours *coopWeek = [[Hours alloc] initWithOneString:@"0900-2300"];
    Hours *coopFri = [[Hours alloc] initWithOneString:@"0900-0030"];
    Hours *coopSat = [[Hours alloc] initWithOneString:@"1100-0030"];
    Hours *coopSun = [[Hours alloc] initWithOneString:@"1100-2300"];
    
    //grill opens at 10 Mon-Fri, 1 pm on sat&sun
    Place *coopFountain = [[Place alloc] initWithSchool:PomonaSchool andName:@"Coop Fountain" andLocation:@"Smith Campus Center, Pomona College\n170 E 6th St" andMondayHours:coopWeek andTuesdayHours:coopWeek andWednesdayHours:coopWeek andThursdayHours:coopWeek andFridayHours:coopFri andSaturdayHours:coopSat andSundayHours:coopSun andPhoneString:@"909-607-3293" andEmailString:None andLinkString:@"http://aspc.pomona.edu/eatshop/coop-fountain/" andExtraInfo:None];
    
    Hours *coopStWeek =[[Hours alloc] initWithOneString:@"0900-0000"];
    Hours *coopStSat =[[Hours alloc] initWithOneString:@"1200-0000"];
    Hours *coopStSun =[[Hours alloc] initWithOneString:@"1200-2000"];
    
    Place *coopStore = [[Place alloc] initWithSchool:PomonaSchool andName:@"Coop Store" andLocation:@"Smith Campus Center, Pomona College\n170 E 6th St" andMondayHours:coopStWeek andTuesdayHours:coopStWeek andWednesdayHours:coopStWeek andThursdayHours:coopStWeek andFridayHours:coopStWeek andSaturdayHours:coopStSat andSundayHours:coopStSun andPhoneString:@"909-607-2264" andEmailString:@"coopstore@aspc.pomona.edu" andLinkString:@"http://coopstore.pomona.edu" andExtraInfo:None];
    
    
    Hours *allDay =[[Hours alloc] initWithOneString:@"0000-2359"];
    
    Place *campusSafety = [[Place alloc] initWithSchool:CUCSchool andName:@"Campus Safety" andLocation:@"Pendleton Business Building\n150 E 8th St\nClaremont, CA 91711" andMondayHours:allDay andTuesdayHours:allDay andWednesdayHours:allDay andThursdayHours:allDay andFridayHours:allDay andSaturdayHours:allDay andSundayHours:allDay andPhoneString:@"1-909-607-2000" andEmailString:@"dispatch@cuc.claremont.edu" andLinkString:@"http://www.cuc.claremont.edu/campussafety/" andExtraInfo:None];
    
    Hours *closed = [[Hours alloc] initAsClosedAllDay] ;
    Hours *writingCenterNights = [[Hours alloc] initWithOneString:@"1900-2200"];;
    
    Place *writingCenter = [[Place alloc] initWithSchool:PomonaSchool andName:@"Writing Center" andLocation:@"148 Smith Campus Center" andMondayHours:writingCenterNights andTuesdayHours:writingCenterNights andWednesdayHours:writingCenterNights andThursdayHours:writingCenterNights andFridayHours:closed andSaturdayHours:closed andSundayHours:closed andPhoneString:@"(909) 607-4599" andEmailString:@"Writing.Center@pomona.edu" andLinkString:@"http://www.pomona.edu/academics/resources/writing-center/" andExtraInfo:None];
    
    Hours *workDay = [[Hours alloc] initWithOneString:@"0800-1700"];
    //closed on weekend...
    
    
    //study abroad doesn't have hours...
    Place *studyAbroad = [[Place alloc] initWithSchool:PomonaSchool andName:@"Study Abroad Office" andLocation:@"Sumner Hall, Pomona College" andMondayHours:workDay andTuesdayHours:workDay andWednesdayHours:workDay andThursdayHours:workDay andFridayHours:workDay andSaturdayHours:closed andSundayHours:closed andPhoneString:@"(909) 621-8154" andEmailString:@"sabroad@pomona.edu" andLinkString:@"http://www.pomona.edu/administration/study-abroad/" andExtraInfo:None];
    
    Place *its = [[Place alloc] initWithSchool:PomonaSchool andName:@"ITS" andLocation:@"156 E. 7th St" andMondayHours:workDay andTuesdayHours:workDay andWednesdayHours:workDay andThursdayHours:workDay andFridayHours:workDay andSaturdayHours:closed andSundayHours:closed andPhoneString:@"(909) 621-8061" andEmailString:@"ServiceDesk@pomona.edu" andLinkString:@"its.pomona.edu" andExtraInfo:@"Extended hours staffed by students. Building open 24/7."];
    
    Place *honnoldcafe = [[Place alloc] initWithSchool:PomonaSchool andName:@"Honnold Cafe" andLocation:@"Honnold/Mudd Library, 1st floor" andMondayHours:workDay andTuesdayHours:workDay andWednesdayHours:workDay andThursdayHours:workDay andFridayHours:workDay andSaturdayHours:workDay andSundayHours:workDay andPhoneString:@"(909) 607-1703" andEmailString:@"catering@cuc.claremont.edu" andLinkString:@"http://www.cuc.claremont.edu/cafe/" andExtraInfo:@"Last call for all prepared beverages 60 minutes prior to closing."];
    
    
//    //Empty the database if necessary
    [PlaceDatabase emptyDatabase];
    
//    //Save some test places to database
//    [PlaceDatabase saveItemWithPlace:fraryDining andSpecificCategory:DiningHallNarrow andBroadCategory:FoodBroad];
//    [PlaceDatabase saveItemWithPlace:frankDining andSpecificCategory:DiningHallNarrow andBroadCategory:FoodBroad];
//    [PlaceDatabase saveItemWithPlace:campusSafety andSpecificCategory:SafetyHealth andBroadCategory:SafetyHealth];
//    [PlaceDatabase saveItemWithPlace:studyAbroad andSpecificCategory:NonAcademicRCNarrow andBroadCategory:AcademicRCNarrow];
//    [PlaceDatabase saveItemWithPlace:coopFountain andSpecificCategory:EateryGroceryNarrow andBroadCategory:FoodBroad];
//    [PlaceDatabase savePlace:coopStore.name withSpecificCategory:StoresNarrow andBroadCategory:LivingOnCampusBroad];
//    [PlaceDatabase saveItemWithPlace:coopStore andSpecificCategory:EateryGroceryNarrow andBroadCategory:FoodBroad];
//    [PlaceDatabase saveItemWithPlace:writingCenter andSpecificCategory:AcademicRCNarrow andBroadCategory:ResourceCentersOfficesBroad];
//    [PlaceDatabase saveItemWithPlace:its andSpecificCategory:ServicesNarrow andBroadCategory:LivingOnCampusBroad];
//    [PlaceDatabase saveItemWithPlace:honnoldcafe andSpecificCategory:EateryGroceryNarrow andBroadCategory:FoodBroad];
//    
//    
//    
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}




@end
