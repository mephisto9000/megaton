//
//  CategoryDataLoader.m
//  qzalog
//
//  Created by Mus Bai on 13.11.16.
//  Copyright © 2016 Mus Bai. All rights reserved.
//

#import "CategoryDataLoader.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Category.h"
#import "MeetupCommunicatorDelegate.h"

@interface CategoryDataLoader() <MeetupCommunicatorDelegate>
    @property(nonatomic, retain) NSDictionary *jsonArray;
@end

@implementation CategoryDataLoader


//call this method
-(void) loadCategoryData
{
    
    self.catData = [NSMutableDictionary new];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSString *urlString = [NSString stringWithFormat:@"http://qzalog.kz/_mobile_category"];
    
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


//распарсиваем прилетевший json
-(void) receivedGroupsJSON:(NSData *)objectNotation
{
    NSLog(@"here somewhere?");
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error: nil];
    
    
    if (![json.allKeys containsObject:@"categories"])
    {
        [self.delegate categoryLoadError];
        return;
    }
        //self fetchingGroupsFailedWithError:[NSError errorW]]
        
    
    NSArray* arr = (NSArray* ) [json objectForKey:@"categories"];
    
    for (NSDictionary *cat in arr)
    {
        
        int catId = [[cat objectForKey:@"id"] integerValue];
        NSString *title =(NSString * )[cat objectForKey:@"title"];
        int amount = [[cat objectForKey:@"amount"] integerValue];
        
        
        Category *category = [Category new];
        
        [category setCatId:catId];
        [category setTitle:title];
        [category setAmount:amount];
        
        [self.catData setObject:category forKey:[NSNumber numberWithInteger:catId] ];
        
        
    }
    
    //уведомляем контроллер что данны можно забирать
    [self.delegate categoryLoadComplete];
}

//ошибка
-(void) fetchingGroupsFailedWithError:(NSError *)error
{
    NSLog(@"error while fetching json: %@", [error.userInfo description]);
}

@end
