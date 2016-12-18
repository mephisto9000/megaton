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

@interface ObjectDetailVC ()
{
    ObjectDetail *objectDetail;
    
    int numRows;
    
    int starMode ;
    
    int currentItemNum;
    
    
}

@property(nonatomic, retain) AFHTTPRequestOperationManager  *operationManager;
@property(nonatomic, retain) IBOutlet GMSMapView *mapView;


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
    // Do any additional setup after loading the view.

    ObjectDetailLoader *odl = [ObjectDetailLoader new];
    
    [odl setDelegate:self];
    
    numRows = 0;
    currentItemNum = 1;
    
    /*
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    //flow.itemSize = CGSizeMake(cellWidth, cellHeight);
    flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flow.minimumInteritemSpacing = 0;
    flow.minimumLineSpacing = 0;
    
    self.scrollView.flo */
    
    if (![NetTools hasConnectivity])
    {
        [self noData:_scrollView];
        return;
    }

    [odl loadData: self.objectId];
    
    
    DBManager *dbManager = [[DBManager alloc] initWithDatabaseFilename:@"qzalog.db"];
    
    NSString *query = [NSString stringWithFormat: @"select * from liked where object_id = %@", self.objectId];
    
    NSLog(query);
    
    NSArray *likedInfo = [[NSArray alloc] initWithArray:[dbManager loadDataFromDB:query]];
    
    
    starMode = 1;
    
    if (likedInfo!=nil && [likedInfo count] > 0)
    {
        [self starClicked:nil];
    }
    
    
    
    
    counterBgView.hidden = YES;
    
    
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
    
    //[self presentViewController:playerVC animated:YES completion:nil];
    [self performSegueWithIdentifier:TO_PHOTO sender:self];
    
}



- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGRect visibleRect = (CGRect){.origin = self.collectionView.contentOffset, .size = self.collectionView.bounds.size};
    CGPoint visiblePoint = CGPointMake(CGRectGetMidX(visibleRect), CGRectGetMidY(visibleRect));
    NSIndexPath *visibleIndexPath = [self.collectionView indexPathForItemAtPoint:visiblePoint];
    
    
    counterLabel.text = [NSString stringWithFormat:@"%i/%i", visibleIndexPath.row +1, numRows];
    
    currentItemNum = visibleIndexPath.row +1;
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                           cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"objectDetailCollectionCell" forIndexPath:indexPath];
    
     //NSLog(@"%i", indexPath.row);
    
    
    
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

    
    //return nil;
}




-(void) loadObjectDetailComplete : (ObjectDetail *) objectDetail
{
    self->objectDetail = objectDetail;
    
    NSLog(@"object detail complete");
    
    NSLog(@"title == %@",self->objectDetail.title);
    
    [self performSelectorOnMainThread:@selector(loadOnMainThread) withObject:nil waitUntilDone:YES];
    
}



