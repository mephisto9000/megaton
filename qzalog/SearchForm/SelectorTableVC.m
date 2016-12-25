//
//  SelectorTableVC.m
//  qzalog
//
//  Created by Mus Bai on 26.12.16.
//  Copyright © 2016 Mus Bai. All rights reserved.
//

#import "SelectorTableVC.h"
#import "SearchFormVC.h"
#import "UserData.h"

@interface SelectorTableVC ()
{
    NSMutableArray *spinnerData;
    
    int rowNum;
    int selectedRow;
}

@end

@implementation SelectorTableVC

@synthesize titleLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    rowNum = [spinnerData count];
    
    self.titleLabel = self.searchObject.title;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)setSearchObject:(SearchObject *)searchObject
{
    _searchObject = searchObject;
    
    spinnerData = [NSMutableArray new];
    
    [spinnerData addObject: searchObject.savedPlaceholder];
    
    for (ObjectValue *ov in _searchObject.values)
    {
        [spinnerData addObject: ov.name];
        //NSLog(@"selector id == %d", ov.ordId);
    }
    
    
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UITableViewCell *cell = nil;
    
    //с дизайна забирается ячейка regionTableCell
    cell = [tableView dequeueReusableCellWithIdentifier:@"selectorCell"];
    
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"selectorCell"];
    }
    
    //if (indexPath.row == 0)
    //    cell.textLabel.text = @"Все";
    //else
        cell.textLabel.text = [spinnerData objectAtIndex:indexPath.row];
    
    
    return cell;
}


-(IBAction ) backButtonPressed : (id) sender
{
    [[self navigationController] popViewControllerAnimated:YES];
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //if ((indexPath.row) == 0)
    selectedRow = indexPath.row;
    
    {
        
        [self objectSelected];
        
    }
    
    /*
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
     */
    
}



-(void) objectSelected
{
    
    //SearchFormVC *sfvc = (SearchFormVC *) [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
    
    //[self.navigationController popViewControllerAnimated:YES];
    
    
    
    // [self.searchObject setPlaceholder:self.searchObject.values[row].name];
    
    /*
    if (currentRegionId == -1)
        [UserData setRegionId:   nil];  //  [ currentRegionId  st];
    else
        [UserData setRegionId:    [@(currentRegionId) stringValue]];  //  [ currentRegionId  st];
    
    [UserData setRegionName: regionName ];
    
    [sfvc setRegionName: regionName];
    [sfvc setRegionId:  [@(currentRegionId) stringValue]];
    
    
    [self.navigationController popViewControllerAnimated:YES];
    */
    
    SearchFormVC *sfvc = (SearchFormVC *) [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
    
    [self.navigationController popViewControllerAnimated:YES];
    
    int row = selectedRow ; // (int) [picker selectedRowInComponent:0];
    
   // if (row > -1)
    {
        [self.searchObject setPlaceholder: spinnerData[row]] ; //]  self.searchObject.values[row].name];
        [self.searchObject setSelectedValue1:spinnerData[row]];
    }
    //else
    //{
    //    [self.searchObject setPlaceholder: _searchObject.savedPlaceholder];
    //    [self.searchObject setSelectedValue1:_searchObject.savedPlaceholder];
    //}
         
    //selectedValue1
    
    
    
    [sfvc updateSearchForms];
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return rowNum;
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
