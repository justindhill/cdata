//
//  Event.h
//  CoreData
//
//  Created by Justin Hill on 6/7/14.
//  Copyright (c) 2014 Justin Hill. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Event : NSManagedObject

@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;

@end
