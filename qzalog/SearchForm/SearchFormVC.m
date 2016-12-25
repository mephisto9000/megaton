//
//  SearchFormVC.m
//  qzalog
//
//  Created by Mus Bai on 21.11.16.
//  Copyright © 2016 Mus Bai. All rights reserved.
//

#import "SearchFormVC.h"

#import "SearchSelectCell.h"
#import "SelectorSpinnerVC.h"
#import "CategorySpinnerVC.h"
#import "SearchSelectCell.h"
#import "SearchEditCell.h"
#import "SearchCell.h"
#import "CategoryDetailVC.h"
#import "UserData.h"
#import "RegionCell.h"
#import "SearchCache.h"
#import "SelectorTableVC.h"

@interface SearchFormVC ()
{
    SearchObject *searchObjectForSpinner;
    
    NSArray *categoriesInfoBackup;
    
    RegionCell *regionCell;
    
}

@property (nonatomic, strong) NSArray *categoriesInfo;

@end

@implementation SearchFormVC


const NSString *TO_SPINNER = @"toSpinner";
const NSString *TO_SPINNER_TABLE = @"toSpinnerTable";

const NSString *TO_CATEGORY_SPINNER = @"toCategorySpinner";
const NSString *TO_REGION_SPINNER = @"toRegionSpinner";

const NSString *TO_REGION_TABLE = @"toRegionTable";

const NSString *TO_CATEGORY_DETAIL = @"toCategoryDetail";

//const NSString *TO_OBJECT_DETAIL = @"toObjectDetail";

@synthesize categoriesInfo = _categoriesInfo;
@synthesize categoryId = _categoryId;
@synthesize tableView;

@synthesize categoryName = _categoryName;


@synthesize regionId = _regionId;
@synthesize regionName = _regionName;


@synthesize regionButton = _regionButton;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    if ([UserData categoryId] != nil)
        self.categoryId = [UserData categoryId];
    
    if ([UserData categoryName] != nil)
        self.categoryName = [UserData categoryName];
    
    
    
    
    
    if (_categoryId == nil)
        self.categoryId = @"31";
    
    if (_categoryName == nil)
        self.categoryName = @"Квартиры";
    
    [self setCategoryId:self.categoryId];
    
    
    
    
    
    
    NSLog(@"region id ===== %@", [UserData regionId]);
    if ([UserData regionId] != nil)
        self.regionId = [UserData regionId];
        
    if (self.regionId == nil)
        self.regionId = nil ; //@"";
    
    
    
    NSLog(@"region name ===== %@", [UserData regionName]);
    if ([UserData regionName] != nil)
        _regionName = [UserData regionName];
    
    //NSLog([UserData regionName]);
    
    
    if (_regionName == nil)
        _regionName = @"не важно"; //"@"Алматы";
    
    
    
    [self setRegionId:self.regionId];
    
    
    
    
    
    SearchCache *cache = [SearchCache searchCache];
    
    if (![[cache categoryId] isEqualToString:_categoryId])
    {
        SearchObjectReader *sor = [SearchObjectReader new];
    
        [sor setDelegate:self];
    
        [sor loadData:[self.categoryId intValue]];
    }
    else
    {
        [self loadComplete: [cache searchObjects]];
    }
}


-(void) loadComplete :(NSArray *) data;
{
    NSLog(@"load complete !!!!!!!!");
    
    [self setCategoriesInfo:data];
    
    categoriesInfoBackup = [NSMutableArray arrayWithArray:_categoriesInfo];
    
    
    //[self clearClicked:self];
    [self.tableView reloadData];
}

-(void) setCategoryId:(NSString *)categoryId
{
    
    NSLog(@"setCategoryId .... ");
    
    //Title!!
    /*    [_categoryButton  setTitle: self.categoryName forState:UIControlStateNormal]; //| UIControlStateSelected | UIControlStateHighlighted*/
    
    if (![categoryId isEqualToString:_categoryId])
    {
        _categoryId = categoryId;
       // [sor loadData:[self.categoryId intValue]];
        
        SearchObjectReader *sor = [SearchObjectReader new];
        
        [sor setDelegate:self];
        
        [sor loadData:[_categoryId intValue]];
        
        [self clearClicked:self];

        
        //[self.view setNeedsDisplay];
    }
}


