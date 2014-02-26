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
    [self testHoursClass];
    
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
    //First create some test Places
    Place *fraryDining = [[Place alloc] initWithSchool:@"Pomona" andName:@"Frary Dining Hall" andBroadCategory:@"Food" andSpecificCategory:@"Dining Halls" andLocation:@"Pomona College" andMondayHours:@"Monday 1-2" andTuesdayHours:@"Tuesday 2-3" andWednesdayHours:@"Wednesday 3-4" andThursdayHours:@"Thursday 4-5" andFridayHours:@"Friday 5-6" andSaturdayHours:@"Saturday 6-7" andSundayHours:@"Sunday 7-8" andAllHours:@"All hours forever" andPhoneString:@"123-456-7890" andEmailString:@"frarysomething@pomona.edu" andLinkString:@"www.google.com"];
    
    Place *frankDining = [[Place alloc] initWithSchool:@"Pomona" andName:@"Frank Dining Hall" andBroadCategory:@"Food" andSpecificCategory:@"Dining Halls" andLocation:@"Pomona College" andMondayHours:@"Monday 1-2" andTuesdayHours:@"Tuesday 2-3" andWednesdayHours:@"Wednesday 3-4" andThursdayHours:@"Thursday 4-5" andFridayHours:@"Friday 5-6" andSaturdayHours:@"Saturday 6-7" andSundayHours:@"Sunday 7-8" andAllHours:@"All hours forever frank" andPhoneString:@"frank-456-7890" andEmailString:@"franksomething@pomona.edu" andLinkString:@"frank.com"];
    
    Place *campusSafety = [[Place alloc] initWithSchool:@"CUC" andName:@"Campus Safety" andBroadCategory:@"Safety & Health" andSpecificCategory:@"Safety & Health" andLocation:@"Tranquada" andMondayHours:@"Monday 11-12" andTuesdayHours:@"Tuesday 12-13" andWednesdayHours:@"Wednesday 13-14" andThursdayHours:@"Thursday 14-15" andFridayHours:@"Friday 15-16" andSaturdayHours:@"Saturday 16-17" andSundayHours:@"Sunday 17-18" andAllHours:@"Campus Safety Never Sleeps" andPhoneString:@"1800-Mix-a-lot" andEmailString:@"HelpHelpHelp@pomona.edu" andLinkString:@"www.nsa.gov"];
    
    Place *studyAbroad = [[Place alloc] initWithSchool:@"Pomona" andName:@"Study Abroad Office" andBroadCategory:@"Academics" andSpecificCategory:@"Academic Resource Centers" andLocation:@"Pomona College" andMondayHours:@"Monday 21-22" andTuesdayHours:@"Tuesday 22-23" andWednesdayHours:@"Wednesday 23-24" andThursdayHours:@"Thursday 24-25" andFridayHours:@"Friday 25-26" andSaturdayHours:@"Saturday 26-27" andSundayHours:@"Sunday 27-28" andAllHours:@"All hours forever3" andPhoneString:@"studyabroadphone" andEmailString:@"studyabroad@pomona.edu" andLinkString:@"www.studyabroadforever.com"];
    
    
    //Empty the database if necessary
    //[PlaceDatabase emptyDatabase];
    
    //Save some test places to database
    //[PlaceDatabase saveItemWithPlace:fraryDining];
    //[PlaceDatabase saveItemWithPlace:frankDining];
    //[PlaceDatabase saveItemWithPlace:campusSafety];
    //[PlaceDatabase saveItemWithPlace:studyAbroad];
    
    //TESTS
    
    //Test: fetch all items
//    NSMutableArray *testFetchAll = [PlaceDatabase fetchAllPlaces];
    
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
//    NSMutableArray *testSelectSpecific = [PlaceDatabase fetchPlacesBySpecificCategory:@"Dining Hall"];
    
//    for (id object in testSelectSpecific) { //print all fetched items
//        Place *tempPlace = (Place *)object;
//        [tempPlace printPlace];
//    }
//    NSLog(@"%i",[testSelectSpecific count]);
    
    //Test: fetch by name
//    NSMutableArray *testSelectName = [PlaceDatabase fetchPlacesByName:@"Frary Dining Hall"];
    
//    for (id object in testSelectName) { //print all fetched items
//        Place *tempPlace = (Place *)object;
//        [tempPlace printPlace];
//    }

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
