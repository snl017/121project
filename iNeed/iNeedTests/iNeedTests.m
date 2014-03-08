//
//  iNeedTests.m
//  iNeedTests
//
//  Created by jarthurcs on 2/18/14.
//  Copyright (c) 2014 121. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PlaceDatabase.h"
#import "Place.h"
#import "Hours.h"
#import "Constants.h"

@interface iNeedTests : XCTestCase

@end

@implementation iNeedTests

- (void)setUp
{
    [super setUp];
    [PlaceDatabase createEditableCopyOfDatabaseIfNeeded];
    [PlaceDatabase emptyDatabase];
    [PlaceDatabase initDatabase];
    //Create some test Hours
    Hours *h1 = [[Hours alloc] initWithOpeningDigits:@"0100" andClosingDigits:@"0200"];
    Hours *h2 = [[Hours alloc] initWithOpeningDigits:@"0200" andClosingDigits:@"0300"];
    Hours *h3 = [[Hours alloc] initWithOpeningDigits:@"0300" andClosingDigits:@"0400"];
    Hours *h4 = [[Hours alloc] initWithOpeningDigits:@"0400" andClosingDigits:@"0500"];
    Hours *h5 = [[Hours alloc] initWithOpeningDigits:@"0500" andClosingDigits:@"0600"];
    Hours *h6 = [[Hours alloc] initWithOpeningDigits:@"0600" andClosingDigits:@"0700"];
    Hours *h7 = [[Hours alloc] initWithOpeningDigits:@"0700" andClosingDigits:@"0800"];
    
    
    //First create some test Places
    Place *fraryDining = [[Place alloc] initWithSchool:PomonaSchool andName:@"Frary Dining Hall" andLocation:@"Pomona College" andMondayHours:h3 andTuesdayHours:h3 andWednesdayHours:h3 andThursdayHours:h3 andFridayHours:h3 andSaturdayHours:h3 andSundayHours:h4 andPhoneString:@"123-456-7890" andEmailString:@"frarysomething@pomona.edu" andLinkString:None andExtraInfo:@"Snack M-Th"];
    
    Place *frankDining = [[Place alloc] initWithSchool:PomonaSchool andName:@"Frank Dining Hall" andLocation:@"Pomona College" andMondayHours:h1 andTuesdayHours:h2 andWednesdayHours:h3 andThursdayHours:h4 andFridayHours:h5 andSaturdayHours:h6 andSundayHours:h7 andPhoneString:@"frank-456-7890" andEmailString:@"franksomething@pomona.edu" andLinkString:@"www.google.com" andExtraInfo:None];
    
    Hours *coopStWeek =[[Hours alloc] initWithOpeningDigits:@"0900" andClosingDigits:@"0000"];
    Hours *coopStSat =[[Hours alloc] initWithOpeningDigits:@"1200" andClosingDigits:@"0000"];
    Hours *coopStSun =[[Hours alloc] initWithOpeningDigits:@"1200" andClosingDigits:@"2000"];
    Hours *allDay =[[Hours alloc] initWithOpeningDigits:@"0000" andClosingDigits:@"2359"];
    
    Place *coopStore = [[Place alloc] initWithSchool:PomonaSchool andName:@"Coop Store" andLocation:@"Smith Campus Center, Pomona College\n170 E 6th St" andMondayHours:coopStWeek andTuesdayHours:coopStWeek andWednesdayHours:coopStWeek andThursdayHours:coopStWeek andFridayHours:coopStWeek andSaturdayHours:coopStSat andSundayHours:coopStSun andPhoneString:@"909-607-2264" andEmailString:@"coopstore@aspc.pomona.edu" andLinkString:@"http://coopstore.pomona.edu" andExtraInfo:None];

    Place *campusSafety = [[Place alloc] initWithSchool:CUCSchool andName:@"Campus Safety" andLocation:@"Pendleton Business Building\n150 E 8th St\nClaremont, CA 91711" andMondayHours:allDay andTuesdayHours:allDay andWednesdayHours:allDay andThursdayHours:allDay andFridayHours:allDay andSaturdayHours:allDay andSundayHours:allDay andPhoneString:@"1-909-607-2000" andEmailString:@"dispatch@cuc.claremont.edu" andLinkString:@"http://www.cuc.claremont.edu/campussafety/" andExtraInfo:None];
    
    //Save some test places to database
    [PlaceDatabase saveItemWithPlace:fraryDining andSpecificCategory:DiningHallNarrow andBroadCategory:FoodBroad];
    [PlaceDatabase saveItemWithPlace:frankDining andSpecificCategory:DiningHallNarrow andBroadCategory:FoodBroad];
     [PlaceDatabase saveItemWithPlace:campusSafety andSpecificCategory:SafetyHealth andBroadCategory:SafetyHealth];
    [PlaceDatabase savePlace:coopStore.name withSpecificCategory:StoresNarrow andBroadCategory:LivingOnCampusBroad];
    [PlaceDatabase savePlace:coopStore.name withSpecificCategory:EateryGroceryNarrow andBroadCategory:FoodBroad];
    [PlaceDatabase saveItemWithPlace:coopStore];

    // Put setup code here. This method is called before the invocation of each test method in the class.
}

