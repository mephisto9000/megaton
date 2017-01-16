//
//  ObjectDetailVC.m
//  qzalog
//
//  Created by Mus Bai on 27.11.16.
//  Copyright © 2016 Mus Bai. All rights reserved.
//

#import "ObjectDetailVC.h"
#import "ObjectDetailLoader.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import <GoogleMaps/GoogleMaps.h>
#import "DBManager.h"
#import "ObjectPhotoVC.h"
#import "NetTools.h"
#import "MapVC.h"
#import "UserData.h"

@interface ObjectDetailVC ()
{
    ObjectDetail *objectDetail;
    
    int numRows;
    
    int starMode ;
    
    int currentItemNum;
    
    CALayer *TopBorder;
    
    CALayer *TopBorder2;
    
    UITextView *descTextView;
    
    UITextView *discView;
    
    NSLayoutConstraint *heightNC;
    
    UIActivityIndicatorView *spinner;
    
}

@property(nonatomic, retain) AFHTTPRequestOperationManager  *operationManager;



@end

@implementation ObjectDetailVC

@synthesize starButton;
@synthesize objectId;
@synthesize collectionView;

@synthesize priceLabel;
@synthesize dateLabel;
@synthesize titleLabel;
@synthesize addrLabel;


@synthesize infoView;
@synthesize paramNameLabel;
@synthesize paramValueLabel;
@synthesize contentView;
@synthesize counterLabel;
@synthesize counterBgView;

NSString const *TO_PHOTO = @"toPhoto";
NSString const *TO_MAP1 = @"toMap";

- (AFHTTPRequestOperationManager *)operationManager
{
    if (!_operationManager)
    {
        _operationManager = [[AFHTTPRequestOperationManager alloc] init];
        _operationManager.responseSerializer = [AFImageResponseSerializer serializer];
    };
    
    return _operationManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    ObjectDetailLoader *odl = [ObjectDetailLoader new];
    [odl setDelegate:self];
    numRows = 0;
    currentItemNum = 1;
    if (![NetTools hasConnectivity])
    {
        [self noData:_scrollView];
        return;
    }

    [odl loadData: self.objectId];
    
    DBManager *dbManager = [[DBManager alloc] initWithDatabaseFilename: [UserData dbName]  ];
    
    NSString *query = [NSString stringWithFormat: @"select * from liked where object_id = %@", self.objectId];
    
    NSLog(query);
    
    NSArray *likedInfo = [[NSArray alloc] initWithArray:[dbManager loadDataFromDB:query]];
    
    starMode = 1;
    
    if (likedInfo!=nil && [likedInfo count] > 0)
    {
        [self starClicked:nil];
    }

    counterBgView.hidden = YES;
    _leftArrow.hidden = true;
    
    //for rotation
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(orientationChanged:)
     name:UIDeviceOrientationDidChangeNotification
     object:[UIDevice currentDevice]];
    
    self.scrollView.scrollEnabled = NO;
    self.scrollView.userInteractionEnabled = NO;
    _scrollView.hidden = YES;
    

    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.center = CGPointMake(self.view.frame.size.width / 2 - spinner.frame.size.width / 2, self.view.frame.size.height / 2 - spinner.frame.size.height / 2);
    spinner.tag = 50;
    [self.view addSubview:spinner];
    [spinner startAnimating];
   // [spinner release];
    
}

-(void) loadObjectDetailFailed
{
    [self noData:_scrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return numRows;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:TO_PHOTO sender:self];
    
}

-(IBAction)leftPressed:(id)sender
{
    if (currentItemNum <= 1){
        return;
    }
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:currentItemNum-2 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    currentItemNum --;
    counterLabel.text = [NSString stringWithFormat:@"%i/%i", currentItemNum, numRows];
    if (currentItemNum == 1){
        _leftArrow.hidden = true;
    }
    _rightArrow.hidden = false;
}

-(IBAction)rightPressed:(id)sender
{
    if (currentItemNum >= numRows){
        return;
    }
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:currentItemNum inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
    currentItemNum++;
    counterLabel.text = [NSString stringWithFormat:@"%i/%i", currentItemNum, numRows];
    if (currentItemNum == numRows){
        _rightArrow.hidden = true;
    }
    _leftArrow.hidden = false;
    
}



- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    CGRect visibleRect = (CGRect){.origin = self.collectionView.contentOffset, .size = self.collectionView.bounds.size};
    CGPoint visiblePoint = CGPointMake(CGRectGetMidX(visibleRect), CGRectGetMidY(visibleRect));
    NSIndexPath *visibleIndexPath = [self.collectionView indexPathForItemAtPoint:visiblePoint];
    
    
    counterLabel.text = [NSString stringWithFormat:@"%i/%i", visibleIndexPath.row +1, numRows];
    
    if (visibleIndexPath.row < 1){
        _leftArrow.hidden = true;
       
    }else{
        _leftArrow.hidden = false;
        if(visibleIndexPath.row == (numRows - 1)){
            _rightArrow.hidden = true;
        }else{
            _rightArrow.hidden = false;
        }
    }
    currentItemNum = visibleIndexPath.row +1;
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                           cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"objectDetailCollectionCell" forIndexPath:indexPath];
    
    [self.operationManager GET:  objectDetail.images[indexPath.row].big
                    parameters:nil
                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                           //cell..adImage.image = responseObject;
                           cell.backgroundView = [[UIImageView alloc] initWithImage:responseObject];
                           NSLog(@"image download complete");
                           
                           
                       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                           NSLog(@"Failed with error %@.", error);
                       }];
    return cell;
}

-(void) loadObjectDetailComplete : (ObjectDetail *) objectDetail
{
    self->objectDetail = objectDetail;
    
    NSLog(@"object detail complete");
    
    NSLog(@"title == %@",self->objectDetail.title);
    
    [self performSelectorOnMainThread:@selector(loadOnMainThread) withObject:nil waitUntilDone:NO];
    
}