-(void) loadOnMainThread
{
    self.titleLabel.text    = self->objectDetail.title;
    self.dateLabel.text     = self->objectDetail.dateCreated; // sub;
    self.priceLabel.text    = self->objectDetail.price;
    self.addrLabel.text     = self->objectDetail.address;
    
    numRows = [self->objectDetail.images count];
    
    switch([self->objectDetail.infoArray count] )
    {
        case 0:
            self.infoView.hidden = YES;
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
                //CGRectMake(..., expectedSize.height)];
                
                CGRect r1 = self.paramNameLabel.frame;
                CGRect r2 = self.paramValueLabel.frame;
                //+20
                //+20
                UILabel *tmpParamNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(r1.origin.x, r1.origin.y+25, r1.size.width, r1.size.height)];
                UILabel *tmpParamValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(r2.origin.x, r2.origin.y+25, r2.size.width, r2.size.height)];
                
                [tmpParamValueLabel setTextAlignment:NSTextAlignmentRight];
                
                [tmpParamNameLabel setFont:[UIFont systemFontOfSize:12]];
                [tmpParamValueLabel setFont:[UIFont systemFontOfSize:12]];
                //tmpParamNameLabel.frame.origin.x += 20;
                
                tmpParamNameLabel.text =self->objectDetail.infoArray[i].title;
                tmpParamValueLabel.text =self->objectDetail.infoArray[i].value;
                
                //                [self.infoView addSubview:tmpParamNameLabel below
                [self.infoView addSubview:tmpParamNameLabel];
                //[self.infoView insertSubview:tmpParamNameLabel belowSubview:self.paramNameLabel];
                //[self.infoView insertSubview:tmpParamValueLabel belowSubview:self.paramValueLabel];
                
                
                
                [self.infoView addSubview:tmpParamValueLabel];
                
                self.paramNameLabel = tmpParamNameLabel;
                self.paramValueLabel = tmpParamValueLabel;
            }
            break;
    }
    
    
    NSLog(@"done");
    
    
    [self performSelectorOnMainThread:@selector(setMap) withObject:nil waitUntilDone:YES];
    
    
    
    
    //[self.infoView   setNeedsDisplay];
    
    //[self performSelectorOnMainThread:@selector(setNeedsDisplay) withObject:self.view waitUntilDone:TRUE];
    
    
    CGRect contentRect = CGRectZero;
    for (UIView *view in self.infoView.subviews) {
        contentRect = CGRectUnion(contentRect, view.frame);
    }
    
    int width  = self.infoView.frame.size.width;
    
    
    self.infoView.frame  = CGRectMake(0, self.infoView.frame.origin.y,  contentRect.size.width, contentRect.size.height );
    
    [self.mapView setFrame:CGRectMake(0, self.infoView.frame.origin.y + self.infoView.frame.size.height, self.mapView.frame.size.width, self.mapView.frame.size.height)];
    
    //self.mapView.userInteractionEnabled = YES;
    
    //self.mapView setSc
    
    //self.scrollView.contentSize = contentRect.size;
    //self.scrollView.scrollEnabled = YES;
    
    CGRect contentRect1 = CGRectZero;
    for (UIView *view in self.contentView.subviews) {
        contentRect1 = CGRectUnion(contentRect1, view.frame);
    }
    
    //self.scrollView.contentSize = contentRect1.size*2;
    [self.contentView setFrame:CGRectMake(0, self.contentView.frame.origin.y,  width, contentRect1.size.height) ]; //  contentRect1.size];  //setContentSize
    
    CALayer *layer = self.view.layer;
    [layer setNeedsDisplay];
    [layer displayIfNeeded];
    
    
    [self.collectionView reloadData];
    
    //[self.scrollView setNeedsDisplay];
    //[self performSelectorOnMainThread:@selector(setNeedsDisplay) withObject:self.scrollView waitUntilDone:TRUE];
    
    counterBgView.hidden = NO;
    
    NSLog(@"numrows == %i", numRows);
    counterLabel.text = [NSString stringWithFormat:@"1/%i",  numRows];
    
}

-(void) setMap{
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(self->objectDetail.coordX, self->objectDetail.coordY);
    marker.title = self->objectDetail.title;
    marker.snippet = self->objectDetail.description;
    marker.map = self.mapView;
    
    
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self->objectDetail.coordX
                                                            longitude:self->objectDetail.coordY
                                                                 zoom:14];
    
    [self.mapView setCamera:camera];
    self.mapView.myLocationEnabled = YES;
    
    

}


#pragma mark collection view cell layout / size
/*
- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self getCellSize:indexPath];  // will be w120xh100 or w190x100
    // if the width is higher, only one image will be shown in a line
}
*/


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
        [starButton setBackgroundImage:  [UIImage imageNamed:@"star_white.png"] forState:UIControlStateNormal];
        
        query = [NSString stringWithFormat:@"insert into liked (object_id) values( %@ )", self.objectId ];
    }
    else
    {
        starMode = 1;
        [starButton setBackgroundImage: [UIImage imageNamed:@"star_white_empty.png"] forState:UIControlStateNormal];
        
        
        query = [NSString stringWithFormat:@"delete from liked where object_id =  %@ ", self.objectId ];
    }
    
    NSLog (query);
    DBManager *dbManager = [[DBManager alloc] initWithDatabaseFilename:@"qzalog.db"];
    
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
}


@end
