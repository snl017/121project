//
//  initDatabaseFromServer.m
//  iNeed
//
//  Created by Shannon Lubetich on 4/20/14.
//  Copyright (c) 2014 121. All rights reserved.
//

#import "initDatabaseFromServer.h"
#import "PlaceDatabase.h"

@implementation initDatabaseFromServer


//copied and amended from updateDatabaseViewController


//write time stamp from phone to server
//is SPECIAL code so that server will send ALL of the database back
//right now, that special code is "-1", but I don't actually know if this works
-(void)sendTimeStamp
{
    NSData *data = [[NSData alloc] initWithData:[@"TIME: -1" dataUsingEncoding:NSASCIIStringEncoding]];
    [self.outputStream write:[data bytes] maxLength:[data length]];
}

//create streams
//init with local host on port 80 (for mock server right now)
//open and run streams
- (void)initNetworkCommunication {
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)@"localhost", 80, &readStream, &writeStream);
    self.inputStream = (__bridge NSInputStream *)readStream;
    self.outputStream = (__bridge NSOutputStream *)writeStream;
    
    [self.inputStream setDelegate:self];
    [self.outputStream setDelegate:self];
    [self.inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [self.outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [self.inputStream open];
    [self.outputStream open];
    
    NSLog(@"I AM DOING SOMETHING ON LAUNCH");
}

//handles communication event with server.
//if receiving data, will be rows to update, unpackage and update server on phone
//if end event received pop view controller and return to home screen
- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent {
    switch (streamEvent) {
            
        case NSStreamEventOpenCompleted:
            NSLog(@"Stream opened");
            break;
            
        case NSStreamEventHasBytesAvailable:
            //get the data! Put it in the right place!
            //read bytes from the stream
            //collect them in a buffer
            //transform the buffer into a string (JSON?)
            //update our database using the JSON
            
            if (theStream == self.inputStream) {
                
                NSError *error = nil;
                id object = [NSJSONSerialization JSONObjectWithStream:self.inputStream options:kNilOptions error:&error];
                
                if(error) {
                    /* this means JSON obj returnedData was malformed, so do something here */
                    NSLog(@"ERROR");
                }
                
                //just check to make sure is returning an array. it should be, but just in case,
                //we initialize it to read as an id, and then check to see if it's an NSArray and then assign it as an NSArray
                if([object isKindOfClass: [NSArray class]]) {
                    NSArray *results = object;
                    for(NSArray *row in results){
                        //This is where we now use these rows to change the database on the phone, using update statements.
                        //using such methods as... (void)updateMondayHoursByName:(NSString *)name andNewHours:(Hours *)newHours
                        [PlaceDatabase updateMondayHoursByName:row[2] andNewHours: [[Hours alloc] initWithOneString:row[4]]];
                        [PlaceDatabase updateTuesdayHoursByName:row[2] andNewHours: [[Hours alloc] initWithOneString:row[5]]];
                        [PlaceDatabase updateWednesdayHoursByName:row[2] andNewHours: [[Hours alloc] initWithOneString:row[6]]];
                        [PlaceDatabase updateThursdayHoursByName:row[2] andNewHours: [[Hours alloc] initWithOneString:row[7]]];
                        [PlaceDatabase updateFridayHoursByName:row[2] andNewHours: [[Hours alloc] initWithOneString:row[8]]];
                        [PlaceDatabase updateSaturdayHoursByName:row[2] andNewHours: [[Hours alloc] initWithOneString:row[9]]];
                        [PlaceDatabase updateSundayHoursByName:row[2] andNewHours: [[Hours alloc] initWithOneString:row[10]]];
                    }
                    
                }
            }
            break;
            
        case NSStreamEventErrorOccurred:
            NSLog(@"Can not connect to the host!");
            break;
            
            //The update is finished!
        case NSStreamEventEndEncountered:
            [self.inputStream close];
            [self.outputStream close];
            [self.inputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            [self.outputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            
            
            break;
            
        default:
            NSLog(@"Unknown event");
    }
}

//setting the "last updated" for the row to the current time stamp (because it has just been updated)
-(void)updateTimeAndClose{
    //set the current time
    NSTimeInterval timeInt = [[NSDate date]timeIntervalSince1970];
    NSString *currTime = [NSString stringWithFormat: @"%f", timeInt];
    //format the current time into "TIME:<time>" in correct format for server
    NSString *currentTime = [@"TIME:" stringByAppendingString:currTime];
    [[NSUserDefaults standardUserDefaults]setObject:currentTime forKey:@"lastUpdate"];
}

//- (void)didReceiveMemoryWarning
//{
//    [UIViewController didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}





@end