-(void) setRegionId:(NSString *)regionId
{
    NSLog(@"setRegionId");
    
    if (self.regionName == nil)
    {
        [_regionButton setTitle: @"Регион" forState:UIControlStateNormal];
        
        
        _regionId = nil;;
        [regionCell updateRegionName: @"не важно"];
        
        
    }
    else
    {
        [_regionButton setTitle: self.regionName forState:UIControlStateNormal];
        _regionId = regionId;
        
        //regionCell.regionLabel.text = self.regionName;
        [regionCell updateRegionName: self.regionName];
        
    }
    
    
    //[UserData setRegionId:_regionId];
    //[UserData setRegionName:_regionName];
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //NSLog(@"numROws == %i", [catDetailArr count]);
    //if (self.)
    
    
    // +regionCell
    return [_categoriesInfo count] +1 ;
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ((indexPath.row) == 0)
        [self performSegueWithIdentifier:TO_REGION_TABLE sender:self];
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   return 70;
    
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // Dequeue the cell.
    
    
    if (indexPath.row == 0)
    {
       RegionCell *cell = (RegionCell *)[tableView dequeueReusableCellWithIdentifier:@"regionCell" forIndexPath:indexPath];
        
        /*if (cell == nil)
            cell =  [ [RegionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"regionCell"];*/
       
        //[cell.regionCellView setBackgroundColor:[UIColor redColor]];
        
        
       
        CALayer *TopBorder = [CALayer layer];
         TopBorder.frame = CGRectMake(0.0f, 0.0f, cell.regionCellView.bounds.size.width, 0.5f);
        TopBorder.backgroundColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0].CGColor;

         [cell.regionCellView.layer addSublayer:TopBorder];
      /*
        CALayer *BottomBorder = [CALayer layer];
        BottomBorder.frame = CGRectMake(0.0f, cell.regionCellView.bounds.size.height-1, cell.regionCellView.bounds.size.width, 1.0f);
        BottomBorder.backgroundColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0].CGColor;
        [cell.regionCellView.layer addSublayer:BottomBorder];
*/

        
        
        regionCell = cell;
        
        return cell;
    }
    
    //NSLog(@"in cell for row %i", indexPath.row);
    
    SearchObject *so = (SearchObject *) _categoriesInfo[indexPath.row - 1];
    
    
    
    UITableViewCell<SearchCell> *cell ;
    
    
    
    if (so.type == 1){
        SearchEditCell *cell;
        cell = [tableView dequeueReusableCellWithIdentifier:@"searchEditCell" forIndexPath:indexPath];
        
        CALayer *TopBorder2 = [CALayer layer];
        TopBorder2.frame = CGRectMake(0.0f, 0.0f, cell.fieldView.bounds.size.width, 0.5f);
        TopBorder2.backgroundColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0].CGColor;
        [cell.fieldView.layer addSublayer:TopBorder2];
         [cell initWithSearchObject:so];
        return cell;
        
    }
    
    if (so.type == 2)
    {
        SearchSelectCell *cell;
        cell = [tableView dequeueReusableCellWithIdentifier:@"searchSelectCell" forIndexPath:indexPath];
        
        CALayer *TopBorder3 = [CALayer layer];
        TopBorder3.frame = CGRectMake(0.0f, 0.0f, cell.selectorView.bounds.size.width, 0.5f);
        TopBorder3.backgroundColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0].CGColor;
        [cell.selectorView.layer addSublayer:TopBorder3];
        
        [((SearchSelectCell *)cell ) setSearchFormVC: self];
         [cell initWithSearchObject:so];
        return cell;
    }
    
    /*if (!cell)
    {
        if (so.type == 1)
            cell = (UITableViewCell<SearchCell> *)[[SearchEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"searchEditCell" ];
        
        if (so.type == 2)
        {
            
            cell =(UITableViewCell<SearchCell> *)[[SearchSelectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"searchSelectCell" ];
            [((SearchSelectCell *)cell ) setSearchFormVC: self];
        }
        
        
        
    }
    
    
    
    
    [cell initWithSearchObject:so];
    
    NSLog(@"loading cell # %i %@ %@ %@", (int) indexPath.row, so.selectedValue1, so.selectedValue2, so.name); //, so.name
    
    
    */
    return cell;
   
    
    
}


-(IBAction) searchObjectSelectClick:(id)sender
{
    NSLog(@"searchObjectSelectClick");
}

-(void) jumpToSpinner:(SearchObject *) searchObject;
{
    searchObjectForSpinner = searchObject;
    
    [self performSegueWithIdentifier:TO_SPINNER_TABLE sender:self];
}

