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

//Place table
//Statements: Fetching each place, or deleting, inserting a place. Also creating & emptying place table, deleting table.
static sqlite3_stmt *createPlaceTable;
static sqlite3_stmt *fetchPlaces;
static sqlite3_stmt *deletePlace;
static sqlite3_stmt *insertPlace;
static sqlite3_stmt *emptyPlacesTable;
static sqlite3_stmt *dropTablePlaces;

//Statements for the Categories table: Fetching, deleting, inserting, creating table, emptying table, deleting table.
static sqlite3_stmt *createCatTable;
static sqlite3_stmt *deleteCat;
static sqlite3_stmt *insertCat;
static sqlite3_stmt *emptyCategories;
static sqlite3_stmt *dropTableCategories;


//Update statements for updating hours! This will be used once we implement scraping.
static sqlite3_stmt *updateMondayHoursByNameStmt;
static sqlite3_stmt *updateTuesdayHoursByNameStmt;
static sqlite3_stmt *updateWednesdayHoursByNameStmt;
static sqlite3_stmt *updateThursdayHoursByNameStmt;
static sqlite3_stmt *updateFridayHoursByNameStmt;
static sqlite3_stmt *updateSaturdayHoursByNameStmt;
static sqlite3_stmt *updateSundayHoursByNameStmt;

//Specialized statements: Fetching Places by name
static sqlite3_stmt *selectNamePlaces;

