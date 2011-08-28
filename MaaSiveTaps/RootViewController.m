//
//  RootViewController.m
//  MaaSiveTaps
//
//  Created by Collin Ruffenach on 8/27/11.
//  Copyright 2011 ELC Technologies. All rights reserved.
//

#import "RootViewController.h"
#import "GameViewController.h"
#import "HighScoreViewController.h"

@implementation RootViewController

@synthesize managedObjectContext = managedObjectContext_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - IBActions

-(IBAction)play:(id)sender {

	GameViewController *gameController = [[GameViewController alloc] initWithNibName:@"GameViewController"
																			  bundle:[NSBundle mainBundle]];
	[gameController setManagedObjectContext:self.managedObjectContext];
	[self.navigationController pushViewController:gameController 
										 animated:YES];
}

-(IBAction)highScores:(id)sender {
	
	HighScoreViewController *highScoreController = [[HighScoreViewController alloc] initWithNibName:@"HighScoreViewController"
																						bundle:[NSBundle mainBundle]];
	[highScoreController setManagedObjectContext:self.managedObjectContext];
	[self.navigationController pushViewController:highScoreController 
										 animated:YES];
}

@end
