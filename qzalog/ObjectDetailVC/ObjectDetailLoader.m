//
//  ObjectDetailReader.m
//  qzalog
//
//  Created by Mus Bai on 27.11.16.
//  Copyright © 2016 Mus Bai. All rights reserved.
//

#import "ObjectDetailLoader.h"
#import  "ObjectDetail.h"
#import <UIKit/UIKit.h>

@implementation ObjectDetailLoader

@synthesize delegate;

-(void) loadData: (NSString *) objectId
{
 
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSString *urlString = [NSString stringWithFormat:@"http://qzalog.kz/_mobile_detail?object_id=%@", objectId ];
    
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



-(void) receivedGroupsJSON:(NSData *)objectNotation
{
    NSLog(@"here somewhere?");
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error: nil];
    
    
    //json
    for (id key in json) {
        NSLog(@"key: %@, value: %@ \n", key, [json objectForKey:key]);
    }
    
    NSDictionary* obj = (NSDictionary* ) [json objectForKey:@"object"];
    
    
    
        
        NSLog(@"here somewhere?");
        NSInteger objId =  [[obj objectForKey:@"id"] integerValue];
        NSString *title =(NSString * )[obj objectForKey:@"title"];
        NSString *complex = (NSString*) [obj objectForKey:@"complex"];
        NSString *address = (NSString *) [obj objectForKey:@"address"];
    
        NSString *dateCreated = (NSString *) [obj objectForKey:@"dateCreated"];
        NSString *price = (NSString*) [obj objectForKey:@"price"];
        NSString *discount = (NSString *) [obj objectForKey:@"discount"];
    
    
        //NSString *info = (NSString *) [obj objectForKey:@"info"];
        NSDictionary *phonesObj = [obj objectForKey:@"phones"];
        NSMutableArray<NSString *> *phones = [NSMutableArray <NSString *> new];
    
        for (id key in phonesObj)
        {
            [phones addObject: [phonesObj objectForKey:key]];
        }
    
    
        NSDictionary *imagesObj = [obj objectForKey:@"images"];
        NSMutableArray<DetailImage *> *images = [NSMutableArray <DetailImage *> new];
    
        for(id key in imagesObj)
        {
            DetailImage *image = [DetailImage new];
            [image setLittle: [((NSDictionary *)[imagesObj objectForKey:key]) objectForKey:@"little"]];
            [image setBig: [((NSDictionary *)[imagesObj objectForKey:key]) objectForKey:@"big"]];
            [image setImgId:[(NSString *) key intValue]];
            
            [images addObject:image];
        }
    
    images =  [[images sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        DetailImage *cat1 = obj1;
        DetailImage *cat2 = obj2;
        
        
        if (cat1.imgId < cat2.imgId) {
            return (NSComparisonResult) NSOrderedAscending;
        }
        else if (cat1.imgId > cat2.imgId)
        {
            return (NSComparisonResult) NSOrderedDescending;
        }
        
        
        return (NSComparisonResult) NSOrderedSame;
    }
                ] mutableCopy];
    
    
    
    
    
    
    
    
    
    
    
    
        NSDictionary *infoArrayObj = [obj objectForKey:@"infoArray"];
        NSMutableArray<DetailInfo *> *infoArray = [NSMutableArray<DetailInfo *> new];
    
        for (id key in infoArrayObj)
        {
            NSDictionary *infoTmp = (NSDictionary *) [infoArrayObj objectForKey:key];
            DetailInfo *detailInfo = [DetailInfo new];
            
            [detailInfo setTitle: [infoTmp objectForKey:@"title"]];
            [detailInfo setValue: [infoTmp objectForKey:@"value"]];
            [detailInfo setInfoId:[(NSString *) key intValue]];
            
            [infoArray addObject:detailInfo];
            
            
        }
    
    infoArray =  [[infoArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        DetailInfo *cat1 = obj1;
        DetailInfo *cat2 = obj2;
        
        
        if (cat1.infoId < cat2.infoId) {
            return (NSComparisonResult) NSOrderedAscending;
        }
        else if (cat1.infoId > cat2.infoId)
        {
            return (NSComparisonResult) NSOrderedDescending;
        }
        
        
        return (NSComparisonResult) NSOrderedSame;
    }
                ] mutableCopy];
    
    
    
    
    
    
        NSString *description = [obj objectForKey:@"description"];
        float coordX = [[obj objectForKey:@"coordX"] floatValue];
        float coordY = [[obj objectForKey:@"coordY"] floatValue];
        NSInteger zoom = [[obj objectForKey:@"zoom"] integerValue];
    
    
    
        ObjectDetail *od = [ObjectDetail new];
    [od setObjectId:objId];
    [od setTitle:title];
    [od setComplex:complex];
    [od setDateCreated:dateCreated];
    [od setAddress:address];
    [od setPrice:price];
    [od setDiscount:discount];
    [od setPhones:[phones copy]];
    [od setImages:[images copy]];
    [od setInfoArray:[infoArray copy] ];
    [od setDescription:description];
    [od setCoordX:coordX];
    [od setCoordY:coordY];
    [od setZoom:zoom];
    
    
    [self.delegate loadObjectDetailComplete:od];
}




-(void) fetchingGroupsFailedWithError:(NSError *)error
{
    NSLog(@"error while fetching json: %@", [error.userInfo description]);
}


@end
