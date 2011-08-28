//
//  RootViewController.h
//  MaaSiveTaps
//
//  Created by Collin Ruffenach on 8/27/11.
//  Copyright 2011 ELC Technologies. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

-(IBAction)play:(id)sender;
-(IBAction)highScores:(id)sender;

@end