//Specialized statements: Fetching names by broad, specific categories
static sqlite3_stmt *selectBroadCategoryCat;
static sqlite3_stmt *selectSpecificCategoryCat;


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
//Places Table:
//School - name - broad category - specific category - location - monday - tuesday - wednesday - thursday - friday - saturday - sunday - allhours - phone - email - link//
//Categories Table:
//Broad Category-Specific Category-Name
+ (void)initDatabase{
    
    //These are the actual calls to sqlite table placeDatabase.
    //Statements for places table
        //Create, Fetch, Insert, Delete, Empty
    const char *createTableString = "CREATE TABLE IF NOT EXISTS places (rowid INTEGER PRIMARY KEY AUTOINCREMENT, school TEXT, name TEXT, location TEXT, monday TEXT, tuesday TEXT, wednesday TEXT, thursday TEXT, friday TEXT, saturday TEXT, sunday TEXT, phone TEXT, email TEXT, link TEXT, extraInfo TEXT)";
    const char *fetchPlacesString = "SELECT * FROM places";
    const char *insertPlaceString = "INSERT INTO places (school, name, location, monday, tuesday, wednesday, thursday, friday, saturday, sunday, phone, email, link, extraInfo) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
    const char *deletePlaceString = "DELETE FROM places WHERE rowid=?";
    const char *emptyPlacesTableString = "DELETE FROM places;";
    const char *dropTablePlacesString= "DROP TABLE places";
    
        //Specific selection queries
    const char *selectNamePlacesString = "SELECT * FROM places WHERE name=?";
        //Update queries
    const char *updateMondayHoursByNameString = "UPDATE places SET monday=? WHERE name=?";
    const char *updateTuesdayHoursByNameString = "UPDATE places SET tuesday=? WHERE name=?";
    const char *updateWednesdayHoursByNameString = "UPDATE places SET wednesday=? WHERE name=?";
    const char *updateThursdayHoursByNameString = "UPDATE places SET thursday=? WHERE name=?";
    const char *updateFridayHoursByNameString = "UPDATE places SET friday=? WHERE name=?";
    const char *updateSaturdayHoursByNameString = "UPDATE places SET saturday=? WHERE name=?";
    const char *updateSundayHoursByNameString = "UPDATE places SET sunday=? WHERE name=?";
    
    //Calls to the sqlite table categories
    //Creation, fetchall, insert, delete, empty database queries
    const char *createCatTableString = "CREATE TABLE IF NOT EXISTS categories (rowid INTEGER PRIMARY KEY AUTOINCREMENT, broad TEXT, specific TEXT, name TEXT)";
    const char *insertCatString = "INSERT INTO categories (broad, specific, name) VALUES (?, ?, ?)";
    const char *deleteCatString = "DELETE FROM categories WHERE rowid=?";
    const char *emptyCatTableString = "DELETE FROM categories;";
    const char *dropTableCategoriesString= "DROP TABLE categories";
    //Specific selection queries
    const char *selectBroadCatString = "SELECT name FROM categories WHERE broad=?";
    const char *selectSpecificCatString = "SELECT name FROM categories WHERE specific=?";
    
    
    // Create the path to the database
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *path = [documentDirectory stringByAppendingPathComponent:@"placeDatabase"];
    
    // open the database connection
    if (sqlite3_open([path UTF8String], &db)) {
        NSLog(@"ERROR opening the db");
    }
    
    int success;
    
    //Create Places Table & Initialize sqlite3 Statements
    
    //init table statement for places table
    if (sqlite3_prepare_v2(db, createTableString, -1, &createPlaceTable, NULL) != SQLITE_OK) {
        NSLog(@"Failed to prepare create table statement for places");
        NSLog(@"%s Prepare failure '%s' (%1d)", __FUNCTION__, sqlite3_errmsg(db), sqlite3_errcode(db));
    }
    
    // execute the table creation statement for the places table
    success = sqlite3_step(createPlaceTable);
    sqlite3_reset(createPlaceTable);
    if (success != SQLITE_DONE) {
        NSLog(@"ERROR: failed to create table places");
        NSLog(@"%s Prepare failure '%s' (%1d)", __FUNCTION__, sqlite3_errmsg(db), sqlite3_errcode(db));
    }
    
    //init retrieval statement for the places table
    if (sqlite3_prepare_v2(db, fetchPlacesString, -1, &fetchPlaces, NULL) != SQLITE_OK) {
        NSLog(@"ERROR: failed to prepare fetching statement for places");
        NSLog(@"%s Prepare failure '%s' (%1d)", __FUNCTION__, sqlite3_errmsg(db), sqlite3_errcode(db));
    }
    
    //init insertion statement for the places table
    if (sqlite3_prepare_v2(db, insertPlaceString, -1, &insertPlace, NULL) != SQLITE_OK) {
        NSLog(@"ERROR: failed to prepare inserting statement for places");
        NSLog(@"%s Prepare failure '%s' (%1d)", __FUNCTION__, sqlite3_errmsg(db), sqlite3_errcode(db));
    }
    
    // init deletion statement for the places table
    if (sqlite3_prepare_v2(db, deletePlaceString, -1, &deletePlace, NULL) != SQLITE_OK) {
        NSLog(@"ERROR: failed to prepare deleting statement for places");
        NSLog(@"%s Prepare failure '%s' (%1d)", __FUNCTION__, sqlite3_errmsg(db), sqlite3_errcode(db));
    }
    // init drop statement for the places table
    if (sqlite3_prepare_v2(db, dropTablePlacesString, -1, &dropTablePlaces, NULL) != SQLITE_OK) {
        NSLog(@"ERROR: failed to prepare drop statement for places table");
        NSLog(@"%s Prepare failure '%s' (%1d)", __FUNCTION__, sqlite3_errmsg(db), sqlite3_errcode(db));
    }
    
    // init select name statement for the places table
    if (sqlite3_prepare_v2(db, selectNamePlacesString, -1, &selectNamePlaces, NULL) != SQLITE_OK) {
        NSLog(@"ERROR: failed to prepare selectNamePlaces statement for places");
        NSLog(@"%s Prepare failure '%s' (%1d)", __FUNCTION__, sqlite3_errmsg(db), sqlite3_errcode(db));
    }
    
    // init empty statement for the places table
    if (sqlite3_prepare_v2(db, emptyPlacesTableString, -1, &emptyPlacesTable, NULL) != SQLITE_OK) {
        NSLog(@"ERROR: failed to prepare empty placesTable statement");
        NSLog(@"%s Prepare failure '%s' (%1d)", __FUNCTION__, sqlite3_errmsg(db), sqlite3_errcode(db));
    }
    
    // init all the update hours statements for the places table
    if (sqlite3_prepare_v2(db, updateMondayHoursByNameString, -1, &updateMondayHoursByNameStmt, NULL) != SQLITE_OK) {
        NSLog(@"ERROR: failed to prepare update monday hours database statement");
        NSLog(@"%s Prepare failure '%s' (%1d)", __FUNCTION__, sqlite3_errmsg(db), sqlite3_errcode(db));
    }
    if (sqlite3_prepare_v2(db, updateTuesdayHoursByNameString, -1, &updateTuesdayHoursByNameStmt, NULL) != SQLITE_OK) {
        NSLog(@"ERROR: failed to prepare update tuesday hours database statement");
        NSLog(@"%s Prepare failure '%s' (%1d)", __FUNCTION__, sqlite3_errmsg(db), sqlite3_errcode(db));
    }
    if (sqlite3_prepare_v2(db, updateWednesdayHoursByNameString, -1, &updateWednesdayHoursByNameStmt, NULL) != SQLITE_OK) {
        NSLog(@"ERROR: failed to prepare update wednesday hours database statement");
        NSLog(@"%s Prepare failure '%s' (%1d)", __FUNCTION__, sqlite3_errmsg(db), sqlite3_errcode(db));
    }
    if (sqlite3_prepare_v2(db, updateThursdayHoursByNameString, -1, &updateThursdayHoursByNameStmt, NULL) != SQLITE_OK) {
        NSLog(@"ERROR: failed to prepare update thursday hours database statement");
        NSLog(@"%s Prepare failure '%s' (%1d)", __FUNCTION__, sqlite3_errmsg(db), sqlite3_errcode(db));
    }
    if (sqlite3_prepare_v2(db, updateFridayHoursByNameString, -1, &updateFridayHoursByNameStmt, NULL) != SQLITE_OK) {
        NSLog(@"ERROR: failed to prepare update friday hours database statement");
        NSLog(@"%s Prepare failure '%s' (%1d)", __FUNCTION__, sqlite3_errmsg(db), sqlite3_errcode(db));
    }
    if (sqlite3_prepare_v2(db, updateSaturdayHoursByNameString, -1, &updateSaturdayHoursByNameStmt, NULL) != SQLITE_OK) {
        NSLog(@"ERROR: failed to prepare update saturday hours database statement");
        NSLog(@"%s Prepare failure '%s' (%1d)", __FUNCTION__, sqlite3_errmsg(db), sqlite3_errcode(db));
    }
    if (sqlite3_prepare_v2(db, updateSundayHoursByNameString, -1, &updateSundayHoursByNameStmt, NULL) != SQLITE_OK) {
        NSLog(@"ERROR: failed to prepare update sunday hours database statement");
        NSLog(@"%s Prepare failure '%s' (%1d)", __FUNCTION__, sqlite3_errmsg(db), sqlite3_errcode(db));
    }
    
    
    //Prepare the statements for the categories table
    //init table statement for categories table
    if (sqlite3_prepare_v2(db, createCatTableString, -1, &createCatTable, NULL) != SQLITE_OK) {
        NSLog(@"Failed to prepare create table statement for categories");
        NSLog(@"%s Prepare failure '%s' (%1d)", __FUNCTION__, sqlite3_errmsg(db), sqlite3_errcode(db));
    }
    
    //execute table creation statement for categories table
    success = sqlite3_step(createCatTable);
    sqlite3_reset(createCatTable);
    if (success != SQLITE_DONE) {
        NSLog(@"ERROR: failed to create table categories");
        NSLog(@"%s Prepare failure '%s' (%1d)", __FUNCTION__, sqlite3_errmsg(db), sqlite3_errcode(db));
    }
    
    //init insertion statement for categories
    if (sqlite3_prepare_v2(db, insertCatString, -1, &insertCat, NULL) != SQLITE_OK) {
        NSLog(@"ERROR: failed to prepare inserting statement for categories");
        NSLog(@"%s Prepare failure '%s' (%1d)", __FUNCTION__, sqlite3_errmsg(db), sqlite3_errcode(db));
    }
    
    // init deletion statement for categories table
    if (sqlite3_prepare_v2(db, deleteCatString, -1, &deleteCat, NULL) != SQLITE_OK) {
        NSLog(@"ERROR: failed to prepare deleting statement for categories");
        NSLog(@"%s Prepare failure '%s' (%1d)", __FUNCTION__, sqlite3_errmsg(db), sqlite3_errcode(db));
    }
    
    // init drop statement for the categories table
    if (sqlite3_prepare_v2(db, dropTableCategoriesString, -1, &dropTableCategories, NULL) != SQLITE_OK) {
        NSLog(@"ERROR: failed to prepare drop statement for categories table");
        NSLog(@"%s Prepare failure '%s' (%1d)", __FUNCTION__, sqlite3_errmsg(db), sqlite3_errcode(db));
    }
    
    // init select broad statement for categories table
    if (sqlite3_prepare_v2(db, selectBroadCatString, -1, &selectBroadCategoryCat, NULL) != SQLITE_OK) {
        NSLog(@"ERROR: failed to prepare selectBroadCategoryPlaces statement for categories table");
        NSLog(@"%s Prepare failure '%s' (%1d)", __FUNCTION__, sqlite3_errmsg(db), sqlite3_errcode(db));
    }
    
    // init select specific statement for categories table
    if (sqlite3_prepare_v2(db, selectSpecificCatString, -1, &selectSpecificCategoryCat, NULL) != SQLITE_OK) {
        NSLog(@"ERROR: failed to prepare selectSpecificCategoryPlaces statement for categories table");
        NSLog(@"%s Prepare failure '%s' (%1d)", __FUNCTION__, sqlite3_errmsg(db), sqlite3_errcode(db));
    }
    
    // init empty statement for categories table
    if (sqlite3_prepare_v2(db, emptyCatTableString, -1, &emptyCategories, NULL) != SQLITE_OK) {
        NSLog(@"ERROR: failed to prepare empty database statement for categories table");
        NSLog(@"%s Prepare failure '%s' (%1d)", __FUNCTION__, sqlite3_errmsg(db), sqlite3_errcode(db));
    }
    
}

