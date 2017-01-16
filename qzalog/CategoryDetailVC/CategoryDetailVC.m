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
#import "MapVC.h"


#import "NetTools.h"

@interface CategoryDetailVC () <CategoryDetailListener>
{
    
    //класс для загрузки объявлений
    CategoryDetailDataLoader *cdLoader;
    
    //данные в итоге приезжают в массив
    NSArray<CategoryDetail *> *catDetailArr;
    
    NSMutableString *mapUrl;
    
    
    DBManager *dbManager;
    
    
    int selectedRow;
    
    NSString *categoryId;
    
    
    //достигли ли ипоследнего объявления?
    BOOL lastItemReached;
    
    //сколько объявлений загрузили
    int itemCount;
    
   // float cellHeight;
    
    //float imageHeight;
}

@property(nonatomic, retain) AFHTTPRequestOperationManager  *operationManager;

@end

@implementation CategoryDetailVC

const NSString *TO_SEARCH_FORM = @"toSearchForm";
const NSString *TO_MAP = @"toMap";
const NSString *TO_OBJECT_DETAIL = @"toObjectDetail";

@synthesize segmentedControl;
@synthesize url;
@synthesize titleLabel;
@synthesize objIds;
@synthesize mapButton;


-(void) setCategory:(NSString *)categoryId1
{
    categoryId = categoryId1;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //reduce space between tableview and sort block
    _tableView.contentInset = UIEdgeInsetsMake(8, 0, 0, 0);
    //dynamic row height
     _tableView.estimatedRowHeight = 275.0;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    
    //Высота изображения - высота паддингов в блоке (по идее 32 но с 40 лучше смотрится)
    /*CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    imageHeight = screenWidth * 0.625 - 32;*/
    
    
    if (![NetTools hasConnectivity])
    {
        [self noData: _tableView];
        return;
    }
    
    cdLoader = [CategoryDetailDataLoader new];
    
    [cdLoader setDelegate:self];
    
    
    if (self.objIds == nil)
    {
    if (self.isFavourite == FALSE)
        
    {
    //если url не передан
    if (self.url == nil)
        // загружаем данные категории
        [cdLoader setCategoryId:categoryId];
    else
        // загружаем результаты по параметрам из формы поиска
        [cdLoader setSearchUrl:self.url];
    
   
    // включаем загрузчик
    mapUrl = [cdLoader loadCategoryDetailData];
        
    [mapUrl appendString:@"&map=1"];
    
    lastItemReached = FALSE;
    
    
    // вверху пишем какая категория
    self.titleLabel.text = [UserData categoryName];
    }
    
    else
    {
        //загружаем избранное в загрузчике
        [cdLoader loadFavorite];
        lastItemReached = TRUE;
        segmentedControl.hidden = YES;
        
        self.titleLabel.text = @"Избранное";
        mapButton.hidden = YES;
        _searchButton.hidden = YES;
        
        
        _tableViewTop.constant = 8;
    }
    
    
    }
    else
    {
        [cdLoader loadFromMap:self.objIds];
        lastItemReached = TRUE;
        segmentedControl.hidden = YES;
        
        self.titleLabel.text = @"Объекты";
        
        _tableViewTop.constant = 8;
    }

    itemCount = 0;
    
    
    //подключаем фильтр к контроллеру
    [segmentedControl addTarget:self
                         action:@selector(segmentSwitch:)
               forControlEvents:UIControlEventValueChanged];
    
    //инициируем базу (коннект отрубается после каждого обращения
    dbManager = [[DBManager alloc] initWithDatabaseFilename:  [UserData dbName]];  
    
    segmentedControl.layer.cornerRadius = 5;
    segmentedControl.clipsToBounds = YES;


}



