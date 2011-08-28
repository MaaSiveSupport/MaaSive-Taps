//
//  HighScoreViewController.m
//  MaaSiveTaps
//
//  Created by Collin Ruffenach on 8/27/11.
//  Copyright 2011 ELC Technologies. All rights reserved.
//

#import "HighScoreViewController.h"
#import "RemoteScore.h"
#import "Score.h"

@implementation HighScoreViewController

@synthesize managedObjectContext = managedObjectContext_;
@synthesize scores = scores_; 

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.navigationItem.title = @"High Scores";
	
	[RemoteScore findRemoteWithQuery:[NSDictionary dictionary]
						cacheResults:YES 
					 completionBlock:^(NSArray *objects, NSError *error) {
						 
						 [objects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
							 
							 RemoteScore *score = (RemoteScore*)obj;
							 
							 NSFetchRequest *existingScoreRequest = [[NSFetchRequest alloc] init];
							 [existingScoreRequest setEntity:[NSEntityDescription entityForName:@"Score" 
																		 inManagedObjectContext:self.managedObjectContext]];
							 [existingScoreRequest setPredicate:[NSPredicate predicateWithFormat:@"created_at == %@ AND name == %@ AND score == %@", score.created_at, score.name, score.score]];
							 [existingScoreRequest setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"score" ascending:NO]]];
							 NSError *existingScoreFetchError = nil;
							 NSUInteger scoreCount = [self.managedObjectContext countForFetchRequest:existingScoreRequest 
																							   error:&existingScoreFetchError];
							 [existingScoreRequest release];
							 
							 if(scoreCount == 0) {
							 
								 Score *newScore = [NSEntityDescription insertNewObjectForEntityForName:@"Score"
																				 inManagedObjectContext:self.managedObjectContext];
								 [newScore setScore:score.score];
								 [newScore setName:score.name];							
								 [newScore setCreated_at:score.created_at];
							 }
						 }];
						 
						 NSError *saveError = nil;
						 [self.managedObjectContext save:&saveError];
						 
						 NSFetchRequest *scoreFetchRequest = [[NSFetchRequest alloc] init];
						 [scoreFetchRequest setEntity:[NSEntityDescription entityForName:@"Score" 
																  inManagedObjectContext:self.managedObjectContext]];
						 [scoreFetchRequest setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"score" ascending:NO]]];
						 NSError *scoreFetchError = nil;
						 self.scores = [self.managedObjectContext executeFetchRequest:scoreFetchRequest 
																				error:&scoreFetchError];
						 
						 [self.tableView performSelectorOnMainThread:@selector(reloadData) 
														  withObject:nil
													   waitUntilDone:NO];
					 }];
	
	NSFetchRequest *scoreFetchRequest = [[NSFetchRequest alloc] init];
	[scoreFetchRequest setEntity:[NSEntityDescription entityForName:@"Score" 
											 inManagedObjectContext:self.managedObjectContext]];
	
	NSError *scoreFetchError = nil;
	self.scores = [self.managedObjectContext executeFetchRequest:scoreFetchRequest 
														   error:&scoreFetchError];
	
	[self.tableView reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.scores count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
	
	Score *score = [self.scores objectAtIndex:indexPath.row];
	cell.textLabel.text = [NSString stringWithFormat:@"%@: %@", score.name, score.score];
	cell.detailTextLabel.text = [[score created_at] descriptionWithLocale:[NSLocale currentLocale]];

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

@end