//Fetches NSString names of places matching the specific category input from the categories table
+(NSMutableArray *) fetchNamesbySpecific:(NSString *)specific{
    //First we bind to the selectBroadCategoryPlaces statement
    sqlite3_bind_text(selectSpecificCategoryCat, 1, [specific UTF8String], -1, SQLITE_TRANSIENT);
        
    //The array that gets returned
    NSMutableArray *ret = [NSMutableArray arrayWithCapacity:0];
        
    //Get all rows with correct broad category info and place into array as a Place
    while (sqlite3_step(selectSpecificCategoryCat) == SQLITE_ROW) {
        NSString *nameString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(selectSpecificCategoryCat,0)];
        [ret addObject:nameString];
    }
    
    //Reset!
    sqlite3_reset(selectSpecificCategoryCat);
    return ret;
}
//Fetches NSString names of places matching the specific category input from the categories table
+(NSMutableArray *) fetchNamesbyBroad:(NSString *)broad{
    //First we bind to the selectBroadCategoryPlaces statement
    sqlite3_bind_text(selectBroadCategoryCat, 1, [broad UTF8String], -1, SQLITE_TRANSIENT);
    
    //The array that gets returned
    NSMutableArray *ret = [NSMutableArray arrayWithCapacity:0];
    
    //Get all rows with correct broad category info and place into array as a Place
    while (sqlite3_step(selectBroadCategoryCat) == SQLITE_ROW) {
        NSString *nameString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(selectBroadCategoryCat,0)];
        [ret addObject:nameString];
    }
    
    //Reset!
    sqlite3_reset(selectBroadCategoryCat);
    return ret;
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
        NSString *locationString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 3)];
        NSString *mondayString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 4)];
        NSString *tuesdayString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 5)];
        NSString *wednesdayString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 6)];
        NSString *thursdayString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 7)];
        NSString *fridayString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 8)];
        NSString *saturdayString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 9)];
        NSString *sundayString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 10)];
        NSString *phoneString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 11)];
        NSString *emailString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 12)];
        NSString *linkString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 13)];
        NSString *extraInfo = [NSString stringWithUTF8String:(char *) sqlite3_column_text(fetchPlaces, 14)];
        
        //Now we turn the hour-related strings to Hours objects in order to make a Place object.
        Hours *mondayHours = [[Hours alloc] initWithOneString:mondayString];
        Hours *tuesdayHours = [[Hours alloc] initWithOneString:tuesdayString];
        Hours *wednesdayHours = [[Hours alloc] initWithOneString:wednesdayString];
        Hours *thursdayHours = [[Hours alloc] initWithOneString:thursdayString];
        Hours *fridayHours = [[Hours alloc] initWithOneString:fridayString];
        Hours *saturdayHours = [[Hours alloc] initWithOneString:saturdayString];
        Hours *sundayHours = [[Hours alloc] initWithOneString:sundayString];
        
        //Create Place object with information
        Place *databasePlace = [[Place alloc] initWithSchool:schoolString andName:nameString andLocation:locationString andMondayHours:mondayHours andTuesdayHours:tuesdayHours andWednesdayHours:wednesdayHours andThursdayHours:thursdayHours andFridayHours:fridayHours andSaturdayHours:saturdayHours andSundayHours:sundayHours andPhoneString:phoneString andEmailString:emailString andLinkString:linkString andExtraInfo:extraInfo];
        
        //Add place object to array
        [ret addObject:databasePlace];
        
    }
    
    //Reset and Return
    sqlite3_reset(fetchPlaces);
    return ret;
}

