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
#import "NetTools.h"


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
@property (weak, nonatomic) IBOutlet UIView *salesWay;

-(void)loadData;

@end

@implementation CategoryVC

const NSString *SALES_PAGE = @"toSaleWays";
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
    
    
    
    //забираем данные для ячеек категорий из 2-мерного массива categoriesInfo
    NSInteger catId = [[[self.categoriesInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfCategoryId] integerValue];
    
    //объект категорию забираем из ассоциативного массива catData по catId
    Category *cat = (Category *)[catData objectForKey: [NSNumber numberWithInteger:catId]];
    
    
    // поля смотрим на дизайне в ячейке categoryCell
    cell.titleLabel.text = [NSString stringWithFormat:@"%@", [[self.categoriesInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfName]];
    
    NSLog(@"cat amount == %li", (long)[cat amount]);
    NSLog(@"cat name == %@", cat.title);
    cell.countLabel.text =  [NSString stringWithFormat:@"%ld", (long)[cat amount]];
    
    
    
    NSString *fname = [NSString stringWithFormat:@"category%d.png", catId];
    
    NSLog(@"fname == %@", fname);
    
    cell.imageView.image = [UIImage imageNamed:fname];
    return cell;
}

//щелкнули по ячейке
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    //запомним выбранную ячейку
    selectedRow = (int) indexPath.row;
    
    //переходим на контроллер CategoryDetail
    [self performSegueWithIdentifier:CATEGORY_DETAIL sender:self];
    
}


//подгрузка данных по категориям из базы
-(void) loadData
{
    
    NSLog(@"loading data");
    NSString *query = @"select * from categories";
    
    // Get the results.
    if (self.categoriesInfo != nil) {
        self.categoriesInfo = nil;
    }
    self.categoriesInfo = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    //запоминаем на каких индексах нужные поля
    indexOfId = [self.dbManager.arrColumnNames indexOfObject:@"id"];
    indexOfName = [self.dbManager.arrColumnNames indexOfObject:@"name"];
    indexOfCategoryId = [self.dbManager.arrColumnNames indexOfObject:@"category_id"];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //загружаем базу
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"qzalog.db"];
    
    //после ждем когда данные загрузятся
    [self loadData];
    
    
    //загрузка данных по количеству объявлений категорий
    if ([NetTools hasConnectivity])
    {
        cdl = [CategoryDataLoader new];
        [cdl setDelegate:self];
        [cdl loadCategoryData];
    }
    else
    {
        [self noData:tableView];
        
    }
    
    //Click event on link (UIView) of sales info
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [_salesWay addGestureRecognizer:singleFingerTap];
    
    
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    [self performSegueWithIdentifier:SALES_PAGE sender:self];
}

-(void) categoryLoadError
{
     [self noData:tableView];
}

//загрузка категорий закончена
-(void) categoryLoadComplete
{
    NSLog(@"category load complete");
    
    //обновляем вид в главном потоке (без этого тупит)
    [self performSelectorOnMainThread:@selector(categoryLoadCompleteMainThread) withObject:nil waitUntilDone:YES];
    
    
    
}



-(IBAction) backPressed : (id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void) categoryLoadCompleteMainThread
{
    
    NSLog(@"in categoryLoadCompleteMainThread method");
    catData = cdl.catData;
    
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

    
    //если щелкнули по категории и переходим на детали категорий - добавляем в контроллер categoryId и categoryName
    if ([segue.identifier isEqualToString :CATEGORY_DETAIL])
    {
        CategoryDetailVC *catDetailVC = segue.destinationViewController;

        NSInteger catId = [[[self.categoriesInfo objectAtIndex:selectedRow] objectAtIndex:indexOfCategoryId] integerValue];
        NSString *catName =[[self.categoriesInfo objectAtIndex:selectedRow] objectAtIndex:indexOfName];
        
        [UserData setCategoryId:[NSString stringWithFormat:@"%i", catId  ]];
        [UserData setCategoryName:catName ];

        [catDetailVC setCategory:[NSString stringWithFormat:@"%i", (int) catId]];
    }
        
}


@end
