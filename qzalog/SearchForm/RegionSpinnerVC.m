//
//  RegionSpinnerVC.m
//  qzalog
//
//  Created by Mus Bai on 26.11.16.
//  Copyright © 2016 Mus Bai. All rights reserved.
//

#import "RegionSpinnerVC.h"
#import "DBManager.h"
#import "SearchFormVC.h"
#import "UserData.h"

@interface RegionSpinnerVC ()
{
    NSArray<NSNumber *> *regionIds;
    NSArray<NSString *> *regionNames;
    NSArray<NSNumber *> *regionParentIds;
    
}
@end

@implementation RegionSpinnerVC

@synthesize picker;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadData];
}

-(void) loadData
{
    DBManager *db = [[DBManager alloc] initWithDatabaseFilename:@"qzalog.db"];
    
    NSString *query = @"select * from regions where parent is null";
    
    NSArray *regionsInfo = [[NSArray alloc] initWithArray:[db loadDataFromDB:query]];
    
    NSInteger indexOfId = [db.arrColumnNames indexOfObject:@"id"];
    NSInteger indexOfName = [db.arrColumnNames indexOfObject:@"name"];
    NSInteger indexOfParent= [db.arrColumnNames indexOfObject:@"parent"];

    NSMutableArray<NSNumber *> *tmpRegionIds = [NSMutableArray<NSNumber *> new ];
    NSMutableArray<NSString *> *tmpRegionNames = [NSMutableArray<NSString *> new];
    NSMutableArray<NSNumber *> *tmpRegionParentIds = [NSMutableArray<NSNumber *> new];

    for (int i = 0; i < [regionsInfo count]; i++)
    {
        NSInteger regionId =   [[regionsInfo[i] objectAtIndex:indexOfId] integerValue];
        NSString *regionName = [regionsInfo[i] objectAtIndex:indexOfName];
        NSInteger regionParentId = [regionsInfo[i] objectAtIndex:indexOfParent];

        [tmpRegionIds addObject:[NSNumber numberWithInteger:regionId]];
        [tmpRegionNames addObject:regionName];
        [tmpRegionParentIds addObject:[NSNumber numberWithInteger:regionParentId]];
        
        
        
        if ([[UserData regionId] isEqualToString:[NSString stringWithFormat:@"%i", [[regionsInfo[i] objectAtIndex:indexOfId] intValue] ] ])
        {
            [picker selectRow:i inComponent:0 animated:YES];
        }

    }
    
    regionIds = [tmpRegionIds copy];
    
    NSLog(@"regionIds : ");
    for (int i = 0; i < [regionIds count]; i++)
        NSLog(@"%@", [regionIds[i] stringValue]);
    
    regionNames = [tmpRegionNames copy];
    regionParentIds = [tmpRegionIds copy];
                    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction) okClicked:(id) sender
{
    //NSLog(@"ok clicked");
    
   // [self.navigationController popViewControllerAnimated:YES];
    
    
    NSLog(@"ok clicked!");
    
    SearchFormVC *sfvc = (SearchFormVC *) [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
    
    //[self.navigationController popViewControllerAnimated:YES];
    
    int row = (int) [picker selectedRowInComponent:0];
    
    // [self.searchObject setPlaceholder:self.searchObject.values[row].name];
    
    [UserData setRegionId:[ regionIds[row] stringValue]];
    [UserData setRegionName: regionNames[row] ];
    
    [sfvc setRegionName: regionNames[row] ];
    [sfvc setRegionId:  [ regionIds[row] stringValue]];
    
    
    [self.navigationController popViewControllerAnimated:YES];

}



- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return regionNames.count;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return regionNames[row];
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