//More Fetching/Selecting functions
//Fetch Places by Name.
+ (NSMutableArray *)fetchPlacesByName:(NSString *)name{
    //First we bind to the selectNamePlaces statement
    sqlite3_bind_text(selectNamePlaces, 1, [name UTF8String], -1, SQLITE_TRANSIENT);
    
    //The array that gets returned
    NSMutableArray *ret = [NSMutableArray arrayWithCapacity:0];
    
    //Get all rows with correct broad category info and place into array as a Place
    while (sqlite3_step(selectNamePlaces) == SQLITE_ROW) {
        
        // query columns from fetch statement (we exclude rowid for now?)
        NSString *schoolString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(selectNamePlaces, 1)];
        NSString *nameString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(selectNamePlaces, 2)];
        NSString *locationString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(selectNamePlaces, 3)];
        NSString *mondayString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(selectNamePlaces, 4)];
        NSString *tuesdayString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(selectNamePlaces, 5)];
        NSString *wednesdayString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(selectNamePlaces, 6)];
        NSString *thursdayString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(selectNamePlaces, 7)];
        NSString *fridayString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(selectNamePlaces, 8)];
        NSString *saturdayString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(selectNamePlaces, 9)];
        NSString *sundayString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(selectNamePlaces, 10)];
        NSString *phoneString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(selectNamePlaces, 11)];
        NSString *emailString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(selectNamePlaces, 12)];
        NSString *linkString = [NSString stringWithUTF8String:(char *) sqlite3_column_text(selectNamePlaces, 13)];
        NSString *extraInfo = [NSString stringWithUTF8String:(char *) sqlite3_column_text(selectNamePlaces, 14)];
        
        //Now we turn the hour-related strings to Hours objects in order to make a Place object.
        Hours *mondayHours = [[Hours alloc] initWithOneString:mondayString];
        Hours *tuesdayHours = [[Hours alloc] initWithOneString:tuesdayString];
        Hours *wednesdayHours = [[Hours alloc] initWithOneString:wednesdayString];
        Hours *thursdayHours = [[Hours alloc] initWithOneString:thursdayString];
        Hours *fridayHours = [[Hours alloc] initWithOneString:fridayString];
        Hours *saturdayHours = [[Hours alloc] initWithOneString:saturdayString];
        Hours *sundayHours = [[Hours alloc] initWithOneString:sundayString];
        
        //Create Place object with information
        Place *databasePlace = [[Place alloc] initWithSchool:schoolString andName:nameString andLocation:locationString andMondayHours:mondayHours andTuesdayHours:tuesdayHours andWednesdayHours:wednesdayHours andThursdayHours:thursdayHours andFridayHours:fridayHours andSaturdayHours:saturdayHours andSundayHours:sundayHours andPhoneString:phoneString andEmailString:emailString andLinkString:linkString andExtraInfo: extraInfo];
        
        //Add place object to array
        [ret addObject:databasePlace];
        
        //Should we be checking for success here?
    }
    
    //Reset the statement
    sqlite3_reset(selectNamePlaces);
    
    //if (success != SQLITE_DONE) {
    //    NSLog(@"ERROR: failed to select by name");
    //}
    
    //Return
    return ret;
}

