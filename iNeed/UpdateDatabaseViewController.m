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
    NSLog(self.lastUpdate, @"@%");
    [self sendTimeStamp];
    
    
    //This will eventually be us setting the "last updated" to the current time stamp
    //[[NSUserDefaults standardUserDefaults]setObject:currentTime forKey:@"lastUpdate"];
    
	// Do any additional setup after loading the view.
}

-(void)initTimeStamp
{
    //set the current time
    //THIS NEEDS TO BE CHANGED
    //format the current time into "TIME:<time>" in correct format for server
    self.currentTime = @"current time";
    
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
