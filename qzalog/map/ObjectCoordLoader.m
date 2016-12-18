//
//  ObjectCoordLoader.m
//  qzalog
//
//  Created by Mus Bai on 29.11.16.
//  Copyright © 2016 Mus Bai. All rights reserved.
//

#import "ObjectCoordLoader.h"
#import <UIKit/UIKit.h>
#import "ObjectCoord.h"
#import "UserData.h"

@implementation ObjectCoordLoader

/*
@synthesize  zoom;
@synthesize map_coord_x;
@synthesize map_coord_y;
*/

-(void) loadData //: (NSString *) categoryId
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSString *urlString = [NSString stringWithFormat:@"http://qzalog.kz/_mobile_objects?category=%@&map=1", [UserData categoryId]];
    
    //http://qzalog.kz/_mobile_objects?category=46&ObjectsSearch[region_id]=X&ObjectsSearch[cost][0]=XXX&ObjectsSearch[cost][1]=XXX&map=0&ObjectsProperties[XX][valueSearch]=XXX
    NSURL *url = [NSURL URLWithString: urlString];
    
    NSLog(@"url == %@", urlString);
    
    
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            [self fetchingGroupsFailedWithError:error];
        } else {
            [self receivedGroupsJSON:data];
        }
        
    }];
}


//-(void) loadDataForArray : (NSArray<NSString *> *) objIds
-(void) loadDataFromUrl : (NSString *) mapUrl;
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    
    NSLog(@"url == %@", mapUrl);
    
    
    NSURL *url = [NSURL URLWithString: mapUrl];
    
    
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            [self fetchingGroupsFailedWithError:error];
        } else {
            [self receivedGroupsJSON:data];
        }
        
    }];

}



-(void) fetchingGroupsFailedWithError:(NSError *)error
{
    NSLog(@"error while fetching json: %@", [error.userInfo description]);
}



-(void) receivedGroupsJSON:(NSData *)objectNotation
{
    
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error: nil];
    
    
    
    if (![json.allKeys containsObject:@"mapProperty"])
    {
        [self.delegate mapLoadFailed];
        return;
    }
        
    NSDictionary* mapProperty = (NSDictionary* ) [json objectForKey:@"mapProperty"];
    
    float map_coord_x = [[mapProperty objectForKey:@"coord_x"] floatValue];
    float map_coord_y = [[mapProperty objectForKey:@"coord_y"] floatValue];
    int zoom = [[mapProperty objectForKey:@"zoom"] intValue];
    
    
    if (![json.allKeys containsObject:@"objects"])
    {
        [self.delegate mapLoadFailed];
        return;
    }
    
    
    NSArray *objects = [json objectForKey:@"objects"];
    
    if ([objects count] == 0)
    {
        [self.delegate mapLoadFailed];
        return;
    }
    
    NSMutableArray<ObjectCoord *> *objArray = [NSMutableArray<ObjectCoord *> new];
    
    for (id object in objects)
    {
        NSDictionary *oj = (NSDictionary *) object;
        
        ObjectCoord *objectCoord = [ObjectCoord new];
        
        [objectCoord setObjId:[oj objectForKey:@"id"] ];
        [objectCoord setCoord_x:[[oj objectForKey:@"coord_x"] floatValue]];
        [objectCoord setCoord_y:[[oj objectForKey:@"coord_y"] floatValue]];
        
        [objArray addObject:objectCoord];
    }
    
    
    [self.delegate mapLoadComplete:[objArray copy] map_zoom:zoom map_coord_x:map_coord_x map_coord_y:map_coord_y];
    
    
    
    
}



@end
