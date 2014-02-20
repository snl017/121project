//
//  PlaceDatabase.m
//  iNeed
//
//  Created by Anna Turner on 2/17/14.
//  Copyright (c) 2014 Anna Turner. All rights reserved.
//

#import "PlaceDatabase.h"

@implementation PlaceDatabase

//Our Database is called db
static sqlite3 *db;

//Statements: Fetching each place, or deleting,inserting a place. Also creating database
static sqlite3_stmt *createPlaceDatabase;
static sqlite3_stmt *fetchPlaces;
static sqlite3_stmt *deletePlace;
static sqlite3_stmt *insertPlace;

//Specialized statements: Fetching by broad, specific, name categories
static sqlite3_stmt *selectBroadCategoryPlaces;
static sqlite3_stmt *selectSpecificCategoryPlaces;
static sqlite3_stmt *selectNamePlaces;



//More specialized statements: Updating monday - sunday hrs, all hrs - TODO
//TODO - searching by school if we ever get to that




//Create Database if Needed.
+ (void)createEditableCopyOfDatabaseIfNeeded {
    
    BOOL success;
    
    // Look for an existing database
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentDirectory stringByAppendingPathComponent:@"placeDatabase.sql"];
    success = [fileManager fileExistsAtPath:writableDBPath];
    NSLog(@"%@", writableDBPath);
    if (success) return;
    
    // if failed to find one, copy the empty scrapdatabase database into the location
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"placeDatabase.sql"];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    if (!success) {
        NSAssert1(0, @"FAILED to create writable database file with message, '%@'.", [error localizedDescription]);
    }
}



//Setup of Database.
//School - name - broad category - specific category - location - monday - tuesday - wednesday - thursday - friday - saturday - sunday - allhours - phone - email - link//
+ (void)initDatabase{
    
    //These are the actual calls to sqlite table.
    const char *createTableString = "CREATE TABLE IF NOT EXISTS placeDatabase (rowid INTEGER PRIMARY KEY AUTOINCREMENT, school TEXT, name TEXT, broad TEXT, specific TEXT, location TEXT, monday TEXT, tuesday TEXT, wednesday TEXT, thursday TEXT, friday TEXT, saturday TEXT, sunday TEXT, allhours TEXT, phone TEXT, email TEXT, link TEXT)";
    const char *fetchPlacesString = "SELECT * FROM placeDatabase";
    const char *insertPlaceString = "INSERT INTO placeDatabase (school, name, specific, location, monday, tuesday, wednesday, thursday, friday, saturday, sunday, allhours, phone, email, link) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
    const char *deletePlaceString = "DELETE FROM placeDatabase WHERE rowid=?";
    const char *selectBroadCategoryPlacesString = "SELECT * FROM placeDatabase WHERE broad=?";
    const char *selectSpecificCategoryPlacesString = "SELECT * FROM placeDatabase WHERE specific=?";
    const char *selectNamePlacesString = "SELECT * FROM placeDatabase WHERE name=?";
    
    
    
    // Create the path to the database
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *path = [documentDirectory stringByAppendingPathComponent:@"placeDatabase"];
    
    
    
    // open the database connection
    if (sqlite3_open([path UTF8String], &db)) {
        NSLog(@"ERROR opening the db");
    }
    
    int success;
    
    
    
    //init table statement
    if (sqlite3_prepare_v2(db, createTableString, -1, &createPlaceDatabase, NULL) != SQLITE_OK) {
        NSLog(@"Failed to prepare create table statement");
        NSLog(@"%s Prepare failure '%s' (%1d)", __FUNCTION__, sqlite3_errmsg(db), sqlite3_errcode(db));
    }
    
    
    
    // execute the table creation statement
    success = sqlite3_step(createPlaceDatabase);
    sqlite3_reset(createPlaceDatabase);
    if (success != SQLITE_DONE) {
        NSLog(@"ERROR: failed to create table");
        NSLog(@"%s Prepare failure '%s' (%1d)", __FUNCTION__, sqlite3_errmsg(db), sqlite3_errcode(db));
        
    }
    
    
    
    //init retrieval statement
    if (sqlite3_prepare_v2(db, fetchPlacesString, -1, &fetchPlaces, NULL) != SQLITE_OK) {
        NSLog(@"ERROR: failed to prepare fetching statement");
        NSLog(@"%s Prepare failure '%s' (%1d)", __FUNCTION__, sqlite3_errmsg(db), sqlite3_errcode(db));
        
    }
    
    
    
    //init insertion statement
    if (sqlite3_prepare_v2(db, insertPlaceString, -1, &insertPlace, NULL) != SQLITE_OK) {
        NSLog(@"ERROR: failed to prepare inserting statement");
        NSLog(@"%s Prepare failure '%s' (%1d)", __FUNCTION__, sqlite3_errmsg(db), sqlite3_errcode(db));
    }
    
    
    
    // init deletion statement
    if (sqlite3_prepare_v2(db, deletePlaceString, -1, &deletePlace, NULL) != SQLITE_OK) {
        NSLog(@"ERROR: failed to prepare deleting statement");
        NSLog(@"%s Prepare failure '%s' (%1d)", __FUNCTION__, sqlite3_errmsg(db), sqlite3_errcode(db));
        
    }
    
    
    // init select broad statement
    if (sqlite3_prepare_v2(db, selectBroadCategoryPlacesString, -1, &selectBroadCategoryPlaces, NULL) != SQLITE_OK) {
        NSLog(@"ERROR: failed to prepare selectBroadCategoryPlaces statement");
        NSLog(@"%s Prepare failure '%s' (%1d)", __FUNCTION__, sqlite3_errmsg(db), sqlite3_errcode(db));
        
    }
    
    
    // init select specific statement
    if (sqlite3_prepare_v2(db, selectSpecificCategoryPlacesString, -1, &selectSpecificCategoryPlaces, NULL) != SQLITE_OK) {
        NSLog(@"ERROR: failed to prepare selectSpecificCategoryPlaces statement");
        NSLog(@"%s Prepare failure '%s' (%1d)", __FUNCTION__, sqlite3_errmsg(db), sqlite3_errcode(db));
        
    }
    
    
    // init select name statement
    if (sqlite3_prepare_v2(db, selectNamePlacesString, -1, &selectNamePlaces, NULL) != SQLITE_OK) {
        NSLog(@"ERROR: failed to prepare selectNamePlaces statement");
        NSLog(@"%s Prepare failure '%s' (%1d)", __FUNCTION__, sqlite3_errmsg(db), sqlite3_errcode(db));
        
    }
}




