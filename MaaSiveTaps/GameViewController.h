//
//  GameViewController.h
//  MaaSiveTaps
//
//  Created by Collin Ruffenach on 8/27/11.
//  Copyright 2011 ELC Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameViewController : UIViewController <UIAlertViewDelegate>

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) IBOutlet UIView *tapView;
@property (nonatomic, retain) IBOutlet UILabel *remainingTimeLabel;
@property (nonatomic, retain) IBOutlet UILabel *totalLabel;
@property (nonatomic, retain) IBOutlet UITextField *nameTextField;
@property (nonatomic, retain) UIAlertView *scoreAlert;
@property (nonatomic, retain) NSTimer *countdownTimer;
@property (nonatomic, assign) NSUInteger tapCount;
@property (nonatomic, assign) NSUInteger remainingTime;

@end
