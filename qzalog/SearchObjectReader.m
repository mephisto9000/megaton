//
//  SearchObjectReader.m
//  qzalog
//
//  Created by Mus Bai on 21.11.16.
//  Copyright © 2016 Mus Bai. All rights reserved.
//

#import "SearchObjectReader.h"
#import "DBManager.h"

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

const NSString *DB_NAME = @"qzalog.db";

-(id) init
{
    self = [super init];
    
    
    //dbManager = [[DBManager alloc] initWithDatabaseFilename:@"qzalog.db"];
    
    
    return self;
}


-(void) loadData: (int) category_id
{
    
    
    
    
    dbManager = [[DBManager alloc] initWithDatabaseFilename:DB_NAME];
    
    
    //NSString *query = [NSString stringWithFormat:@"select * from categories", category_id]; // where category_id = %i
    NSString *query = [NSString stringWithFormat:@"select form from categories where category_id = %i", category_id];
    
    // Get the results.

    if(tmpObjects != nil)
        tmpObjects = nil;
    //NSMutableArray<SearchObject *> *tmpObjects;
    
    NSLog(@"sql == %@", query);
    
    
    //self.categoriesInfo = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
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
    
    //indexOfForm = 3;
    
    NSLog(@"id == %i", (int) indexOfId );
    NSLog(@"name == %i", (int) indexOfName );
    NSLog(@"category_id == %i", (int) indexOfCategoryId );
    NSLog(@"form == %i", (int) indexOfForm );
    
    NSLog(@"before data fetch");
    
    //for (int i = 0; i < [tmpObjects count]; i++)
     //   NSLog(@"%@", tmpObjects[i] );
    
    //NSLog(@"%@", [[[tmpObjects objectAtIndex:0] objectAtIndex:indexOfForm] dataUsingEncoding:NSUTF8StringEncoding]);
    NSArray *form = [tmpObjects objectAtIndex:0];
    
    
    //NSLog(@"%@", form);
    
    
    NSString *convertedString = [[form[0] objectAtIndex:0]  mutableCopy];
    
    CFStringRef transform = CFSTR("Any-Hex/Java");
    CFStringTransform((__bridge CFMutableStringRef)convertedString, NULL, transform, YES);
    
    NSLog(@"convertedString: %@", convertedString);


    [self parseObjectJSON:[convertedString dataUsingEncoding:NSUTF8StringEncoding]];
    
}


-(void) parseObjectJSON:(NSData *)objectNotation
{
    NSLog(@"here somewhere?");
    
    //NSJSONSerialization JS
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error: nil];
    
    for (id key in json) {
        NSLog(@"key: %@, value: %@ \n", key, [json objectForKey:key]);
    }

    NSDictionary* arr = (NSDictionary* ) [json objectForKey:@"fields"];

    int pos = 0;
    //for (NSDictionary *obj in arr)


    //[arr class].
    if (![arr isKindOfClass:[NSArray class]])

    for (id key in arr)
    {
        NSLog(@"first case");
        
        
        NSDictionary *obj = (NSDictionary* ) [arr objectForKey:key];

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
                
                [values addObject:ov];

            }
            
        }
        
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
    else
    {
        
        NSLog(@"second case");
        
       
        
        NSDictionary *obj = [((NSArray *) arr) objectAtIndex:0]; //(NSDictionary* ) [arr objectForKey:key];
        
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
                
                [ov setValId:[objValue objectForKey:@"id"]];
                [ov setName:[objValue objectForKey:@"name"]];
                
                [values addObject:ov];
                
            }
            
        }
        
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
        
    
    
    //self.searchObjects = tmpObjects;
    
    //[self.delegate categoryLoadComplete];
    
    //[self.delegate categoryDetailLoadComplete];
    
    [delegate loadComplete : self.searchObjects];
}



@end