-(void) updateSearchForms
{
    [self.tableView reloadData];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    
    //obsolette
    if ([segue.identifier isEqualToString:TO_SPINNER])
    {
        SelectorSpinnerVC *spinner = (SelectorSpinnerVC *)segue.destinationViewController;
        
        //[spinner setSearchObject:searchObjectForSpinner.values];
        [spinner setSearchObject:searchObjectForSpinner];
       // [spinner setObjectValues: searchObjectForSpinner.values];
    }
    
    if ([segue.identifier isEqualToString:TO_SPINNER_TABLE])
    {
        SelectorTableVC *stvc = (SelectorTableVC *)segue.destinationViewController;
        
        //[spinner setSearchObject:searchObjectForSpinner.values];
        [stvc setSearchObject:searchObjectForSpinner];
        // [spinner setObjectValues: searchObjectForSpinner.values];
    }
    
    if ([segue.identifier isEqualToString:TO_CATEGORY_SPINNER])
    {
        CategorySpinnerVC *categorySpinner = (CategorySpinnerVC *) segue.destinationViewController;
        
        [categorySpinner setCategoryId:_categoryId];
        
        
    }
    
    if ([segue.identifier isEqualToString:TO_CATEGORY_DETAIL])
    {
        CategoryDetailVC *catVC = (CategoryDetailVC *) segue.destinationViewController;
        
        //catVC setUrl:<#(NSString *)#>
        
        NSMutableString *requestStr = [NSMutableString stringWithFormat:@"http://qzalog.kz/_mobile_objects?category=%@&ObjectsSearch[region_id]=", self.categoryId]; //46
        
        NSLog(@"appending regionId");
        //if (self.regionId != nil && [self.regionId length] > 0)
        if ([UserData regionId] != nil)
        [requestStr appendString:[NSString stringWithFormat:@"%@", [UserData regionId]] ];
        
        for (int i = 0; i < [_categoriesInfo count]; i++)
        {
            //SearchObject *so = (SearchObject *) _categoriesInfo[i];
            
            NSLog(@"appending cell %i", i);
            
            //so.
            NSIndexPath *nowPath = [NSIndexPath indexPathForRow:i+1 inSection:0];
            
            id<SearchCell> cell = (id<SearchCell> )[self.tableView cellForRowAtIndexPath:nowPath];
            
            //tableView cellForRowAtIndexPath:<#(nonnull NSIndexPath *)#>
            
            
            
            //if (cell != nil)
            {
            NSString *cellStr = [cell generateSearchString];
            
                
            if (cellStr != nil)
            {
            NSLog(@"cell str == %@", cellStr);
            [requestStr appendString: cellStr];
            }
            }
        }
        
        
        SearchCache *cache = [SearchCache searchCache];
        
        
        for (int i = 0; i < [_categoriesInfo count]; i++)
        {
            SearchObject *so = _categoriesInfo[i];
            
            NSLog(@"so%i == %@ %@ %@", i, so.title, so.selectedValue1, so.selectedValue2);
        }
        
        [cache setCategoryId:_categoryId];
        [cache setSearchObjects:[_categoriesInfo copy]];

        
        NSLog(@"search request str == %@", requestStr);
        
        [catVC setUrl:requestStr];
    }
}

-(IBAction) searchClicked: (id) sender
{
    NSLog(@"search clicked!");
    
   
        
    [self performSegueWithIdentifier:TO_CATEGORY_DETAIL sender:self];
    
    
}

-(IBAction) backClicked: (id) sender
{
    
    for (int i = 0; i < [_categoriesInfo count]; i++)
    {
        
        NSIndexPath *nowPath = [NSIndexPath indexPathForRow:i+1 inSection:0];
        
        id<SearchCell> cell = (id<SearchCell> )[self.tableView cellForRowAtIndexPath:nowPath];
        
        if (cell != nil)
        {
            
            //нам нужно обновить данные в searchObjects, чтобы записать их в кэш
            NSString *cellStr = [cell generateSearchString];
            
            NSLog(@"cell str == %@", cellStr);
            
        }
    }
    
    
    SearchCache *cache = [SearchCache searchCache];
    
    [cache setCategoryId:_categoryId];
    [cache setSearchObjects:[_categoriesInfo copy]];

    
    
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction) clearClicked: (id) sender
{
    //self.categoriesInfo = [NSMutableArray arrayWithArray:categoriesInfoBackup];
    
    self.regionName = nil;
    [self setRegionId:nil];
    
    
    
    
    
    for (int i = 0; i < [_categoriesInfo count]; i++)
    {
        SearchObject  *so = (SearchObject *)_categoriesInfo[i];
        
        
        //so.savedPlaceholder = so.placeholder;
        so.selectedValue1 = nil;
        so.selectedValue2 = nil;
        
        
        //Ca
        //SearchObject *so = (SearchObject *) self.categoriesInfo[i];
        //if (so.type == 2)
         //   so.placeholder = @"Не важно";
        
        NSLog(@"clearing cell %i", i);
        
        NSIndexPath *nowPath = [NSIndexPath indexPathForRow:i+1 inSection:0];
        
        id<SearchCell> cell = (id<SearchCell> )[self.tableView cellForRowAtIndexPath:nowPath];
                                             
                                             
        [cell clearCell];
        
        
    }
    
    [self.tableView reloadData];

}

-(IBAction) categorySelectClicked: (id) sender
{
    
    [self performSegueWithIdentifier:TO_CATEGORY_SPINNER sender:self];
    
}

-(IBAction) regionSelectClick: (id) sender
{
    [self performSegueWithIdentifier:TO_REGION_SPINNER sender:self];
}




@end