-(void)testInputToDatabase{
    XCTAssertNotNil([PlaceDatabase fetchAllPlaces]);
}
- (void)testPlaceClass{
    NSMutableArray *diningArray = [PlaceDatabase fetchPlacesBySpecificCategory:DiningHallNarrow];
    Place *frary = [diningArray objectAtIndex:0];
    NSMutableArray *allHoursArray = [frary getAllHours];
    for (id object in allHoursArray){
        XCTAssertNotNil(object);
    }
}

//Test out Hours class
-(void)testHoursClass{
    Hours *normalHours = [[Hours alloc] initWithOpeningDigits:@"0961" andClosingDigits:@"1700"];
    XCTAssertNotNil(normalHours);
    NSString *dispString = [normalHours hoursToDisplayString];
    NSString *dataString = [normalHours hoursToDatabaseString];
    XCTAssertNotNil(dispString, @"@");
    XCTAssertNotNil(dataString, @"@");
    //
    XCTAssertEqualObjects(dispString, @"9:61AM-5:00PM", @"@");
    XCTAssertEqualObjects(dataString, @"0961-1700", @"@");
    
    
    //These hours are initiated with a digits-dash-digits string presumably pulled from database
    //NOTE: may need to do checks on database inited hours to make sure valid, just as the checks are done for the regular init
    Hours *dbHours = [[Hours alloc] initWithOneString:@"0961-1700"];
    XCTAssertNotNil(dbHours);
    NSString *dispDbHours = [dbHours hoursToDisplayString];
    NSString *dataDbHours = [dbHours hoursToDatabaseString];
    
    XCTAssertEqualObjects(dispDbHours, @"9:61AM-5:00PM", @"@");
    XCTAssertEqualObjects(dataDbHours, @"0961-1700", @"@");
    
    //Closed!
    Hours *closed = [[Hours alloc]initAsClosedAllDay];
    XCTAssertNotNil(closed);
    NSString *closedString = [closed hoursToDisplayString];
    NSString *closedDataString = [closed hoursToDatabaseString];
    //
    XCTAssertEqualObjects(closedString, @"Closed", @"@");
    XCTAssertEqualObjects(closedDataString, @"Closed", @"@");
    
}


-(void)testSelectByName{
    NSMutableArray *places =[PlaceDatabase fetchPlacesByName:@"Frary Dining Hall"];
    XCTAssertTrue([places count]==1, @"d");
    Place *frary = [places objectAtIndex:0];
    XCTAssertEqualObjects(frary.name, @"Frary Dining Hall", @"@");
}

-(void)testSelectBySpecific{
    NSMutableArray *names =[PlaceDatabase fetchNamesbySpecific:DiningHallNarrow];
    XCTAssertEqualObjects([names objectAtIndex:0], @"Frary Dining Hall", @"@");
    XCTAssertEqualObjects([names objectAtIndex:1], @"Frank Dining Hall", @"@");
}
-(void)testSelectByBroad{
    NSMutableArray *names =[PlaceDatabase fetchNamesbyBroad:FoodBroad];
    XCTAssertEqualObjects([names objectAtIndex:0], @"Frary Dining Hall", @"@");
    XCTAssertEqualObjects([names objectAtIndex:1], @"Frank Dining Hall", @"@");
}

//Update Hours test
-(void)testUpdateHours{
    Hours *newHours = [[Hours alloc]initWithOpeningDigits:@"0000" andClosingDigits:@"1000"];
    [PlaceDatabase updateMondayHoursByName:@"Frary Dining Hall" andNewHours: newHours];
    NSMutableArray *places= [PlaceDatabase fetchPlacesByName:@"Frary Dining Hall"];
    Place *frary = [places objectAtIndex:0];
    XCTAssertEqualObjects(frary.mondayHours.hoursToDisplayString, newHours.hoursToDisplayString, @"@");

}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}



//- (void)testExample
//{
//    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
//}

@end
