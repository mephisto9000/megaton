//
//  CategorySpinnerVC.m
//  qzalog
//
//  Created by Mus Bai on 25.11.16.
//  Copyright © 2016 Mus Bai. All rights reserved.
//

#import "CategorySpinnerVC.h"
#import "Category.h"
#import "DBManager.h"
#import "SearchFormVC.h"
#import "UserData.h"

//#import

@interface CategorySpinnerVC ()
{
    NSArray *categoriesInfo;
    
    //CategoryDataLoader *cdl;
    DBManager *dbManager;
    
    int indexOfId;
    int indexOfName;
    int indexOfCategoryId;
    
    NSArray<NSString *> *categoryNames;
    NSArray<NSNumber  *> *categoryIds;
    
    
    
}


@end

@implementation CategorySpinnerVC

@synthesize picker;
@synthesize categoryId;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /*
    cdl = [CategoryDataLoader new];
    
    [cdl setDelegate:self];
    
    [cdl loadCategoryData]; */
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return categoryNames.count;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return categoryNames[row];
}


-(void) loadData
{
    NSMutableArray<NSString *> *categoryNamesTmp = [NSMutableArray<NSString *> new];
    NSMutableArray<NSNumber *> *categoryIdsTmp = [NSMutableArray<NSNumber *> new];

    NSLog(@"loading data");
    NSString *query = @"select * from categories";
    
    // Get the results.
    if (categoriesInfo != nil) {
        categoriesInfo = nil;
    }

    //dbManager = [DBManager new];
    dbManager = [[DBManager alloc] initWithDatabaseFilename: [UserData dbName]];

    categoriesInfo = [[NSArray alloc] initWithArray:[dbManager loadDataFromDB:query]];

    // Reload the table view.

    indexOfId = [dbManager.arrColumnNames indexOfObject:@"id"];
    indexOfName = [dbManager.arrColumnNames indexOfObject:@"name"];
    indexOfCategoryId = [dbManager.arrColumnNames indexOfObject:@"category_id"];
    
    NSLog(@"id == %i %i", (int)indexOfId, (int) indexOfName);
    
    categoryNames = [NSMutableArray new];
    categoryIds = [NSMutableArray new];
    
    //categoriesInfo count];
    
    for (int i = 0; i < [categoriesInfo count]; i++)
    {
        //Category *cat = categoriesInfo[i] objectAtIndex:<#(NSUInteger)#>;
        
        ///<Category *>
        
        [categoryNamesTmp addObject:[[categoriesInfo objectAtIndex:i ] objectAtIndex: indexOfName ]];
        [categoryIdsTmp addObject:[NSNumber numberWithInt:[[[categoriesInfo objectAtIndex:i] objectAtIndex:indexOfCategoryId] integerValue]]];
        
        //if ([[UserData categoryId] isEqualToString:[categoriesInfo[i] objectAtIndex:indexOfCategoryId]])
        if ([[UserData categoryId] isEqualToString:[NSString stringWithFormat:@"%i", [[categoriesInfo[i] objectAtIndex:indexOfCategoryId] intValue] ] ])
        {
            [picker selectRow:i inComponent:0 animated:YES];
        }
    }
    
    categoryNames = [categoryNamesTmp copy];
    categoryIds = [categoryIdsTmp copy];
    
    

}


-(IBAction) okClicked: (id) sender
{
    NSLog(@"ok clicked!");
    
    SearchFormVC *sfvc = (SearchFormVC *) [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
    
    //[self.navigationController popViewControllerAnimated:YES];
    
    int row = (int) [picker selectedRowInComponent:0];
    //[self.searchObject setPlaceholder:self.searchObject.values[row].name];
    [sfvc setCategoryName:categoryNames[row] ];
    [sfvc setCategoryId:  [categoryIds[row] stringValue]];
    
    [UserData setCategoryId:[categoryIds[row] stringValue]];
    [UserData setCategoryName:categoryNames[row] ];
    
    
    [self.navigationController popViewControllerAnimated:YES];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
