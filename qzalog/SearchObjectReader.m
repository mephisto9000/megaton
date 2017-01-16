//
//  SearchObjectReader.m
//  qzalog
//
//  Created by Mus Bai on 21.11.16.
//  Copyright © 2016 Mus Bai. All rights reserved.
//

#import "SearchObjectReader.h"
#import "DBManager.h"
#import "UserData.h"

@interface SearchObjectReader()
{
    DBManager *dbManager;
    
    NSMutableArray *tmpObjects;
    
    
    //db fields
    NSInteger indexOfId;
    NSInteger indexOfName;
    NSInteger indexOfCategoryId;
    NSInteger indexOfForm;
}
@end


@implementation SearchObjectReader

@synthesize delegate;



-(id) init
{
    self = [super init];
    
    
     
    
    
    return self;
}


-(void) loadData: (int) category_id
{
    
    dbManager = [[DBManager alloc] initWithDatabaseFilename: [UserData dbName]];
    
    
    NSString *query = [NSString stringWithFormat:@"select form from categories where category_id = %i", category_id];
    
    // Get the results.
    if(tmpObjects != nil)
        tmpObjects = nil;

    
    NSLog(@"sql == %@", query);
    
    tmpObjects = [[NSArray alloc] initWithObjects:[dbManager loadDataFromDB:query], nil];
    
    self.searchObjects = [NSMutableArray new];
    
    for (int i = 0; i < [dbManager.arrColumnNames count]; i++)
    {
        NSLog(@"column name == %@", dbManager.arrColumnNames[i]);
    }
    
    // Reload the table view.
    indexOfId           = [dbManager.arrColumnNames indexOfObject:@"id"];
    indexOfName         = [dbManager.arrColumnNames indexOfObject:@"name"];
    indexOfCategoryId   = [dbManager.arrColumnNames indexOfObject:@"category_id"];
    indexOfForm         = [dbManager.arrColumnNames indexOfObject:@"form"];
    
    
    NSLog(@"id == %i", (int) indexOfId );
    NSLog(@"name == %i", (int) indexOfName );
    NSLog(@"category_id == %i", (int) indexOfCategoryId );
    NSLog(@"form == %i", (int) indexOfForm );
    
    NSArray *form = [tmpObjects objectAtIndex:0];
    
    NSString *convertedString = [[form[0] objectAtIndex:0]  mutableCopy];
    
    CFStringRef transform = CFSTR("Any-Hex/Java");
    CFStringTransform((__bridge CFMutableStringRef)convertedString, NULL, transform, YES);
    
    NSLog(@"convertedString: %@", convertedString);


    [self parseObjectJSON:[convertedString dataUsingEncoding:NSUTF8StringEncoding]];
    
}


