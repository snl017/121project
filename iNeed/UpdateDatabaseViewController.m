//
//  UpdateDatabaseViewController.m
//  iNeed
//
//  Created by jarthurcs on 4/2/14.
//  Copyright (c) 2014 121. All rights reserved.
//

#import "UpdateDatabaseViewController.h"

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
        self.lastUpdate = @"TIME:nil";
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
                
                
                //IS THIS ENOUGH FOR A JSON? How much data are we sending?
                uint8_t buffer[1024];
                int len;
                
                while ([self.inputStream hasBytesAvailable]) {
                    len = [self.inputStream read:buffer maxLength:sizeof(buffer)];
                    if (len > 0) { //still have data to read in
                        //Convert to JSON
                        //Use JSON to update database
                        
                        //Able to collect a string message using the following code:
//                        NSString *output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
//                        if (nil != output) {
//                            NSLog(@"server said: %@", output);
//                        }
                    
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
            
            //Segue back!!!!!
            //DO THIS
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

@end
