//
//  CategoryDetailVC.m
//  qzalog
//
//  Created by Mus Bai on 19.11.16.
//  Copyright © 2016 Mus Bai. All rights reserved.
//

#import "CategoryDetailVC.h"
#import "CategoryDetail.h"
#import "CategoryDetailDataLoader.h"
#import "CategoryDetailListener.h"
#import "CategoryDetailCell.h"

#import "SearchFormVC.h"
//#import "AFHTTPSessionManager.h"
//#import "AFHTTPRequestOperationManager.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import "ObjectDetailVC.h"
#import "DBManager.h"
#import "UserData.h"

@interface CategoryDetailVC () <CategoryDetailListener>
{
    CategoryDetailDataLoader *cdLoader;
    
    NSArray<CategoryDetail *> *catDetailArr;
    
    
    DBManager *dbManager;
    
    
    int selectedRow;
    
    NSString *categoryId;
    BOOL lastItemReached;
    int itemCount;
}

@property(nonatomic, retain) AFHTTPRequestOperationManager  *operationManager;

@end

@implementation CategoryDetailVC

const NSString *TO_SEARCH_FORM = @"toSearchForm";
const NSString *TO_OBJECT_DETAIL = @"toObjectDetail";

@synthesize segmentedControl;
@synthesize url;
@synthesize titleLabel;


-(void) setCategory:(NSString *)categoryId1
{
    categoryId = categoryId1;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    cdLoader = [CategoryDetailDataLoader new];
    
    [cdLoader setDelegate:self];
    
    
    if (self.isFavourite == FALSE)
        
    {
    if (self.url == nil)
        [cdLoader setCategoryId:categoryId];
    else
        [cdLoader setSearchUrl:self.url];
    
    
    
    [cdLoader loadCategoryDetailData];
    
    lastItemReached = FALSE;
    
        
        self.titleLabel.text = [UserData categoryName];
    }
    else
    {
        [cdLoader loadFavorite];
        lastItemReached = TRUE;
        segmentedControl.hidden = YES;
        
        self.titleLabel.text = @"Избранное";
    }

    itemCount = 0;
    
    [segmentedControl addTarget:self
                         action:@selector(segmentSwitch:)
               forControlEvents:UIControlEventValueChanged];
    
    
    dbManager = [[DBManager alloc] initWithDatabaseFilename:@"qzalog.db"];

}


- (AFHTTPRequestOperationManager *)operationManager
{
    if (!_operationManager)
    {
        _operationManager = [[AFHTTPRequestOperationManager alloc] init];
        _operationManager.responseSerializer = [AFImageResponseSerializer serializer];
    };
    
    return _operationManager;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // Dequeue the cell.
    CategoryDetailCell *cell = [tableView dequeueReusableCellWithIdentifier: @"categoryDetailCell"  forIndexPath:indexPath];
    
    CategoryDetail *cd = catDetailArr[indexPath.row];
    //catDetailArr[selectedRow].catDetId);
    
    if (cell== nil)
    {
        cell = [[CategoryDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: @"categoryDetailCell"];
        
        
        
    }
    
        
    
    
    
    NSLog(@"loading cell # %i", (int) indexPath.row);
    
    
    NSLog(@"cd.catDetId == %@", cd.catDetId);
    
    [cell setObjectId:cd.catDetId];
    
    [cell setDbManager:dbManager];

    
    
    cell.adTextLabel.text = cd.title;
    cell.addrLabel.text = cd.region;
    cell.infoLabel.text = cd.info;
    cell.priceLabel.text = cd.price;
    
    [cell.priceLabel sizeToFit];
    
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
    }
    
    return cell;
}



-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    //NSLog(@"category detail count == %i", [catDetailArr count] );
    
    return [catDetailArr count];
}


- (void)segmentSwitch:(UISegmentedControl *)sender {
    
    NSInteger selectedSegment = sender.selectedSegmentIndex;
    
    NSLog(@"i'm here");
    
    
    if (selectedSegment == 0) {
        //sort by date;
        
        itemCount = 0;
        [cdLoader setDateDesc];
        [cdLoader loadCategoryDetailData];
        
        /*
        catDetailArr = [catDetailArr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            CategoryDetail *cat1 = obj1;
            CategoryDetail *cat2 = obj2;
            
            
                if (cat1.pos < cat2.pos) {
                    return (NSComparisonResult) NSOrderedAscending;
                }
                else if (cat1.pos > cat2.pos)
                {
                    return (NSComparisonResult) NSOrderedDescending;
                }
            
        
        return (NSComparisonResult) NSOrderedSame;
        }
        ];
         */
    }
    else{
        int seg = (int) selectedSegment;
        
        
        if (seg == 1)
        {
            itemCount = 0;
            [cdLoader setPriceDesc];
            [cdLoader loadCategoryDetailData];
        }
        else
        {
            itemCount = 0;
            [cdLoader setPriceAsc];
            [cdLoader loadCategoryDetailData];
        }
        
        /*
        catDetailArr = [catDetailArr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            CategoryDetail *cat1 = obj1;
            CategoryDetail *cat2 = obj2;
            
            if (seg == 1)
            {
            
                
                if (cat1.intPrice < cat2.intPrice) {
                    return (NSComparisonResult) NSOrderedAscending;
                }
                else if (cat1.intPrice > cat2.intPrice)
                {
                    return (NSComparisonResult) NSOrderedDescending;
                }
                
               
                
            }
            else
            {
                
                if (cat1.intPrice > cat2.intPrice) {
                    return (NSComparisonResult) NSOrderedAscending;
                }
                else if (cat1.intPrice < cat2.intPrice)
                {
                    return (NSComparisonResult) NSOrderedDescending;
                }
                
                
            }
            return (NSComparisonResult) NSOrderedSame;
        }
        
    ];
        */
        
        
    }
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:TO_SEARCH_FORM])
    {
        SearchFormVC *sfcv = (SearchFormVC *) segue.destinationViewController;
        
        
        //[sfcv setCategoryId:categoryId];
        //sfvc  setCate
    }
    if ([segue.identifier isEqualToString:TO_OBJECT_DETAIL])
    {
        ObjectDetailVC *odvc = (ObjectDetailVC *) segue.destinationViewController;
        
        
        NSLog(@"objId ==== %@", catDetailArr[selectedRow].catDetId);
        
        
        [odvc setObjectId:catDetailArr[selectedRow].catDetId];
        
        
    }
}



-(void) categoryDetailLoadComplete
{
    [self performSelectorOnMainThread:@selector(categoryDetailLoadCompleteMainThread) withObject:nil waitUntilDone:YES];
   
    
}

-(void) categoryDetailLoadCompleteMainThread
{
    catDetailArr = [cdLoader catDetailData];
    
    if (itemCount == [catDetailArr count] )
        lastItemReached = YES;
    else
    {
        //[self segmentSwitch: segmentedControl];
        
        [self.tableView reloadData];
    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    UIAlertView *messageAlert = [[UIAlertView alloc]
                                 initWithTitle:@"Row Selected" message:@"You've selected a row" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    // Display Alert Message
    [messageAlert show]; */
    
    selectedRow = indexPath.row;
    
    [self performSegueWithIdentifier:TO_OBJECT_DETAIL sender:self];
    
}



-(IBAction) jumpToSearchForm : (id) sender
{
    //NSLog(@"jump to search form");
    
    [self performSegueWithIdentifier:TO_SEARCH_FORM sender:self];
}


-(IBAction) jumpBack: (id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