//School - name - broad category - specific category - location - monday - tuesday - wednesday - thursday - friday - saturday - sunday - allhours - phone - email - link//
//Read in everything from database
+ (NSMutableArray *)fetchAllPlaces
{
    //Create array to hold information
    NSMutableArray *ret = [NSMutableArray arrayWithCapacity:0];
    
    while (sqlite3_step(fetchPlaces) == SQLITE_ROW) {
        
        // query columns from fetch statement (we exclude rowid for now?)
        NSString *schoolString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 1)];
        NSString *nameString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 2)];
        NSString *broadString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 3)];
        NSString *specificString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 4)];
        NSString *locationString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 5)];
        NSString *mondayString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 6)];
        NSString *tuesdayString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 7)];
        NSString *wednesdayString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 8)];
        NSString *thursdayString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 9)];
        NSString *fridayString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 10)];
        NSString *saturdayString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 11)];
        NSString *sundayString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 12)];
        NSString *allhoursString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 13)];
        NSString *phoneString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 14)];
        NSString *emailString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 15)];
        NSString *linkString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 16)];
        
        
        
        //Create Place object with information
        Place *databasePlace = [[Place alloc] initWithSchool:schoolString andName:nameString andBroadCategory:broadString andSpecificCategory:specificString andLocation:locationString andMondayHours:mondayString andTuesdayHours:tuesdayString andWednesdayHours:wednesdayString andThursdayHours:thursdayString andFridayHours:fridayString andSaturdayHours:saturdayString andSundayHours:sundayString andAllHours:allhoursString andPhoneString:phoneString andEmailString:emailString andLinkString:linkString];
        
        //Add place object to array
        [ret addObject:databasePlace];
        
        
        
    }
    
    //Reset and Return
    sqlite3_reset(fetchPlaces);
    return ret;
}