-(void) parseObjectJSON:(NSData *)objectNotation
{

    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error: nil];
    
 
    NSDictionary* arr = (NSDictionary* ) [json objectForKey:@"fields"];

    int pos = 0;

    if (![arr isKindOfClass:[NSArray class]])

    for (id key in arr)
    {
//        NSLog(@"first case");
        
        
        NSDictionary *obj = (NSDictionary* ) [arr objectForKey:key];

        pos ++;

        SearchObject *sObject = [SearchObject new];

        NSString *title = (NSString*)[obj objectForKey:@"title"];
        NSString *units =(NSString * )[obj objectForKey:@"unit_of_measure"];
        NSString *placeholder = (NSString*) [obj objectForKey:@"placeholder"];
        NSString *name = [(NSString *) [obj objectForKey:@"name"] stringByTrimmingCharactersInSet:
        [NSCharacterSet newlineCharacterSet]];
        NSString *name2 = [(NSString*) [obj objectForKey:@"name2"] stringByTrimmingCharactersInSet:
                           [NSCharacterSet newlineCharacterSet]];
        int main = [[obj objectForKey:@"main"] intValue];
        int type  = [[obj objectForKey:@"type"] intValue];
        int position = [[obj objectForKey:@"position"] intValue];
        
        if (type == 0)
            continue;
        
        NSMutableArray<ObjectValue *> *values = [NSMutableArray new];
        if (type == 2)
        {
            NSDictionary *jsonValues = [obj objectForKey:@"values"];

            for (id key in [jsonValues allKeys])
            {
                ObjectValue *ov = [ObjectValue new];

                NSDictionary *objValue = [jsonValues objectForKey:key];

                [ov setValId:[objValue objectForKey:@"id"]];
                [ov setName:[objValue objectForKey:@"name"]];
                
                
                [ov setOrdId:[(NSString *) key intValue] ];
                
                
                
                [values addObject:ov];

            }
            
        }
        
        values =  [[values sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            ObjectValue *cat1 = obj1;
            ObjectValue *cat2 = obj2;
            
            
            if (cat1.ordId < cat2.ordId) {
                return (NSComparisonResult) NSOrderedAscending;
            }
            else if (cat1.ordId > cat2.ordId)
            {
                return (NSComparisonResult) NSOrderedDescending;
            }
            
            
            return (NSComparisonResult) NSOrderedSame;
        }
        ] mutableCopy];
        
        
        
        [sObject setTitle:title];
        [sObject setUnits:units];
        [sObject setPlaceholder:placeholder];
        [sObject setSavedPlaceholder:placeholder];
        [sObject setName:name];
        [sObject setName2:name2];
        [sObject setMain:main];
        [sObject setType:type];
        [sObject setPosition:position];
        
        [sObject setValues:values];
            
            
      
        
        NSLog(@"title == %@", title);
        NSLog(@"units == %@", units);
        NSLog(@"placeholder == %@", placeholder);
        NSLog(@"name == %@", name);
        NSLog(@"name2 == %@", name2);
        NSLog(@"main == %i", main);
        NSLog(@"type == %i", type);
        NSLog(@"position == %i", position);
        
        [self.searchObjects addObject:sObject];
    }
    else
    {
        
        NSLog(@"second case");
        
        NSDictionary *obj = [((NSArray *) arr) objectAtIndex:0];
        
        for (id key in obj) {
            NSLog(@"key: %@, value: %@ \n", key, [obj objectForKey:key]);
        }
        
        pos ++;
        
        SearchObject *sObject = [SearchObject new];
        
        NSLog(@"here somewhere?");
        NSString *title = (NSString*)[obj objectForKey:@"title"];
        NSString *units =(NSString * )[obj objectForKey:@"unit_of_measure"];
        NSString *placeholder = (NSString*) [obj objectForKey:@"placeholder"];
        NSString *name = [(NSString *) [obj objectForKey:@"name"] stringByTrimmingCharactersInSet:
                          [NSCharacterSet newlineCharacterSet]];
        NSString *name2 = [(NSString*) [obj objectForKey:@"name2"] stringByTrimmingCharactersInSet:
                           [NSCharacterSet newlineCharacterSet]];
        int main = [[obj objectForKey:@"main"] intValue];
        int type  = [[obj objectForKey:@"type"] intValue];
        int position = [[obj objectForKey:@"position"] intValue];
        
        if (type == 0)
            type = 1;
        
        NSMutableArray<ObjectValue *> *values = [NSMutableArray new];
        if (type == 2)
        {
            NSDictionary *jsonValues = [obj objectForKey:@"values"];
            
            for (id key in [jsonValues allKeys])
            {
                ObjectValue *ov = [ObjectValue new];
                
                NSDictionary *objValue = [jsonValues objectForKey:key];
                
                NSLog(@"value id == %d", [(NSString *) key intValue]);
                
                [ov setValId:[objValue objectForKey:@"id"]];
                [ov setName:[objValue objectForKey:@"name"]];
                [ov setOrdId:[(NSString *) key intValue] ];
                
                [values addObject:ov];
                
            }
            
        }
        
        values =  [[values sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            ObjectValue *cat1 = obj1;
            ObjectValue *cat2 = obj2;
            
            
            if (cat1.ordId < cat2.ordId) {
                return (NSComparisonResult) NSOrderedAscending;
            }
            else if (cat1.ordId > cat2.ordId)
            {
                return (NSComparisonResult) NSOrderedDescending;
            }
            
            
            return (NSComparisonResult) NSOrderedSame;
        }
        ] mutableCopy];
        
        [sObject setTitle:title];
        [sObject setUnits:units];
        [sObject setPlaceholder:placeholder];
        [sObject setSavedPlaceholder:placeholder];
        [sObject setName:name];
        [sObject setName2:name2];
        [sObject setMain:main];
        [sObject setType:type];
        [sObject setPosition:position];
        
        [sObject setValues:values];
        
        
        
        
        
        
        
        //int amount = [[cat objectForKey:@"amount"] integerValue];
        
        NSLog(@"title == %@", title);
        NSLog(@"units == %@", units);
        NSLog(@"placeholder == %@", placeholder);
        NSLog(@"name == %@", name);
        NSLog(@"name2 == %@", name2);
        NSLog(@"main == %i", main);
        NSLog(@"type == %i", type);
        NSLog(@"position == %i", position);
        
        [self.searchObjects addObject:sObject];
    }
    
    
    NSArray<SearchObject *> *searchObjectsTmp = [self.searchObjects sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        SearchObject *cat1 = obj1;
        SearchObject *cat2 = obj2;
        
        
        if (cat1.position < cat2.position) {
            return (NSComparisonResult) NSOrderedAscending;
        }
        else if (cat1.position > cat2.position)
        {
            return (NSComparisonResult) NSOrderedDescending;
        }
        
        
        return (NSComparisonResult) NSOrderedSame;
    }
    ];

    
    
    
    //self.searchObjects = tmpObjects;
    
    //[self.delegate categoryLoadComplete];
    
    //[self.delegate categoryDetailLoadComplete];
    
    [delegate loadComplete :  searchObjectsTmp];
}



@end