//Fetches and returns Place objects from the places table.
//Determines which places to return using the categories table using specific category match.
+(NSMutableArray*)fetchPlacesBySpecificCategory:(NSString *)specificCategory{
    //The array that gets returned
    NSMutableArray *ret = [NSMutableArray arrayWithCapacity:0];
    
    //find the names of the places in the specific category
    NSMutableArray *placesMatching = [self fetchNamesbySpecific:specificCategory];
    for (id object in placesMatching){
        NSString *name = (NSString*) object;
        //Find the place that corresponds with that name
        NSMutableArray *newPlaces = [self fetchPlacesByName:name];
        //Add it to the array to return.
        [ret addObjectsFromArray:newPlaces];
    }
    return ret;
}

//Fetches and returns Place objects from the places table.
//Determines which places to return using the categories table using broad category match.
+(NSMutableArray*)fetchPlacesByBroadCategory:(NSString *)broadCategory{
    //The array that gets returned
    NSMutableArray *ret = [NSMutableArray arrayWithCapacity:0];
    
    //find the names of the places in the broad category
    NSMutableArray *placesMatching = [self fetchNamesbyBroad:broadCategory];
    for (id object in placesMatching){
        NSString *name = (NSString*) object;
        //Find the place that corresponds with that name
        NSMutableArray *newPlaces = [self fetchPlacesByName:name];
        //Add it to the array to return
        [ret addObjectsFromArray:newPlaces];
    }
    return ret;
}