//More Fetching/Selecting functions
+ (NSMutableArray *)fetchPlacesByName:(NSString *)name{
    //First we bind to the selectBroadCategoryPlaces statement
    sqlite3_bind_text(selectNamePlaces, 1, [name UTF8String], -1, SQLITE_TRANSIENT);
    
    //The array that gets returned
    NSMutableArray *ret = [NSMutableArray arrayWithCapacity:0];
    
    //Get all rows with correct broad category info and place into array as a Place
    while (sqlite3_step(selectNamePlaces) == SQLITE_ROW) {
        
        // query columns from fetch statement (we exclude rowid for now?)
        NSString *schoolString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 1)];
        NSString *nameString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 2)];
        NSString *broadString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 3)];
        NSString *specificString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 4)];
        NSString *locationString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 5)];
        NSString *mondayString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 6)];
        NSString *tuesdayString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 7)];
        NSString *wednesdayString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 8)];
        NSString *thursdayString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 9)];
        NSString *fridayString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 10)];
        NSString *saturdayString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 11)];
        NSString *sundayString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 12)];
        NSString *allhoursString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 13)];
        NSString *phoneString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 14)];
        NSString *emailString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 15)];
        NSString *linkString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 16)];
        
        
        
        //Create Place object with information
        Place *databasePlace = [[Place alloc] initWithSchool:schoolString andName:nameString andBroadCategory:broadString andSpecificCategory:specificString andLocation:locationString andMondayHours:mondayString andTuesdayHours:tuesdayString andWednesdayHours:wednesdayString andThursdayHours:thursdayString andFridayHours:fridayString andSaturdayHours:saturdayString andSundayHours:sundayString andAllHours:allhoursString andPhoneString:phoneString andEmailString:emailString andLinkString:linkString];
        
        //Add place object to array
        [ret addObject:databasePlace];
        
        //Should we be checking for success here?
    }
    
    //Reset the statement
    sqlite3_reset(selectNamePlaces);
    
    //if (success != SQLITE_DONE) {
    //    NSLog(@"ERROR: failed to select by broad category");
    //}
    
    //Return
    return ret;
}


+ (NSMutableArray *)fetchPlacesByBroadCategory:(NSString *)broadCategory{
    
    //First we bind to the selectBroadCategoryPlaces statement
    sqlite3_bind_text(selectBroadCategoryPlaces, 1, [broadCategory UTF8String], -1, SQLITE_TRANSIENT);

    //The array that gets returned
    NSMutableArray *ret = [NSMutableArray arrayWithCapacity:0];
    
    //Get all rows with correct broad category info and place into array as a Place
    while (sqlite3_step(selectBroadCategoryPlaces) == SQLITE_ROW) {
        
        // query columns from fetch statement (we exclude rowid for now?)
        NSString *schoolString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 1)];
        NSString *nameString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 2)];
        NSString *broadString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 3)];
        NSString *specificString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 4)];
        NSString *locationString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 5)];
        NSString *mondayString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 6)];
        NSString *tuesdayString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 7)];
        NSString *wednesdayString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 8)];
        NSString *thursdayString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 9)];
        NSString *fridayString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 10)];
        NSString *saturdayString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 11)];
        NSString *sundayString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 12)];
        NSString *allhoursString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 13)];
        NSString *phoneString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 14)];
        NSString *emailString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 15)];
        NSString *linkString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 16)];
        
        
        
        //Create Place object with information
        Place *databasePlace = [[Place alloc] initWithSchool:schoolString andName:nameString andBroadCategory:broadString andSpecificCategory:specificString andLocation:locationString andMondayHours:mondayString andTuesdayHours:tuesdayString andWednesdayHours:wednesdayString andThursdayHours:thursdayString andFridayHours:fridayString andSaturdayHours:saturdayString andSundayHours:sundayString andAllHours:allhoursString andPhoneString:phoneString andEmailString:emailString andLinkString:linkString];
        
        //Add place object to array
        [ret addObject:databasePlace];
        
        //Should we be checking for success here?
    }
    
    //Reset the statement
    sqlite3_reset(selectBroadCategoryPlaces);
    
    //if (success != SQLITE_DONE) {
    //    NSLog(@"ERROR: failed to select by broad category");
    //}
    
    //Return
    return ret;
}