-(void) loadOnMainThread
{
    self.titleLabel.text    = self->objectDetail.title;
    self.dateLabel.text     = self->objectDetail.dateCreated; // sub;
    self.priceLabel.text    = self->objectDetail.price;
    self.addrLabel.text     = self->objectDetail.address;
    
    numRows = [self->objectDetail.images count];
    
    //[self.contentView sizeToFit];
    //[self.scrollView sizeToFit];
    
    //self.scrollView.scrollEnabled = YES;
    //self.scrollView.delegate = self;
    
    
    
    switch([self->objectDetail.infoArray count] )
    {
        case 0:
            break;
        case 1:
            self.paramNameLabel.text = self->objectDetail.infoArray[0].title;
            self.paramValueLabel.text = self->objectDetail.infoArray[0].value;
            break;
        default:
            self.paramNameLabel.text = self->objectDetail.infoArray[0].title;
            self.paramValueLabel.text = self->objectDetail.infoArray[0].value;
            
            for (int i = 1; i < [self->objectDetail.infoArray count]; i++)
            {
                CGRect r1 = self.paramNameLabel.frame;
                CGRect r2 = self.paramValueLabel.frame;

                UILabel *tmpParamNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(r1.origin.x, r1.origin.y+22, r1.size.width, r1.size.height)];
                UILabel *tmpParamValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(r2.origin.x, r2.origin.y+22, r2.size.width, r2.size.height)];
                [tmpParamValueLabel setTextAlignment:NSTextAlignmentRight];
                [tmpParamNameLabel setFont:[UIFont systemFontOfSize:12]];
                [tmpParamNameLabel setTextColor:[UIColor colorWithRed:125.0/255.0 green:125.0/255.0 blue:125.0/255.0 alpha:1.0]];
                [tmpParamValueLabel setFont:[UIFont systemFontOfSize:12]];
                tmpParamNameLabel.text =self->objectDetail.infoArray[i].title;
                tmpParamValueLabel.text =self->objectDetail.infoArray[i].value;

                [self.infoView addSubview:tmpParamNameLabel];

                [self.infoView addSubview:tmpParamValueLabel];
                
                tmpParamNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
                NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:tmpParamNameLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:infoView attribute:NSLayoutAttributeTop multiplier:1 constant:r1.origin.y+22];
                 NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:tmpParamNameLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:infoView attribute:NSLayoutAttributeLeft multiplier:1 constant:8];
                [infoView addConstraints:@[top, left]];
                
                
                tmpParamValueLabel.translatesAutoresizingMaskIntoConstraints = NO;
                top = [NSLayoutConstraint constraintWithItem:tmpParamValueLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:infoView attribute:NSLayoutAttributeTop multiplier:1 constant:r1.origin.y+22];
                NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:tmpParamValueLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:infoView attribute:NSLayoutAttributeRight multiplier:1 constant:-8];
                [infoView addConstraints:@[top, right]];
                
               self.paramNameLabel = tmpParamNameLabel;
               self.paramValueLabel = tmpParamValueLabel;
            }
            break;
    }
    
    //self->objectDetail.description = @"";
    if ( [self->objectDetail.description length] != 0 ){
        
        // add description
        CGRect r1 = self.paramNameLabel.frame;

        //Костыль на случай елси нет в описании параметров
        if (!self->objectDetail.infoArray || !self->objectDetail.infoArray.count){
            r1.origin.y = r1.origin.y - 50;
        }

        discView=[[UIView alloc]initWithFrame:CGRectMake(0, r1.origin.y+25, self.infoView.bounds.size.width, 200)];

        TopBorder2 = [CALayer layer];
        TopBorder2.frame = CGRectMake(-8.0f, 0.0f, self.infoView.bounds.size.width+8, 1.0f);
        TopBorder2.backgroundColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0].CGColor;
        [discView.layer addSublayer:TopBorder2];

        UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 8, r1.size.width, r1.size.height)];

        [descLabel setText:@"Описание:"];
        [descLabel setFont:[UIFont systemFontOfSize: 14]];
        [descLabel sizeToFit];
        [discView addSubview:descLabel];
        [self.infoView addSubview:discView];
    
        discView.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:discView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:infoView attribute:NSLayoutAttributeTop multiplier:1 constant:r1.origin.y+25];
        NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:discView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:infoView attribute:NSLayoutAttributeRight multiplier:1 constant:-8];
        NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:discView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:infoView attribute:NSLayoutAttributeLeft multiplier:1 constant:8];
        
        [infoView addConstraints:@[top, right, left]];

        r1 = descLabel.frame;
        descTextView = [[UITextView alloc ] initWithFrame:CGRectMake(8, r1.origin.y+24, self.infoView.bounds.size.width - 16, 100)];
        [descTextView setText:self->objectDetail.description];
        [descTextView setFont:[UIFont systemFontOfSize:12]];
        [descTextView sizeToFit];
        descTextView.textContainerInset = UIEdgeInsetsMake(3, -5, 3, 0);
        [descTextView setScrollEnabled:NO];
        [discView sizeToFit];

        [discView addSubview:descTextView];
        [self.infoView addSubview:discView];
        
        CGSize sizeThatFitsTextView = [descTextView sizeThatFits:CGSizeMake(descTextView.frame.size.width, MAXFLOAT)];
        heightNC = [NSLayoutConstraint constraintWithItem:discView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:sizeThatFitsTextView.height + 32];

        descTextView.translatesAutoresizingMaskIntoConstraints = NO;
        top = [NSLayoutConstraint constraintWithItem:descTextView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:discView attribute:NSLayoutAttributeTop multiplier:1 constant:27];
        right = [NSLayoutConstraint constraintWithItem:descTextView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:discView attribute:NSLayoutAttributeRight multiplier:1 constant:0];
        left = [NSLayoutConstraint constraintWithItem:descTextView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:discView attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
         NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:descTextView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:discView attribute:NSLayoutAttributeBottom multiplier:1 constant:200];
        [discView addConstraints:@[top, right, left,  heightNC]];
    }

    // add discount
    if (self->objectDetail.discount != nil)
    {
        [self.priceLabel sizeToFit];
        CGRect r = self.priceLabel.frame;
        UILabel *discountLabel = [[UILabel alloc] initWithFrame:CGRectMake(r.origin.x + 15 + r.size.width, r.origin.y, r.size.width, r.size.height)];
        
        NSMutableAttributedString *discountString = [[NSMutableAttributedString alloc] initWithString:self->objectDetail.discount];
        
        [discountString addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [discountString length])];
        [discountLabel setFont:self.priceLabel.font];
        [discountLabel setTextColor :self.dateLabel.textColor];
        [discountLabel setAttributedText:discountString];
        [discountLabel sizeToFit];
        
        [self.priceLabel.superview addSubview:discountLabel];
    }
    
    if (!self->objectDetail.infoArray || !self->objectDetail.infoArray.count){
         self.middltLabel.hidden = YES;
         self.paramNameLabel.hidden = YES;
         self.paramValueLabel.hidden = YES;
    } else{
        TopBorder = [CALayer layer];
        TopBorder.frame = CGRectMake(-8.0f, 0.0f, _middleView.bounds.size.width+8, 1.0f);
        TopBorder.backgroundColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0].CGColor;
        [_middleView.layer addSublayer:TopBorder];
    }

    //[super viewDidLoad];

    
    CALayer *layer = self.view.layer;
    [layer setNeedsDisplay];
    [layer displayIfNeeded];
    
    [self.collectionView reloadData];
    counterBgView.hidden = NO;
    
    if(numRows == 0){
        //collectionView.hidden = YES;
        _rightArrow.hidden = YES;
        _leftArrow.hidden = YES;
        counterBgView.hidden = YES;
        UICollectionViewFlowLayout *flowLayout = (id)self.collectionView.collectionViewLayout;
        CGSize size = collectionView.bounds.size;
        NSInteger width2 = size.width;
        NSInteger height2 = 0;
    
        flowLayout.itemSize = CGSizeMake(width2, height2);
        [flowLayout invalidateLayout];
        [collectionView removeConstraints:collectionView.constraints];
        
    }
    
    counterLabel.text = [NSString stringWithFormat:@"1/%i",  numRows];
    
    [self.contentView sizeToFit];
    [self.scrollView sizeToFit];
    

    
    self.scrollView.scrollEnabled = YES;
    self.scrollView.userInteractionEnabled = YES;
    self.scrollView.hidden = NO;
    spinner.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    CGRect contentRect = CGRectZero;
    float heightH = 0.0f;
    for (UIView *view in self.infoView.subviews) {
        contentRect = CGRectUnion(contentRect, view.frame);
        heightH = heightH + view.frame.size.height;
        
    }
    //Хак
    contentRect.size.height= contentRect.size.height - heightNC.constant;
    CGSize sizeThatFitsTextView = [descTextView sizeThatFits:CGSizeMake(descTextView.frame.size.width, MAXFLOAT)];
    heightNC.constant=sizeThatFitsTextView.height + 32;
    contentRect.size.height= contentRect.size.height + heightNC.constant;
    
    self.infoView.frame  = CGRectMake(0, self.infoView.frame.origin.y,  self.infoView.frame.size.width, contentRect.size.height );
    CGRect contentRect2 = CGRectZero;
    for (UIView *view in self.topView.subviews) {
        contentRect2 = CGRectUnion(contentRect, view.frame);
    }
    CGFloat height = CGRectGetHeight(self.topView.bounds);
    float bottomSpace = 44;
    if ( [self->objectDetail.description length] == 0 ){
        bottomSpace = 52;
    }
    float allHeight = height + contentRect.size.height + collectionView.bounds.size.height + bottomSpace;
    self.scrollView.contentSize = CGSizeMake(_scrollView.bounds.size.width, allHeight );
    
    //hak
    if(numRows != 0){
        UICollectionViewFlowLayout *flowLayout = (id)self.collectionView.collectionViewLayout;
        CGSize size = collectionView.bounds.size;
        NSInteger width2 = size.width;
        NSInteger height2 = size.height;
        _rightArrow.center = CGPointMake(width2 - 28, height2/2);
        _leftArrow.center = CGPointMake(28, height2/2);
        
        flowLayout.itemSize = CGSizeMake(width2, height2);
        [flowLayout invalidateLayout];
    }
     spinner.hidden = YES;
   
    
}

