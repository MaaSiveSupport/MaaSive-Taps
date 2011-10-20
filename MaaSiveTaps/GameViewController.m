//
//  GameViewController.m
//  MaaSiveTaps
//
//  Created by Collin Ruffenach on 8/27/11.
//  Copyright 2011 ELC Technologies. All rights reserved.
//

#import "GameViewController.h"
#import "RemoteScore.h"
#import "Score.h"

#define kNameErrorAlertViewTitle @"Name Error"
#define kSaveScoreAlertViewTitle @"Save Your Score"

@implementation GameViewController

@synthesize managedObjectContext = managedObjectContext_;
@synthesize tapView = tapView_;
@synthesize remainingTimeLabel = remainingTimeLabel_;
@synthesize totalLabel = totalLabel_;
@synthesize nameTextField = nameTextField_;
@synthesize scoreAlert = scoreAlert_;
@synthesize countdownTimer = countdownTimer_;
@synthesize tapCount = tapCount_;
@synthesize remainingTime = remainingTime_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
	if (self) {
    
		self.navigationItem.title = @"Tap!";
		
		self.tapCount = 0;
		
		self.remainingTime = 10;
		self.remainingTimeLabel.text = [NSString stringWithFormat:@"Time Remaining: %d", self.remainingTime];
		
		self.scoreAlert = [[UIAlertView alloc] initWithTitle:kSaveScoreAlertViewTitle
													 message:@"Blank Message"
													delegate:self
										   cancelButtonTitle:@"Cancel"
										   otherButtonTitles:@"Save", nil];
		self.nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 45.0, 260.0, 25.0)];
		self.nameTextField.placeholder = @"Enter name here";
		[self.nameTextField setBackgroundColor:[UIColor whiteColor]];
		[self.scoreAlert addSubview:self.nameTextField];
		
		self.countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1
															   target:self
															 selector:@selector(tick)
															 userInfo:nil
															  repeats:YES];
		[self.countdownTimer fire];		
    }
	
    return self;
}

-(void)tick {

	self.remainingTime--;
	self.remainingTimeLabel.text = [NSString stringWithFormat:@"Time Remaining: %d", self.remainingTime];
	
	if(self.remainingTime == 0) {	
		
		NSLog(@"Done. Final Score: %d", self.tapCount);
		[self.countdownTimer invalidate];
	
		[self.scoreAlert performSelectorOnMainThread:@selector(show) 
										  withObject:nil
									   waitUntilDone:YES];
	}
}

-(void)tapped:(UITapGestureRecognizer*)tapGestureRecognizer {

	self.tapCount++;
	self.totalLabel.text = [NSString stringWithFormat:@"Total: %d", self.tapCount];
}

#pragma mark - UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	NSString *alertTitle = alertView.title;
	
	if([alertTitle isEqualToString:kNameErrorAlertViewTitle]) {
	
		[self.scoreAlert show];
	}
	
	else if([alertTitle isEqualToString:kSaveScoreAlertViewTitle]) {
		
		if(buttonIndex == 1) {
		
			NSString *name = self.nameTextField.text;
			
			if(!name || [[name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
			
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kNameErrorAlertViewTitle
																message:@"You must enter a valid name or cancel"
															   delegate:self
													  cancelButtonTitle:@"Ok"
													  otherButtonTitles:nil];
				[alert show];	
				
				return;
			}
			
			Score *score = [NSEntityDescription insertNewObjectForEntityForName:@"Score"
														 inManagedObjectContext:self.managedObjectContext];
			[score setScore:[NSNumber numberWithInt:self.tapCount]];
			[score setName:self.nameTextField.text];		
			
			RemoteScore *remoteScore = [[RemoteScore alloc] initRemoteScoreWithScore:score];
			[remoteScore saveRemoteWithCachedResults:YES 
                                     completionBlock:^(BOOL saved, NSError *error) {
                                         if(saved) {
							
                                             [score setCreated_at:remoteScore.created_at];
                                             NSLog(@"Remote score saved to MaaSive");
                                             [self.navigationController performSelectorOnMainThread:@selector(popViewControllerAnimated:)
                                                                                         withObject:[NSNumber numberWithBool:YES]
                                                                                      waitUntilDone:NO];
                                         }
				
                                         else {
					
                                             NSLog(@"Error saving Remote Score: %@\n User Info: %@", [error localizedDescription], [error userInfo]);
                                         }
                                     }];
		}
		
		else {
		
			[self.navigationController performSelectorOnMainThread:@selector(popViewControllerAnimated:)
														withObject:[NSNumber numberWithBool:YES]
													 waitUntilDone:NO];
		}
	}
}

#pragma mark - IBActions

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self 
																				 action:@selector(tapped:)];
	[tapGesture setNumberOfTapsRequired:1];
	[tapGesture setNumberOfTouchesRequired:1];
	[self.tapView addGestureRecognizer:tapGesture];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Memory Management

-(void)dealloc {

	[managedObjectContext_ release];
	[tapView_ release];
	[remainingTimeLabel_ release];
	[totalLabel_ release];
	[nameTextField_ release];
	[countdownTimer_ release];
	[super dealloc];
}

@end
