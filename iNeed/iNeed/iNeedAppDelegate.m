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
    //Create database. Call tester function to make sure they work.
    [PlaceDatabase createEditableCopyOfDatabaseIfNeeded];
    [PlaceDatabase initDatabase];
    [self testDatabase];
    //[self testPlaceClass];
    //[self testHoursClass];
    
    return YES;
}

//Test out Hours class
-(void)testHoursClass{
//    //Some hours to test out
//    Hours *normalHours = [[Hours alloc] initWithOpeningDigits:@"0961" andClosingDigits:@"1700"];
//    NSString *dispString = [normalHours hoursToDisplayString];
//    NSString *dataString = [normalHours hoursToDatabaseString];
//    
//    NSLog(@"%@", dispString);
//    NSLog(@"%@", dataString);


    //5. These hours are initiated with a digits-dash-digits string presumably pulled from database
    //NOTE: may need to do checks on database inited hours to make sure valid, just as the checks are done for the regular init
//    Hours *dbHours = [[Hours alloc] initWithOneString:@"1300-1900"];
//    NSString *dispDbHours = [dbHours hoursToDatabaseString];
//    NSString *dataDbHours = [dbHours hoursToDisplayString];
//    
//    NSLog(@"%@", dispDbHours);
//    NSLog(@"%@", dataDbHours);
    
}


