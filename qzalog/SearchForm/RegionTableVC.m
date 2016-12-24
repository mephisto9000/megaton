//
//  RegionTableVC.m
//  qzalog
//
//  Created by Mus Bai on 06.12.16.
//  Copyright © 2016 Mus Bai. All rights reserved.
//

#import "RegionTableVC.h"
#import "DBManager.h"
#import "UserData.h"
#import "SearchFormVC.h"


@interface RegionTableVC ()
{
    NSArray *regionIds;
    NSArray *regionNames;
    NSArray *regionParentIds;
    
    
    NSInteger currentRegionId;
    
    int rowNum;
    NSString *regionName;
}

@end

@implementation RegionTableVC

@synthesize tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    // загрузим корневые регионы
    [self loadData: -1];
    
    // считаем сначала, что региона нет
    currentRegionId = -1;
    regionName = @"не важно";
}


-(int) loadData: (NSInteger) regionId
{
    DBManager *db = [[DBManager alloc] initWithDatabaseFilename:@"qzalog.db"];
    
    NSString *query ;
    
    if (regionId >= 0)
        query = [NSString stringWithFormat : @"select * from regions where parent = %i", (int) regionId ];
    else
        query = @"select * from regions where parent is null";
    
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
        
        
        /*
        if ([[UserData regionId] isEqualToString:[NSString stringWithFormat:@"%i", [[regionsInfo[i] objectAtIndex:indexOfId] intValue] ] ])
        {
            [picker selectRow:i inComponent:0 animated:YES];
        }*/
        
    }
    
    regionIds = [tmpRegionIds copy];
    
    NSLog(@"regionIds : ");
    for (int i = 0; i < [regionIds count]; i++)
        NSLog(@"%@", [regionIds[i] stringValue]);
    
    regionNames = [tmpRegionNames copy];
    regionParentIds = [tmpRegionIds copy];
    
    rowNum = [regionNames count] + 1;
    
    return rowNum;
}


//создаем ячейки таблицы
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UITableViewCell *cell = nil;
    
    //с дизайна забирается ячейка regionTableCell
    cell = [tableView dequeueReusableCellWithIdentifier:@"regionTableCell"];
    
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"regionTableCell"];
    }
    
    if (indexPath.row == 0)
        cell.textLabel.text = @"все";
    else
        cell.textLabel.text = [regionNames objectAtIndex:indexPath.row-1];
    
        
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ((indexPath.row) == 0)
    {
        
        [self regionSelected];
        
    }
    else
    {
        currentRegionId = [ regionIds[indexPath.row-1] integerValue];
        regionName = regionNames[indexPath.row-1];
        if ([self loadData:currentRegionId]  <= 1)
        {
            
            [self regionSelected];
            
        }
        else
        {
            [self.tableView reloadData];
        }
    }
    
        
}


-(void) regionSelected
{

SearchFormVC *sfvc = (SearchFormVC *) [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];

//[self.navigationController popViewControllerAnimated:YES];



// [self.searchObject setPlaceholder:self.searchObject.values[row].name];

    
if (currentRegionId == -1)
  [UserData setRegionId:   nil];  //  [ currentRegionId  st];
    else
[UserData setRegionId:    [@(currentRegionId) stringValue]];  //  [ currentRegionId  st];

[UserData setRegionName: regionName ];

[sfvc setRegionName: regionName];
[sfvc setRegionId:  [@(currentRegionId) stringValue]];


[self.navigationController popViewControllerAnimated:YES];

}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return rowNum;
}

-(IBAction ) backButtonPressed : (id) sender
{
    [[self navigationController] popViewControllerAnimated:YES];
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
