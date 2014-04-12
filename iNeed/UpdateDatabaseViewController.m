//
//  UpdateDatabaseViewController.m
//  iNeed
//
//  Created by jarthurcs on 4/2/14.
//  Copyright (c) 2014 121. All rights reserved.
//

#import "UpdateDatabaseViewController.h"
#import "PlaceDatabase.h"
#import "HighLevelViewController.h"

@interface UpdateDatabaseViewController ()

@end

@implementation UpdateDatabaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initNetworkCommunication];
    [self initTimeStamp];
    [self sendTimeStamp];
    [self updateTimeAndClose];
    
    
    
    
	// Do any additional setup after loading the view.
}

-(void)initTimeStamp
{
    //set the current time
    NSTimeInterval timeInt = [[NSDate date]timeIntervalSince1970];
    NSString *currTime = [NSString stringWithFormat: @"%f", timeInt];
    //format the current time into "TIME:<time>" in correct format for server
    self.currentTime = [@"TIME:" stringByAppendingString:currTime];
    NSLog(@"current time:");
    NSLog(self.currentTime, @"@%");
    
    //get the last update from memory
    self.lastUpdate = [[NSUserDefaults standardUserDefaults]objectForKey:@"lastUpdate"];
    
    //if the old time is nil:
    if (!self.lastUpdate){
        //create the correctly-formatted string
        self.lastUpdate = @"TIME:0";
    }
    //otherwise, the old time is the time we want to send to the server.

    
}

-(void)sendTimeStamp
{
	NSData *data = [[NSData alloc] initWithData:[self.lastUpdate dataUsingEncoding:NSASCIIStringEncoding]];
	[self.outputStream write:[data bytes] maxLength:[data length]];
}

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
}


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
            
            //Segue back, in view controllers, to the main screen
            //DO THIS
            [self unwindToMainMenu:nil];

            
            break;
            
		default:
			NSLog(@"Unknown event");
            }
}

-(void)updateTimeAndClose{
    //setting the "last updated" to the current time stamp
    [[NSUserDefaults standardUserDefaults]setObject:self.currentTime forKey:@"lastUpdate"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)unwindToMainMenu:(UIStoryboardSegue*)sender
{
    //I think there's something to this, as I have added it in storyboard and I think it should work
    //but I don't know what goes here
}

@end
