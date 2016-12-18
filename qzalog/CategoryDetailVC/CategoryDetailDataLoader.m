//
//  CategoryDetailDataLoader.m
//  qzalog
//
//  Created by Mus Bai on 19.11.16.
//  Copyright © 2016 Mus Bai. All rights reserved.
//

#import "CategoryDetailDataLoader.h"
//#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MeetupCommunicatorDelegate.h"
#import "DBManager.h"

@interface CategoryDetailDataLoader() <MeetupCommunicatorDelegate>
{
    NSMutableArray<CategoryDetail *> *dataList;
    int maxPage;
    
    int lastPage;
    int orderPrice;
}

@end

@implementation CategoryDetailDataLoader

@synthesize delegate;
@synthesize categoryId;
@synthesize searchUrl;


-(void) setPriceDesc
{
    orderPrice = 1;
    maxPage = -1;
    lastPage = 0;
    [dataList removeAllObjects];
}

-(void) setPriceAsc
{
    orderPrice = 2;
    maxPage = -1;
    lastPage = 0;
    [dataList removeAllObjects];
}

-(void) setDateDesc
{
    orderPrice = 0;
    maxPage = -1;
    lastPage = 0;
    [dataList removeAllObjects];
}


-(id) init{
    self = [super init];
    
    categoryId = @"46";
    
    
    self.catDetailData = [NSMutableDictionary new];
    
    dataList = [NSMutableArray new];
    
    maxPage = -1;
    lastPage = 0;
    
     orderPrice = 0;
    
    return self;
}


-(void) loadFromMap: (NSArray<NSString *>  *) objIds
{
    
    NSMutableString *request = [NSMutableString stringWithFormat:@"http://qzalog.kz/_mobile_selected_objects?"];
    
    for (int i = 0; i < [objIds count]; i++)
    {
        NSString *likedObj = [NSString stringWithFormat:@"%@", objIds[i] ];
        
        if (i > 0)
            [request appendString:@"&"];
        
        [request appendString:[NSString stringWithFormat:@"objects[%i]=%@", i, likedObj]];
    }
    
    
    NSURL *url = [NSURL URLWithString: request];
    
    NSLog(@"url == %@", request);
    
    
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            [self fetchingGroupsFailedWithError:error];
        } else {
            [self receivedGroupsJSON:data];
        }
    }];
    

    
}


-(void) loadFavorite
{
    DBManager *dbManager = [[DBManager alloc] initWithDatabaseFilename:@"qzalog.db"];
    
    NSString *query = @"select object_id from liked";
    
    NSArray *likedInfo = [[NSArray alloc] initWithArray:[dbManager loadDataFromDB:query]];
    
    
    if ([likedInfo count] == 0)
        return;
    
    NSMutableString *request = [NSMutableString stringWithFormat:@"http://qzalog.kz/_mobile_selected_objects?"];
    
    //category=31&objects[0]=42442499&objects[1]=42.....
    
    for (int i = 0; i < [likedInfo count] ;i++)
    {
        NSString *likedObj = [NSString stringWithFormat:@"%i", [[likedInfo[i] objectAtIndex:0] intValue] ];
        
        if (i > 0)
            [request appendString:@"&"];
        
        [request appendString:[NSString stringWithFormat:@"objects[%i]=%@", i, likedObj]];
        
    }
    
    
    
    NSURL *url = [NSURL URLWithString: request];
    
    NSLog(@"url == %@", request);
    
    
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            [self fetchingGroupsFailedWithError:error];
        } else {
            [self receivedGroupsJSON:data];
        }
    }];

    
    
    
    
    
}

-(NSString *) loadCategoryDetailData
{
    
    lastPage ++;
    
    //if (lastPage > maxPage)
    //{
    //    maxPage = lastPage;
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSMutableString *urlString = nil;
    
    if (self.searchUrl == nil)
        urlString = [NSMutableString stringWithFormat:@"http://qzalog.kz/_mobile_objects?category=%@&ObjectsSearch[region_id]=&page=%i", categoryId, lastPage];
    else
        urlString = [NSMutableString stringWithFormat:@"%@&page=%i", self.searchUrl, lastPage];
    
    
    if (orderPrice==1)
        [urlString appendString:@"&sort=cost_out"];
    
    if (orderPrice == 2)
        [urlString appendString:@"&sort=-cost_out"];
    
    
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
    
    return urlString;
   
    
}




-(void) receivedGroupsJSON:(NSData *)objectNotation
{
    NSLog(@"here somewhere?");
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error: nil];
    
    if (![json.allKeys containsObject:@"objects"])
    {
        [delegate categoryDetailLoadFailed];
        return;
    }
    
    NSArray* arr = (NSArray* ) [json objectForKey:@"objects"];
    
    if  ([arr count] == 0)
    {
        [delegate categoryDetailLoadFailed];
        return;
    }
    
    int pos = 0;
    for (NSDictionary *obj in arr)
    {
        pos ++;
        
        NSLog(@"here somewhere?");
        NSString *objId = [NSString stringWithFormat:@"%i", [[obj objectForKey:@"id"] intValue] ];
        NSString *title =(NSString * )[obj objectForKey:@"title"];
        NSString *image = (NSString*) [obj objectForKey:@"image"];
        NSString *region = (NSString *) [obj objectForKey:@"region"];
        NSString *price = (NSString*) [obj objectForKey:@"price"];
        NSString *discount = (NSString*) [obj objectForKey:@"discount"];
        NSString *info = (NSString *) [obj objectForKey:@"info"];
        
        
        //int amount = [[cat objectForKey:@"amount"] integerValue];
        
        NSLog(@"objId == %@", objId);
        NSLog(@"title == %@", title);
        NSLog(@"image == %@", image);
        NSLog(@"region == %@", region);
        NSLog(@"price == %@", price);
        NSLog(@"discount == %@", discount);
        NSLog(@"info == %@", info);
        
        
        CategoryDetail *cd = [CategoryDetail new];
        
        
        [cd setPos:pos];
        [cd setCatDetId:objId];
        [cd setTitle:title];
        [cd setImage:image];
        [cd setRegion: region];
        [cd setPrice:price];
        [cd setDiscount:discount];
        [cd setInfo:info];
        
        [dataList addObject:cd];
        
        /*
        Category *category = [Category new];
        
        [category setCatId:catId];
        [category setTitle:title];
        [category setAmount:amount];
        
        [self.catData setObject:category forKey:[NSNumber numberWithInteger:catId] ];
        
        */
    }
    
    self.catDetailData = dataList;
    
    //[self.delegate categoryLoadComplete];
    
    [self.delegate categoryDetailLoadComplete];
}

-(void) fetchingGroupsFailedWithError:(NSError *)error
{
    NSLog(@"error while fetching json: %@", [error.userInfo description]);
}



@end