//метод для асинхронной загрузки изображений
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CategoryDetail *cd = catDetailArr[indexPath.row];
    //catDetailArr[selectedRow].catDetId);
    
    if (cell== nil)
    {
        cell = [[CategoryDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: @"categoryDetailCell"];
        
    }
    
    
        
    //сохраняем в ячейке objectId
    [cell setObjectId:cd.catDetId];
    
    // сохраняем в ячейке dbManager
    [cell setDbManager:dbManager];

    
    
    cell.adTextLabel.text = cd.title;
    cell.addrLabel.text = cd.region;
    cell.infoLabel.text = cd.info;
    cell.priceLabel.text = cd.price;
    
    cell.viewOut.layer.cornerRadius = 5;
    
    
    if ([cd.discount length] != 0)
    {
        NSMutableAttributedString *discountString = [[NSMutableAttributedString alloc] initWithString:cd.discount];
    
        // making text property to strike text- NSStrikethroughStyleAttributeName
        [discountString addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [discountString length])];
    
        // using text on label
        [cell.oldPriceLabel  setAttributedText:discountString];
        [cell.oldPriceLabel sizeToFit];
        cell.oldPriceBlock.hidden = NO;
        
    }
    else
    {
        cell.oldPriceBlock.hidden = YES;
    }
   
    
    
    [cell.priceLabel sizeToFit];
    
    cell.adImage.contentMode = UIViewContentModeScaleAspectFill;
    cell.adImage.image = NULL;
    
    
    //асинхронно скачиваем картинки
    [self.operationManager GET:cd.image
                    parameters:nil
                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                           cell.adImage.image = responseObject;
                       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                           NSLog(@"Failed with error %@.", error);
                       }];
    
    
    // достигли низа, но не дна - загружаем еще объявления
    if (!lastItemReached && indexPath.row == [catDetailArr count] - 1)
    {
        itemCount = [catDetailArr count];
        [cdLoader loadCategoryDetailData];
        
        
    }
    
    return cell;
}

//ПРОВЕРить ОПТИМАЛОСТЬ ПОДСТЧЕТА ВЫСОТЫ
/*- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    CategoryDetailCell *cell = [tableView dequeueReusableCellWithIdentifier: @"categoryDetailCell"];
    
    
    CGSize labelSize = [cell.adTextLabel.text sizeWithFont:cell.adTextLabel.font
                                         constrainedToSize:cell.adTextLabel.frame.size
                                             lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat labelHeight = labelSize.height;

    
    [cell layoutIfNeeded];
 
    
    cellHeight = [cell.contentView systemLayoutSizeFittingSize: UILayoutFittingCompressedSize].height + imageHeight + labelHeight;
    NSLog(@"i'm here + %f", cell.contentView.intrinsicContentSize.height);
    
    return cellHeight;
}*/

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [catDetailArr count];
}

// метод при нажатии на фильтр
- (void)segmentSwitch:(UISegmentedControl *)sender {
    
    NSInteger selectedSegment = sender.selectedSegmentIndex;
    
    //NSLog(@"i'm here");
    
    
    
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
        
        

    }
    if ([segue.identifier isEqualToString:TO_OBJECT_DETAIL])
    {
        ObjectDetailVC *odvc = (ObjectDetailVC *) segue.destinationViewController;
        
        
        //передаем objectId в контроллер объявления
        [odvc setObjectId:catDetailArr[selectedRow].catDetId];
        
        
    }
    
    if ([segue.identifier isEqualToString:TO_MAP])
    {
        
        //NSLog(@" jumping TO_MAP");
        MapVC *mvc = (MapVC *) segue.destinationViewController;
        
        
        /*
        NSMutableArray<NSString *> *objArr = [NSMutableArray<NSString *> new];
        for (int i = 0; i < [catDetailArr count]; i++)
        {
            //NSLog(@"objId == %@", catDetailArr[i].catDetId);
            
            [objArr addObject: catDetailArr[i].catDetId];
        } */
        
        //[mvc setObjIds:[objArr copy]];
        [mvc setMapUrl:mapUrl];
    }
}

-(void) categoryDetailLoadFailed
{
    
    NSLog(@"im here, failed"); //,  count == %i",[catDetailArr count]);
    
    [self noData:_tableView];
}


//загрузка данных завершена
-(void) categoryDetailLoadComplete
{
    [self performSelectorOnMainThread:@selector(categoryDetailLoadCompleteMainThread) withObject:nil waitUntilDone:YES];
   
    
}

-(void) categoryDetailLoadCompleteMainThread
{
    catDetailArr = [cdLoader catDetailData];
    
    //достигли последнего элемента
    if (itemCount == [catDetailArr count] )
        lastItemReached = YES;
    else
    {
        //не достигли
        //просто обновляем таблицу
        [self.tableView reloadData];
    }
    
    
    NSLog(@"im here, ciunt == %i",[catDetailArr count]);
    
    if (catDetailArr == nil || catDetailArr.count == 0)
    {
        [self noData:_tableView];
    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    // выбрали объявление
    selectedRow = indexPath.row;
    
    [self performSegueWithIdentifier:TO_OBJECT_DETAIL sender:self];
    
}


// на форму поиска
-(IBAction) jumpToSearchForm : (id) sender
{
    
    [self performSegueWithIdentifier:TO_SEARCH_FORM sender:self];
}

-(IBAction) jumpToMap:(id) sender;
{
    [self performSegueWithIdentifier:TO_MAP sender:self];
}



//назад
-(IBAction) jumpBack: (id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