//Saves an element in the categories table with the given name, specific category, and broad category
//Note that there is no check to ensure that this input is related to any elements in the places table.
+(void) savePlace:(NSString *)name withSpecificCategory:(NSString *)specific andBroadCategory:(NSString*)broad{
    // bind data to the statement
    sqlite3_bind_text(insertCat, 1, [broad UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertCat, 2, [specific UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertCat, 3, [name UTF8String], -1, SQLITE_TRANSIENT);
    
    int success = sqlite3_step(insertCat);
    
    //Reset!
    sqlite3_reset(insertCat);
    
    if (success != SQLITE_DONE) {
        NSLog(@"ERROR: failed to insert item into categories table");
    }
}

//Save Function: saving item into database. Will we need to use this? Probably not. But it's good to have just in case.
+ (void)saveItemWithSchool:(NSString *)school andName:(NSString *)name andLocation:(NSString *)location andMondayHours:(NSString *)monday andTuesdayHours:(NSString *)tuesday andWednesdayHours:(NSString *)wednesday andThursdayHours:(NSString *)thursday andFridayHours:(NSString *)friday andSaturdayHours:(NSString *)saturday andSundayHours:(NSString *)sunday andPhoneString:(NSString *)phone andEmailString:(NSString *)email andLinkString:(NSString *)webLink andExtraInfo:extraInfo{
    
    //PlaceDatabase Table
    
    // bind data to the statement
    sqlite3_bind_text(insertPlace, 1, [school UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertPlace, 2, [name UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertPlace, 3, [location UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertPlace, 4, [monday UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertPlace, 5, [tuesday UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertPlace, 6, [wednesday UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertPlace, 7, [thursday UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertPlace, 8, [friday UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertPlace, 9, [saturday UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertPlace, 10, [sunday UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertPlace, 11, [phone UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertPlace, 12, [email UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertPlace, 13, [webLink UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertPlace, 14, [extraInfo UTF8String], -1, SQLITE_TRANSIENT);
    
    int success = sqlite3_step(insertPlace);
    
    //Reset!
    sqlite3_reset(insertPlace);
    
    
    if (success != SQLITE_DONE) {
        NSLog(@"ERROR: failed to insert item");
    }
}

+ (void)saveItemWithPlace:(Place *)place{
    //Convert Hours into database-friendly strings
    NSString *mondayString = [place.mondayHours hoursToDatabaseString];
    NSString *tuesdayString = [place.tuesdayHours hoursToDatabaseString];
    NSString *wednesdayString = [place.wednesdayHours hoursToDatabaseString];
    NSString *thursdayString = [place.thursdayHours hoursToDatabaseString];
    NSString *fridayString = [place.fridayHours hoursToDatabaseString];
    NSString *saturdayString = [place.saturdayHours hoursToDatabaseString];
    NSString *sundayString = [place.sundayHours hoursToDatabaseString];
    
    //Use those strings in saving to database
    [self saveItemWithSchool:place.school andName:place.name andLocation:place.location andMondayHours:mondayString andTuesdayHours:tuesdayString andWednesdayHours:wednesdayString andThursdayHours:thursdayString andFridayHours:fridayString andSaturdayHours:saturdayString andSundayHours:sundayString andPhoneString:place.phone andEmailString:place.email andLinkString:place.webLink andExtraInfo:place.extraInfo];
}

//Insert an item into the place table using a Place object
//Also insert the item into the categories table to specify a specific and broad category from initalization into the database
+ (void)saveItemWithPlace:(Place *)place andSpecificCategory:(NSString *)specific andBroadCategory:(NSString *)broad{
    [self saveItemWithPlace:place];
    [self savePlace:place.name withSpecificCategory:specific andBroadCategory:broad];
}


//Again, unclear if we are going to be deleting from our app. Can remove this function if necessary.
//Delete Item from place table
+ (void)deletePlace:(int)rowid;
{
    // bind the row id, step the statement, reset the statement, check for error... EASY
    sqlite3_bind_int(deletePlace, 1, rowid);    //I AM UNSURE IF SHOULD BE 1 OR 0
    int success = sqlite3_step(deletePlace);
    sqlite3_reset(deletePlace);
    if (success != SQLITE_DONE) {
        NSLog(@"ERROR: failed to delete item from place table");
    }
}

//Again, unclear if we are going to be deleting from our app. Can remove this function if necessary.
//Delete Item from categories table
+ (void)deleteCategoryTableRow:(int)rowid;
{
    // bind the row id, step the statement, reset the statement, check for error... EASY
    sqlite3_bind_int(deletePlace, 1, rowid);    //I AM UNSURE IF SHOULD BE 1 OR 0
    int success = sqlite3_step(deletePlace);
    sqlite3_reset(deletePlace);
    if (success != SQLITE_DONE) {
        NSLog(@"ERROR: failed to delete item from categories table");
    }
}


//NOTE: these need to accept Hours objects.
//All the update methods.
//Update Monday Hours
+ (void)updateMondayHoursByName:(NSString *)name andNewHours:(Hours *)newHours{
    //bind name and hours to database string to statement
    sqlite3_bind_text(updateMondayHoursByNameStmt, 2, [name UTF8String], -1, SQLITE_TRANSIENT); //name bind
    sqlite3_bind_text(updateMondayHoursByNameStmt, 1, [[newHours hoursToDatabaseString] UTF8String], -1, SQLITE_TRANSIENT); //Hours
    
    //Check success, step, and reset
    int success = sqlite3_step(updateMondayHoursByNameStmt);
    sqlite3_reset(updateMondayHoursByNameStmt);
    if (success != SQLITE_DONE) {
        NSLog(@"ERROR: failed to update Monday Hours By Name item");
    }
}
//Update Tuesday Hours
+ (void)updateTuesdayHoursByName:(NSString *)name andNewHours:(Hours *)newHours{
    //bind name and hours to database string to statement
    sqlite3_bind_text(updateTuesdayHoursByNameStmt, 2, [name UTF8String], -1, SQLITE_TRANSIENT); //name bind
    sqlite3_bind_text(updateTuesdayHoursByNameStmt, 1, [[newHours hoursToDatabaseString] UTF8String], -1, SQLITE_TRANSIENT); //Hours
    
    //Check success, step, and reset
    int success = sqlite3_step(updateTuesdayHoursByNameStmt);
    sqlite3_reset(updateTuesdayHoursByNameStmt);
    if (success != SQLITE_DONE) {
        NSLog(@"ERROR: failed to update Tuesday Hours By Name item");
    }
}
//Update Wednesday Hours
+ (void)updateWednesdayHoursByName:(NSString *)name andNewHours:(Hours *)newHours{
    //bind name and hours to database string to statement
    sqlite3_bind_text(updateWednesdayHoursByNameStmt, 2, [name UTF8String], -1, SQLITE_TRANSIENT); //name bind
    sqlite3_bind_text(updateWednesdayHoursByNameStmt, 1, [[newHours hoursToDatabaseString] UTF8String], -1, SQLITE_TRANSIENT); //Hours
    
    //Check success, step, and reset
    int success = sqlite3_step(updateWednesdayHoursByNameStmt);
    sqlite3_reset(updateWednesdayHoursByNameStmt);
    if (success != SQLITE_DONE) {
        NSLog(@"ERROR: failed to update Wednesday Hours By Name item");
    }
}
//Update Thursday Hours
+ (void)updateThursdayHoursByName:(NSString *)name andNewHours:(Hours *)newHours{
    //bind name and hours to database string to statement
    sqlite3_bind_text(updateThursdayHoursByNameStmt, 2, [name UTF8String], -1, SQLITE_TRANSIENT); //name bind
    sqlite3_bind_text(updateThursdayHoursByNameStmt, 1, [[newHours hoursToDatabaseString] UTF8String], -1, SQLITE_TRANSIENT); //Hours
    
    //Check success, step, and reset
    int success = sqlite3_step(updateThursdayHoursByNameStmt);
    sqlite3_reset(updateThursdayHoursByNameStmt);
    if (success != SQLITE_DONE) {
        NSLog(@"ERROR: failed to update Thursday Hours By Name item");
    }
}
//Update Friday Hours
+ (void)updateFridayHoursByName:(NSString *)name andNewHours:(Hours *)newHours{
    //bind name and hours to database string to statement
    sqlite3_bind_text(updateFridayHoursByNameStmt, 2, [name UTF8String], -1, SQLITE_TRANSIENT); //name bind
    sqlite3_bind_text(updateFridayHoursByNameStmt, 1, [[newHours hoursToDatabaseString] UTF8String], -1, SQLITE_TRANSIENT); //Hours
    
    //Check success, step, and reset
    int success = sqlite3_step(updateFridayHoursByNameStmt);
    sqlite3_reset(updateFridayHoursByNameStmt);
    if (success != SQLITE_DONE) {
        NSLog(@"ERROR: failed to update Friday Hours By Name item");
    }
}
//Update Saturday Hours
+ (void)updateSaturdayHoursByName:(NSString *)name andNewHours:(Hours *)newHours{
    //bind name and hours to database string to statement
    sqlite3_bind_text(updateSaturdayHoursByNameStmt, 2, [name UTF8String], -1, SQLITE_TRANSIENT); //name bind
    sqlite3_bind_text(updateSaturdayHoursByNameStmt, 1, [[newHours hoursToDatabaseString] UTF8String], -1, SQLITE_TRANSIENT); //Hours
    
    //Check success, step, and reset
    int success = sqlite3_step(updateSaturdayHoursByNameStmt);
    sqlite3_reset(updateSaturdayHoursByNameStmt);
    if (success != SQLITE_DONE) {
        NSLog(@"ERROR: failed to update Saturday Hours By Name item");
    }
}
//Update Sunday Hours
+ (void)updateSundayHoursByName:(NSString *)name andNewHours:(Hours *)newHours{
    //bind name and hours to database string to statement
    sqlite3_bind_text(updateSundayHoursByNameStmt, 2, [name UTF8String], -1, SQLITE_TRANSIENT); //name bind
    sqlite3_bind_text(updateSundayHoursByNameStmt, 1, [[newHours hoursToDatabaseString] UTF8String], -1, SQLITE_TRANSIENT); //Hours
    
    //Check success, step, and reset
    int success = sqlite3_step(updateSundayHoursByNameStmt);
    sqlite3_reset(updateSundayHoursByNameStmt);
    if (success != SQLITE_DONE) {
        NSLog(@"ERROR: failed to update Sunday Hours By Name item");
    }
}


//Completely empty the database. Please do not call accidentally.
+ (void)emptyDatabase{
    sqlite3_step(emptyPlacesTable);
    sqlite3_step(emptyCategories);
}

//Drop the tables in the database to rebuilt.
+ (void)dropTables{
    sqlite3_step(dropTableCategories);
    sqlite3_step(dropTablePlaces);
}

//Cleanup Function
+ (void)cleanUpDatabaseForQuit
{
    // finalize frees the compiled statements, close closes the database connection
    sqlite3_finalize(createPlaceTable);
    sqlite3_finalize(fetchPlaces);
    sqlite3_finalize(insertPlace);
    sqlite3_finalize(deletePlace);
    sqlite3_finalize(emptyPlacesTable);
    sqlite3_finalize(dropTablePlaces);
    
    sqlite3_finalize(createCatTable);
    sqlite3_finalize(deleteCat);
    sqlite3_finalize(insertCat);
    sqlite3_finalize(emptyCategories);
    sqlite3_finalize(dropTableCategories);
    
    sqlite3_finalize(updateMondayHoursByNameStmt);
    sqlite3_finalize(updateTuesdayHoursByNameStmt);
    sqlite3_finalize(updateWednesdayHoursByNameStmt);
    sqlite3_finalize(updateThursdayHoursByNameStmt);
    sqlite3_finalize(updateFridayHoursByNameStmt);
    sqlite3_finalize(updateSaturdayHoursByNameStmt);
    sqlite3_finalize(updateSundayHoursByNameStmt);
    
    sqlite3_finalize(selectNamePlaces);
    sqlite3_finalize(selectBroadCategoryCat);
    sqlite3_finalize(selectSpecificCategoryCat);
    
    sqlite3_close(db);
}






@end