//Test out database functions
- (void)testDatabase{
    //Create some test Hours
    Hours *h1 = [[Hours alloc] initWithOpeningDigits:@"0100" andClosingDigits:@"0200"];
    Hours *h2 = [[Hours alloc] initWithOpeningDigits:@"0200" andClosingDigits:@"0300"];
    Hours *h3 = [[Hours alloc] initWithOpeningDigits:@"0300" andClosingDigits:@"0400"];
    Hours *h4 = [[Hours alloc] initWithOpeningDigits:@"0400" andClosingDigits:@"0500"];
    Hours *h5 = [[Hours alloc] initWithOpeningDigits:@"0500" andClosingDigits:@"0600"];
    Hours *h6 = [[Hours alloc] initWithOpeningDigits:@"0600" andClosingDigits:@"0700"];
    Hours *h7 = [[Hours alloc] initWithOpeningDigits:@"0700" andClosingDigits:@"0800"];
    
    
    //First create some test Places
    Place *fraryDining = [[Place alloc] initWithSchool:PomonaSchool andName:@"Frary Dining Hall" andBroadCategory:FoodBroad andSpecificCategory:DiningHallNarrow andLocation:@"Pomona College" andMondayHours:h3 andTuesdayHours:h3 andWednesdayHours:h3 andThursdayHours:h3 andFridayHours:h3 andSaturdayHours:h3 andSundayHours:h4 andAllHours:@"All hours forever" andPhoneString:@"123-456-7890" andEmailString:@"frarysomething@pomona.edu" andLinkString:None];
    
    Place *frankDining = [[Place alloc] initWithSchool:PomonaSchool andName:@"Frank Dining Hall" andBroadCategory:FoodBroad andSpecificCategory:DiningHallNarrow andLocation:@"Pomona College" andMondayHours:h1 andTuesdayHours:h2 andWednesdayHours:h3 andThursdayHours:h4 andFridayHours:h5 andSaturdayHours:h6 andSundayHours:h7 andAllHours:@"Mon allday \nTues \nWed \nThurs \nFri \nSat \nSun" andPhoneString:@"frank-456-7890" andEmailString:@"franksomething@pomona.edu" andLinkString:@"www.google.com"];
    
    Hours *coopWeek = [[Hours alloc] initWithOpeningDigits:@"0900" andClosingDigits:@"2300"];
    Hours *coopFri = [[Hours alloc] initWithOpeningDigits:@"0900" andClosingDigits:@"0030"];
    Hours *coopSat = [[Hours alloc] initWithOpeningDigits:@"1100" andClosingDigits:@"0030"];
    Hours *coopSun = [[Hours alloc] initWithOpeningDigits:@"1100" andClosingDigits:@"2300"];
    
    //grill opens at 10 Mon-Fri, 1 pm on sat&sun
    Place *coopFountain = [[Place alloc] initWithSchool:PomonaSchool andName:@"Coop Fountain" andBroadCategory:FoodBroad andSpecificCategory:EateryGroceryNarrow andLocation:@"Smith Campus Center, Pomona College\n170 E 6th St" andMondayHours:coopWeek andTuesdayHours:coopWeek andWednesdayHours:coopWeek andThursdayHours:coopWeek andFridayHours:coopFri andSaturdayHours:coopSat andSundayHours:coopSun andAllHours:@"jokes" andPhoneString:@"909-607-3293" andEmailString:@"no email" andLinkString:@"http://aspc.pomona.edu/eatshop/coop-fountain/"];
    
    Hours *coopStWeek =[[Hours alloc] initWithOpeningDigits:@"0900" andClosingDigits:@"2359"];
    Hours *coopStSat =[[Hours alloc] initWithOpeningDigits:@"1200" andClosingDigits:@"2359"];
    Hours *coopStSun =[[Hours alloc] initWithOpeningDigits:@"1200" andClosingDigits:@"2100"];
    
    Place *coopStore = [[Place alloc] initWithSchool:PomonaSchool andName:@"Coop Store" andBroadCategory:FoodBroad andSpecificCategory:EateryGroceryNarrow andLocation:@"Smith Campus Center, Pomona College\n170 E 6th St" andMondayHours:coopStWeek andTuesdayHours:coopStWeek andWednesdayHours:coopStWeek andThursdayHours:coopStWeek andFridayHours:coopStWeek andSaturdayHours:coopStSat andSundayHours:coopStSun andAllHours:@"jokes" andPhoneString:@"909-607-2264" andEmailString:@"coopstore@aspc.pomona.edu" andLinkString:@"http://coopstore.pomona.edu"];
    
    
    Hours *allDay =[[Hours alloc] initWithOpeningDigits:@"0000" andClosingDigits:@"2359"];
    
    Place *campusSafety = [[Place alloc] initWithSchool:CUCSchool andName:@"Campus Safety" andBroadCategory:SafetyHealth andSpecificCategory:SafetyHealth andLocation:@"Pendleton Business Building\n150 E 8th St\nClaremont, CA 91711" andMondayHours:allDay andTuesdayHours:allDay andWednesdayHours:allDay andThursdayHours:allDay andFridayHours:allDay andSaturdayHours:allDay andSundayHours:allDay andAllHours:@"Campus Safety Never Sleeps" andPhoneString:@"1-909-607-2000" andEmailString:@"dispatch@cuc.claremont.edu" andLinkString:@"http://www.cuc.claremont.edu/campussafety/"];
    
    Place *writingCenter = [[Place alloc] initWithSchool:PomonaSchool andName:@"Writing Center" andBroadCategory:ResourceCentersOfficesBroad andSpecificCategory:AcademicRCNarrow andLocation:@"148 Smith Campus Center" andMondayHours:h1 andTuesdayHours:h2 andWednesdayHours:h3 andThursdayHours:h4 andFridayHours:h5 andSaturdayHours:h6 andSundayHours:h7 andAllHours:@"All hours forever3" andPhoneString:@"(909) 607-4599" andEmailString:@"Writing.Center@pomona.edu" andLinkString:@"http://www.pomona.edu/academics/resources/writing-center/"];
    
    Hours *workDay = [[Hours alloc] initWithOpeningDigits:@"0800" andClosingDigits:@"1700"];
    //closed on weekend...
    Hours *closed = [[Hours alloc] initWithOpeningDigits:@"0000" andClosingDigits:@"0000"];
    
    //study abroad doesn't have hours...
    Place *studyAbroad = [[Place alloc] initWithSchool:PomonaSchool andName:@"Study Abroad Office" andBroadCategory:ResourceCentersOfficesBroad andSpecificCategory:NonAcademicRCNarrow andLocation:@"Sumner Hall, Pomona College" andMondayHours:workDay andTuesdayHours:workDay andWednesdayHours:workDay andThursdayHours:workDay andFridayHours:workDay andSaturdayHours:closed andSundayHours:closed andAllHours:@"All hours forever3" andPhoneString:@"(909) 621-8154" andEmailString:@"sabroad@pomona.edu" andLinkString:@"http://www.pomona.edu/administration/study-abroad/"];
    
    
    //Empty the database if necessary
    [PlaceDatabase emptyDatabase];
    
    //Save some test places to database
    [PlaceDatabase saveItemWithPlace:fraryDining];
    [PlaceDatabase saveItemWithPlace:frankDining];
    [PlaceDatabase saveItemWithPlace:campusSafety];
    [PlaceDatabase saveItemWithPlace:studyAbroad];
    [PlaceDatabase saveItemWithPlace:coopFountain];
    [PlaceDatabase saveItemWithPlace:coopStore];
    [PlaceDatabase saveItemWithPlace:writingCenter];
    
    
    
    //TESTS
    //Test: for categories table methods:
    
    //Save a piece of information to the categories table
//  [PlaceDatabase savePlace:@"Frary" withSpecificCategory:DiningHallNarrow andBroadCategory:FoodBroad];
//    
//    NSMutableArray *testSelectBySpecific = [PlaceDatabase fetchPlacesBySpecificCategory:DiningHallNarrow];
//    NSLog(@"Fetched Specific!");
//    NSLog(@"%d",[testSelectBySpecific count]);
//    for (id object in testSelectBySpecific) { //print all fetched items
//        Place *tempPlace = (Place *)object;
//        [tempPlace printPlace];
//    }
    
//    //Update something
//    [PlaceDatabase updateMondayHoursByName:fraryDining.name andNewHours: [[Hours alloc] initWithOpeningDigits:@"0000" andClosingDigits:@"1000"]];
    
//    //Refetch and print
//    testSelectBySpecific = [PlaceDatabase fetchPlacesBySpecificCategory:DiningHallNarrow];
//    NSLog(@"Fetched Specific!");
//    NSLog(@"%d",[testSelectBySpecific count]);
//    for (id object in testSelectBySpecific) { //print all fetched items
//        Place *tempPlace = (Place *)object;
//        [tempPlace printPlace];
//    }
    
//    NSMutableArray *testSelectByBroad = [PlaceDatabase fetchPlacesByBroadCategory:FoodBroad];
//    NSLog(@"Fetched Broad");
//    NSLog(@"%d",[testSelectByBroad count]);
//    for (id object in testSelectByBroad) { //print all fetched items
//        Place *tempPlace = (Place *)object;
//        [tempPlace printPlace];
//    }
//
    

    
    //Test: fetch all items
//    NSMutableArray *testFetchAll = [PlaceDatabase fetchAllPlaces];
//    
//    for (id object in testFetchAll) { //print all fetched items
//        Place *tempPlace = (Place *)object;
//        [tempPlace printPlace];
//    }
    
    //Test: fetch by broad category
//    NSMutableArray *testSelectBroad = [PlaceDatabase fetchPlacesByBroadCategory:@"Food"];
//    
//    for (id object in testSelectBroad) { //print all fetched items
//        Place *tempPlace = (Place *)object;
//        [tempPlace printPlace];
//    }
    
//    //Test: fetch by specific category
//    NSMutableArray *testSelectSpecific = [PlaceDatabase fetchPlacesBySpecificCategory:DiningHallNarrow];
//    
//    for (id object in testSelectSpecific) { //print all fetched items
//        Place *tempPlace = (Place *)object;
//        [tempPlace printPlace];
//    }
//    NSLog(@"%i",[testSelectSpecific count]);
    
    //Test: fetch by name
   // NSMutableArray *testSelectName = [PlaceDatabase fetchPlacesByName:@"Frary Dining Hall"];
    
//    for (id object in testSelectName) { //print all fetched items
//        Place *tempPlace = (Place *)object;
//        [tempPlace printPlace];
//    }

}

- (void)testPlaceClass{
    NSMutableArray *diningArray = [PlaceDatabase fetchPlacesBySpecificCategory:DiningHallNarrow];
    Place *frary = [diningArray objectAtIndex:0];
    NSMutableArray *allHoursArray = [frary getAllHours];
    for (id object in allHoursArray){
        NSLog(@"%@", object);
    }
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
