//
//  PlaceDatabase.h
//  iNeed
//
//  Created by Anna Turner on 2/17/14.
//  Copyright (c) 2014 Anna Turner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Place.h"
#import "Constants.h"
#import "Hours.h"
#import <sqlite3.h>

@interface PlaceDatabase : NSObject



//To create database and initialize it
+ (void)createEditableCopyOfDatabaseIfNeeded;
+ (void)initDatabase;

//To save an item with info
+ (void)saveItemWithPlace:(Place *)place andSpecificCategory:(NSString *)specific andBroadCategory:(NSString*)broad;

+ (void)saveItemWithPlace:(Place *)place;
+ (void)savePlace:(NSString *)name withSpecificCategory:(NSString *)specific andBroadCategory:(NSString*)broad;

+ (void)saveItemWithSchool:(NSString *)school andName:(NSString *)name andLocation:(NSString *)location andMondayHours:(NSString *)monday andTuesdayHours:(NSString *)tuesday andWednesdayHours:(NSString *)wednesday andThursdayHours:(NSString *)thursday andFridayHours:(NSString *)friday andSaturdayHours:(NSString *)saturday andSundayHours:(NSString *)sunday andPhoneString:(NSString *)phone andEmailString:(NSString *)email andLinkString:(NSString *)webLink andExtraInfo:(NSString *)extraInfo;

//To delete an item, to clean up database
+ (void)deletePlace:(int)rowid;
+ (void)deletePlaceByName:(NSString *)name;
+ (void)deleteCategoryTableRow:(int)rowid;
+ (void)cleanUpDatabaseForQuit;
+ (void)emptyDatabase;
+ (void)dropTables;


//Fetch/select methods returning NSMutableArrays of Places
+ (NSMutableArray *)fetchAllPlaces;
+ (NSMutableArray *)fetchPlacesByName:(NSString *)name;
+ (NSMutableArray *)fetchPlacesByBroadCategory:(NSString *)broadCategory;
+ (NSMutableArray *)fetchPlacesBySpecificCategory:(NSString *)specificCategory;

//Methods to query the categories table
+(NSMutableArray *) fetchNamesbySpecific:(NSString *)specific;
+(NSMutableArray *) fetchNamesbyBroad:(NSString *)broad;


//Updating Hours methods
+ (void)updateMondayHoursByName:(NSString *)name andNewHours:(Hours *)newHours;
+ (void)updateTuesdayHoursByName:(NSString *)name andNewHours:(Hours *)newHours;
+ (void)updateWednesdayHoursByName:(NSString *)name andNewHours:(Hours *)newHours;
+ (void)updateThursdayHoursByName:(NSString *)name andNewHours:(Hours *)newHours;
+ (void)updateFridayHoursByName:(NSString *)name andNewHours:(Hours *)newHours;
+ (void)updateSaturdayHoursByName:(NSString *)name andNewHours:(Hours *)newHours;
+ (void)updateSundayHoursByName:(NSString *)name andNewHours:(Hours *)newHours;



@end
