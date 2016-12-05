//
//  CategoryVC.m
//  qzalog
//
//  Created by Mus Bai on 13.11.16.
//  Copyright © 2016 Mus Bai. All rights reserved.
//

#import "CategoryVC.h"
#import "DBManager.h"
#import "CategoryDataLoader.h"
#import "CategoryDetailVC.h"
#import "Category.h"
#import "UserData.h"


@interface CategoryVC ()
{
    NSMutableDictionary *catData;
    CategoryDataLoader *cdl;
    
    int selectedRow;
    
    
    //db fields
    NSInteger indexOfId;
    NSInteger indexOfName;
    NSInteger indexOfCategoryId;
}

@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) NSArray *categoriesInfo;


-(void)loadData;

@end

@implementation CategoryVC

const NSString *CATEGORY_DETAIL = @"toCategoryDetail";
const NSString *TO_SEARCH = @"toSearch";

@synthesize tableView;




-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.categoriesInfo count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // Dequeue the cell.
    CategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"categoryCell" forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[CategoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"categoryCell"];
    }
    
    
    NSLog(@"loading cell # %i", (int) indexPath.row);
    
    
    // Set the loaded data to the appropriate cell labels.
    
    NSInteger catId = [[[self.categoriesInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfCategoryId] integerValue];
    Category *cat = (Category *)[catData objectForKey: [NSNumber numberWithInteger:catId]];
    
    cell.titleLabel.text = [NSString stringWithFormat:@"%@", [[self.categoriesInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfName]];
    
    cell.countLabel.text =  [NSString stringWithFormat:@"%ld", (long)[cat amount]];
    
    NSString *fname = [NSString stringWithFormat:@"category%d.png", catId];
    
    
    NSLog(@"fname == %@", fname);
    
    cell.imageView.image = [UIImage imageNamed:fname];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    selectedRow = (int) indexPath.row;
    
    [self performSegueWithIdentifier:CATEGORY_DETAIL sender:self];
    
}


-(void) loadData
{
    
    NSLog(@"loading data");
    NSString *query = @"select * from categories";
    
    // Get the results.
    if (self.categoriesInfo != nil) {
        self.categoriesInfo = nil;
    }
    self.categoriesInfo = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    // Reload the table view.
    
     indexOfId = [self.dbManager.arrColumnNames indexOfObject:@"id"];
     indexOfName = [self.dbManager.arrColumnNames indexOfObject:@"name"];
     indexOfCategoryId = [self.dbManager.arrColumnNames indexOfObject:@"category_id"];
    
    NSLog(@"id == %i %i", (int)indexOfId, (int) indexOfName);
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"qzalog.db"];
    
    [self loadData];
    
    cdl = [CategoryDataLoader new];
    
    [cdl setDelegate:self];
    
    [cdl loadCategoryData];
    
    
}


-(void) categoryLoadComplete
{
    
    NSLog(@"category load complete");
    
    [self performSelectorOnMainThread:@selector(categoryLoadCompleteMainThread) withObject:nil waitUntilDone:YES];
    
}

-(IBAction) backPressed : (id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void) categoryLoadCompleteMainThread
{
    catData = cdl.catData;
    //[self loadData];
    
    
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction) searchPressed:(id)sender
{
    [self performSegueWithIdentifier:TO_SEARCH sender:self];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.

    if ([segue.identifier isEqualToString :CATEGORY_DETAIL])

    {
        NSLog(@"here!!!!! %i", selectedRow);
        CategoryDetailVC *catDetailVC = segue.destinationViewController;


        NSInteger catId = [[[self.categoriesInfo objectAtIndex:selectedRow] objectAtIndex:indexOfCategoryId] integerValue];
        NSString *catName =[[self.categoriesInfo objectAtIndex:selectedRow] objectAtIndex:indexOfName];
        
        
        [UserData setCategoryId:[NSString stringWithFormat:@"%i", catId  ]];
        [UserData setCategoryName:catName ];

        [catDetailVC setCategory:[NSString stringWithFormat:@"%i", (int) catId]];
    }
        
}


@end
