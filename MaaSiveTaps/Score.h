//
//  Score.h
//  MaaSiveTaps
//
//  Created by Collin Ruffenach on 8/27/11.
//  Copyright (c) 2011 ELC Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Score : NSManagedObject {
@private
}
@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * score;

@end