#pragma mark collection view cell layout / size

- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize size = collectionView.bounds.size;
    NSInteger width = size.width;
    NSInteger height = size.height;
    
    _rightArrow.center = CGPointMake(width - 28, height/2);
    _leftArrow.center = CGPointMake(28, height/2);
    
    return CGSizeMake(width, height);
}

- (void) orientationChanged:(NSNotification *)note
{
    UIDevice * device = note.object;
    
    UICollectionViewFlowLayout *flowLayout = (id)self.collectionView.collectionViewLayout;
    CGSize size = collectionView.bounds.size;
    NSInteger width = size.width;
    NSInteger height = size.height;
    _rightArrow.center = CGPointMake(width - 28, height/2);
    _leftArrow.center = CGPointMake(28, height/2);
    
    flowLayout.itemSize = CGSizeMake(width, height);
    [flowLayout invalidateLayout];
    
    //[self viewDidLoad];
    [self viewWillAppear:YES];
    [self viewDidAppear:YES];
    
    [TopBorder removeFromSuperlayer];
    TopBorder = [CALayer layer];
    TopBorder.frame = CGRectMake(-8.0f, 0.0f, _middleView.bounds.size.width + 8, 1.0f);
    TopBorder.backgroundColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0].CGColor;
    [_middleView.layer addSublayer:TopBorder];
    
    [TopBorder2 removeFromSuperlayer];
    TopBorder2 = [CALayer layer];
    TopBorder2.frame = CGRectMake(-8.0f, 0.0f, self.infoView.bounds.size.width+8, 1.0f);
    TopBorder2.backgroundColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0].CGColor;
    [discView.layer addSublayer:TopBorder2];
    
}