+ (NSMutableArray *)fetchPlacesBySpecificCategory:(NSString *)specificCategory{
    //First we bind to the selectBroadCategoryPlaces statement
    sqlite3_bind_text(selectSpecificCategoryPlaces, 1, [specificCategory UTF8String], -1, SQLITE_TRANSIENT);
    
    //The array that gets returned
    NSMutableArray *ret = [NSMutableArray arrayWithCapacity:0];
    
    //Get all rows with correct broad category info and place into array as a Place
    while (sqlite3_step(selectSpecificCategoryPlaces) == SQLITE_ROW) {
        
        // query columns from fetch statement (we exclude rowid for now?)
        NSString *schoolString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 1)];
        NSString *nameString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 2)];
        NSString *broadString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 3)];
        NSString *specificString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 4)];
        NSString *locationString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 5)];
        NSString *mondayString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 6)];
        NSString *tuesdayString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 7)];
        NSString *wednesdayString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 8)];
        NSString *thursdayString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 9)];
        NSString *fridayString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 10)];
        NSString *saturdayString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 11)];
        NSString *sundayString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 12)];
        NSString *allhoursString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 13)];
        NSString *phoneString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 14)];
        NSString *emailString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 15)];
        NSString *linkString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 16)];
        
        
        
        //Create Place object with information
        Place *databasePlace = [[Place alloc] initWithSchool:schoolString andName:nameString andBroadCategory:broadString andSpecificCategory:specificString andLocation:locationString andMondayHours:mondayString andTuesdayHours:tuesdayString andWednesdayHours:wednesdayString andThursdayHours:thursdayString andFridayHours:fridayString andSaturdayHours:saturdayString andSundayHours:sundayString andAllHours:allhoursString andPhoneString:phoneString andEmailString:emailString andLinkString:linkString];
        
        //Add place object to array
        [ret addObject:databasePlace];
        
        //Should we be checking for success here?
    }
    
    //Reset the statement
    sqlite3_reset(selectSpecificCategoryPlaces);
    
    //if (success != SQLITE_DONE) {
    //    NSLog(@"ERROR: failed to select by specific category");
    //}
    
    //Return
    return ret;
}







//Save Function: saving item into database. Will we need to use this? Probably not. But it's good to have just in case.
+ (void)saveItemWithSchool:(NSString *)school andName:(NSString *)name andBroadCategory:(NSString *)broadCategory andSpecificCategory:(NSString *)specificCategory andLocation:(NSString *)location andMondayHours:(NSString *)monday andTuesdayHours:(NSString *)tuesday andWednesdayHours:(NSString *)wednesday andThursdayHours:(NSString *)thursday andFridayHours:(NSString *)friday andSaturdayHours:(NSString *)saturday andSundayHours:(NSString *)sunday andAllHours:(NSString *)allhours andPhoneString:(NSString *)phone andEmailString:(NSString *)email andLinkString:(NSString *)webLink{
    
    // bind data to the statement
    sqlite3_bind_text(insertPlace, 1, [school UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertPlace, 1, [name UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertPlace, 1, [broadCategory UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertPlace, 1, [specificCategory UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertPlace, 1, [location UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertPlace, 1, [monday UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertPlace, 1, [tuesday UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertPlace, 1, [wednesday UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertPlace, 1, [thursday UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertPlace, 1, [friday UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertPlace, 1, [saturday UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertPlace, 1, [sunday UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertPlace, 1, [allhours UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertPlace, 1, [phone UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertPlace, 1, [email UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertPlace, 1, [webLink UTF8String], -1, SQLITE_TRANSIENT);
    
    
    int success = sqlite3_step(insertPlace);
    
    //Reset!
    sqlite3_reset(insertPlace);
    
    if (success != SQLITE_DONE) {
        NSLog(@"ERROR: failed to insert item");
    }
}



//Again, unclear if we are going to be deleting from our app. Can remove this function if necessary.
//Delete Item from database
+ (void)deletePlace:(int)rowid;
{
    // bind the row id, step the statement, reset the statement, check for error... EASY
    sqlite3_bind_int(deletePlace, 1, rowid);    //I AM UNSURE IF SHOULD BE 1 OR 0
    int success = sqlite3_step(deletePlace);
    sqlite3_reset(deletePlace);
    if (success != SQLITE_DONE) {
        NSLog(@"ERROR: failed to delete item");
    }
}


//Cleanup Function
+ (void)cleanUpDatabaseForQuit
{
    // finalize frees the compiled statements, close closes the database connection
    sqlite3_finalize(fetchPlaces);
    sqlite3_finalize(insertPlace);
    sqlite3_finalize(deletePlace);
    sqlite3_finalize(createPlaceDatabase);
    sqlite3_close(db);
}






@end
