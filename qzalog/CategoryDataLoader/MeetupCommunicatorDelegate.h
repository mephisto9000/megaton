//
//  MeetupCommunicatorDelegate.h
//  qzalog
//
//  Created by Mus Bai on 19.11.16.
//  Copyright © 2016 Mus Bai. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MeetupCommunicatorDelegate <NSObject>

    -(void) receivedGroupsJSON:(NSData *) objectNotation;
    -(void) fetchingGroupsFailedWithError:(NSError *) error;

@end
