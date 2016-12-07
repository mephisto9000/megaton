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
const NSString *TO_CATEGORY_SPINNER = @"toCategorySpinner";
const NSString *TO_REGION_SPINNER = @"toRegionSpinner";

const NSString *TO_REGION_TABLE = @"toRegionTable";

const NSString *TO_CATEGORY_DETAIL = @"toCategoryDetail";

//const NSString *TO_OBJECT_DETAIL = @"toObjectDetail";


@synthesize categoryId = _categoryId;
@synthesize tableView;

@synthesize categoryName = _categoryName;


@synthesize regionId = _regionId;
@synthesize regionName = _regionName;

@synthesize categoryButton = _categoryButton;
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
        _regionName = @"Не важно"; //"@"Алматы";
    
    
    
    [self setRegionId:self.regionId];
    
    
    
    
    
    
    
    SearchObjectReader *sor = [SearchObjectReader new];
    
    [sor setDelegate:self];
    
    [sor loadData:[self.categoryId intValue]];
}


-(void) loadComplete :(NSArray *) data;
{
    NSLog(@"load complete !!!!!!!!");
    
    [self setCategoriesInfo:data];
    
    categoriesInfoBackup = [NSMutableArray arrayWithArray:_categoriesInfo];
    
    
    
    [self.tableView reloadData];
}

-(void) setCategoryId:(NSString *)categoryId
{
    
    NSLog(@"setCategoryId .... ");
    
    if (self.categoryName == nil)
        [_categoryButton  setTitle: @"Категория" forState:UIControlStateNormal]; //| UIControlStateSelected | UIControlStateHighlighted
    else
        [_categoryButton  setTitle: self.categoryName forState:UIControlStateNormal]; //| UIControlStateSelected | UIControlStateHighlighted
    
    if (![categoryId isEqualToString:_categoryId])
    {
        _categoryId = categoryId;
       // [sor loadData:[self.categoryId intValue]];
        
        SearchObjectReader *sor = [SearchObjectReader new];
        
        [sor setDelegate:self];
        
        [sor loadData:[_categoryId intValue]];

        
        //[self.view setNeedsDisplay];
    }
}


-(void) setRegionId:(NSString *)regionId
{
    NSLog(@"setRegionId");
    
    if (self.regionName == nil)
        [_regionButton setTitle: @"Регион" forState:UIControlStateNormal];
    else
    {
        [_regionButton setTitle: self.regionName forState:UIControlStateNormal];
        _regionId = regionId;
        
        //regionCell.regionLabel.text = self.regionName;
        [regionCell updateRegionName: self.regionName];
        
    }
    
    
    /*
    if (![regionId isEqualToString:_regionId])
    {
        //_regionId = regionId;
        
        //re
        
    } 
    */
    
    
    
    
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
    return [self.categoriesInfo count] +1 ;
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ((indexPath.row) == 0)
        [self performSegueWithIdentifier:TO_REGION_TABLE sender:self];
    
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // Dequeue the cell.
    
    
    if (indexPath.row == 0)
    {
       RegionCell *cell = (RegionCell *)[tableView dequeueReusableCellWithIdentifier:@"regionCell" forIndexPath:indexPath];
        
        if (cell == nil)
            cell =  [ [RegionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"regionCell"];
        
        regionCell = cell;
        
        return cell;
    }
    
    
    
    SearchObject *so = (SearchObject *) self.categoriesInfo[indexPath.row - 1];
    
    
    
    UITableViewCell<SearchCell> *cell ;
    
    
    if (so.type == 1)
        cell = [tableView dequeueReusableCellWithIdentifier:@"searchEditCell" forIndexPath:indexPath];
    
    if (so.type == 2)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"searchSelectCell" forIndexPath:indexPath];
        
        [((SearchSelectCell *)cell ) setSearchFormVC: self];
    }
    
    if (cell== nil)
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
    
    NSLog(@"loading cell # %i", (int) indexPath.row);
    
    
   
    
    //cell.textLabel.text =   so.title;
    
    /*
    CategoryDetail *cd = catDetailArr[indexPath.row];
    
    
    cell.adTextLabel.text = cd.title;
    cell.addrLabel.text = cd.region;
    cell.infoLabel.text = cd.info;
    cell.priceLabel.text = cd.price;
    
    cell.adImage.contentMode = UIViewContentModeScaleAspectFill;
    cell.adImage.image = NULL;
    
    [self.operationManager GET:cd.image
                    parameters:nil
                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                           cell.adImage.image = responseObject;
                       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                           NSLog(@"Failed with error %@.", error);
                       }];
    
    if (!lastItemReached && indexPath.row == [catDetailArr count] - 1)
    {
        //[self launchReload];
        itemCount = [catDetailArr count];
        [cdLoader loadCategoryDetailData];
    }  */
    
    return cell;
}


-(IBAction) searchObjectSelectClick:(id)sender
{
    NSLog(@"searchObjectSelectClick");
}

-(void) jumpToSpinner:(SearchObject *) searchObject;
{
    searchObjectForSpinner = searchObject;
    
    [self performSegueWithIdentifier:TO_SPINNER sender:self];
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
    
    if ([segue.identifier isEqualToString:TO_SPINNER])
    {
        SelectorSpinnerVC *spinner = (SelectorSpinnerVC *)segue.destinationViewController;
        
        //[spinner setSearchObject:searchObjectForSpinner.values];
        [spinner setSearchObject:searchObjectForSpinner];
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
            NSIndexPath *nowPath = [NSIndexPath indexPathForRow:i inSection:0];
            
            id<SearchCell> cell = (id<SearchCell> )[self.tableView cellForRowAtIndexPath:nowPath];
            
            //tableView cellForRowAtIndexPath:<#(nonnull NSIndexPath *)#>
            if (cell != nil)
            {
            NSString *cellStr = [cell generateSearchString];
            
            NSLog(@"cell str == %@", cellStr);
            [requestStr appendString: cellStr];
            }
        }
        
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
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction) clearClicked: (id) sender
{
    //self.categoriesInfo = [NSMutableArray arrayWithArray:categoriesInfoBackup];
    
    for (int i = 0; i < [self.categoriesInfo count]; i++)
    {
        //Ca
        //SearchObject *so = (SearchObject *) self.categoriesInfo[i];
        //if (so.type == 2)
         //   so.placeholder = @"Не важно";
        
        NSIndexPath *nowPath = [NSIndexPath indexPathForRow:i inSection:0];
        
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