#pragma mark collection view cell paddings
- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0); // top, left, bottom, right
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 5.0;
}

-(IBAction) callButtonClicked :(id) sender
{
    
    
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Позвонить"
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    
    
    for (NSString *title in objectDetail.phones) {
        [actionSheet addButtonWithTitle:title];
    }
    
    actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:@"Отмена"];
    
    [actionSheet showInView:self.view];
    
    
}

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
   
    
    if (buttonIndex >= [objectDetail.phones count])
        return;
    
   
    
    NSString *a1 =   [objectDetail.phones[buttonIndex]
                                                    stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *a2 = [a1 stringByReplacingOccurrencesOfString:@"(" withString:@""];
    NSString *a3 = [a2 stringByReplacingOccurrencesOfString:@")" withString:@""];
    
    NSString *phoneNumber = [@"tel://" stringByAppendingString:a3];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    
}

-(IBAction) backClicked: (id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}


-(IBAction) starClicked: (id)sender
{
    NSLog(@"object id == %@", self.objectId);
    
    NSString *query;
    if (starMode == 1)
    {
        starMode = 2;
        [starButton setImage:  [UIImage imageNamed:@"star_white.png"] forState:UIControlStateNormal];
        
        query = [NSString stringWithFormat:@"insert into liked (object_id) values( %@ )", self.objectId ];
    }
    else
    {
        starMode = 1;
        [starButton setImage: [UIImage imageNamed:@"star_white_empty.png"] forState:UIControlStateNormal];
        
        
        query = [NSString stringWithFormat:@"delete from liked where object_id =  %@ ", self.objectId ];
    }
    
    NSLog (query);
    DBManager *dbManager = [[DBManager alloc] initWithDatabaseFilename: [UserData dbName] ];
    
    [dbManager executeQuery:query];
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:TO_PHOTO])
    {
        ObjectPhotoVC *opvc = (ObjectPhotoVC *) segue.destinationViewController;
        
        //objectDetail.images[indexPath.row].big
        NSMutableArray<NSString *> *images = [NSMutableArray<NSString *> new];
        
        for (int i = 0; i < [objectDetail.images count]; i++)
        {
            [images addObject:objectDetail.images[i].big];
        }
        
        [opvc setImageArr:images];
        [opvc setCurrentItemNum: currentItemNum];
    }
    
    if ([segue.identifier isEqualToString:TO_MAP1])
    {
        MapVC *mapVC = (MapVC *) segue.destinationViewController;
        //mapVC setMapUrl:<#(NSString *)#>
        
        [mapVC loadDataForSingleObject: objectId  coord_x: objectDetail.coordX coord_y: objectDetail.coordY];
    }
}


-(IBAction)pinClicked:(id)sender
{
    [self performSegueWithIdentifier:TO_MAP1 sender:self];
    
}


@end
