//
//  ObjectPhotoVC.m
//  qzalog
//
//  Created by Mus Bai on 17.12.16.
//  Copyright © 2016 Mus Bai. All rights reserved.
//

#import "ObjectPhotoVC.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>

@interface ObjectPhotoVC (){
    int numItems;
    CGRect screenRect;
    CGFloat  screenWidth;
    int screenDivide;
    Boolean loaded;
  
    
}

@property(nonatomic, retain) AFHTTPRequestOperationManager  *operationManager;

@end


@implementation ObjectPhotoVC


@synthesize photoCollection;
@synthesize imageArr;
@synthesize currentItemNum;
@synthesize counterLabel;
@synthesize counterLabel2;
@synthesize counterBgView;

@synthesize toolbar;



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
    loaded = false;
    // Do any additional setup after loading the view.
    
    numItems = 0;
    
    if (imageArr != nil)
    {
        numItems = [imageArr count];
    }
    
    
    
    if (currentItemNum == 0){
        currentItemNum = 1;
    }
    if (currentItemNum == 1){
        _leftArrow.hidden = true;
    }
    if (currentItemNum == numItems){
        _rightArrow.hidden = true;
    }
    
    [self.counterLabel2 setText:[NSString stringWithFormat:@"Изображение %i/%i", currentItemNum, numItems]];
    
    [counterBgView setHidden:YES];
    
    //[photoCollection
     //selectItemAtIndexPath:[NSIndexPath indexPathForItem:(currentItemNum - 1) inSection:0]
     //animated:YES
     //scrollPosition:UICollectionViewScrollPositionCenteredVertically];
     //photoCollection.selectItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0), animated: false, scrollPosition: .None)
    
    
   
    //for rotation
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(orientationChanged:)
     name:UIDeviceOrientationDidChangeNotification
     object:[UIDevice currentDevice]];
    
    
   /*self.scale = 1.0;
    UIPinchGestureRecognizer *gesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(didReceivePinchGesture:)];
    [self.photoCollection addGestureRecognizer:gesture];*/

}

/*
- (void)didReceivePinchGesture:(UIPinchGestureRecognizer*)gesture
{
    static CGFloat scaleStart;
    
    NSLog(@"%f", self.scale);

    
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        scaleStart = self.scale;
        _lastPoint = [gesture locationInView:gesture.view];
    }
    else if (gesture.state == UIGestureRecognizerStateChanged)
    {
        self.scale = scaleStart * gesture.scale;
        if(self.scale > 3)
            self.scale = 3;
        if(self.scale < 1)
            self.scale = 1;
        
        if(self.scale != 1)
            self.photoCollection.scrollEnabled = NO;
        else
            self.photoCollection.scrollEnabled = YES;
        
        
        [self.photoCollection.collectionViewLayout invalidateLayout];
    }
}
*/



/*
- (void) orientationChanged:(NSNotification *)note
{
    loaded = false;
    UIDevice * device = note.object;
    
    UICollectionViewFlowLayout *flowLayout = (id)self.photoCollection.collectionViewLayout;
    CGSize size = photoCollection.bounds.size;
    NSInteger width = size.width;
    NSInteger height = size.height;

    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    flowLayout.itemSize = CGSizeMake(width, height);
    [flowLayout invalidateLayout];
    
    _toolbarHeight.constant = 44;
    [self viewWillAppear:YES];
    
    
    [self viewDidAppear:YES];
    [self.photoCollection  scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:(currentItemNum - 1) inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        
}*/


- (void)viewDidLayoutSubviews
{
    [self.photoCollection layoutIfNeeded];
    if(loaded == false){
        [self.photoCollection  scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:(currentItemNum - 1) inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        loaded = true;
    }
}

/*

- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat top = self.topLayoutGuide.length;
    CGFloat bottom = self.bottomLayoutGuide.length;
    UIEdgeInsets newInsets = UIEdgeInsetsMake(top, 0, bottom, 0);
    self.photoCollection.contentInset = newInsets;
    
} */



/*
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.photoCollection  scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:(currentItemNum - 1) inSection:0]
                                atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    
 
    
    //photoCollection scrollToIte
    
    [photoCollection reloadData];
    
    
    
    
    
}*/
/*
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
*/
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return numItems;
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                           cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photoCollectionCell" forIndexPath:indexPath];
    
    //NSLog(@"%i", indexPath.row);
    
    
    
    [self.operationManager GET:  imageArr[indexPath.row] 
                    parameters:nil
                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                           //cell..adImage.image = responseObject;
                           //cell.backgroundView = [[UIImageView alloc] initWithImage:responseObject];
                           //cell.backgroundView.contentMode = UIViewContentModeScaleAspectFit;
                           NSLog(@"image download complete");
                           
                           
                           
                           
                           
                           UIScrollView *scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
                           scrollview.contentSize = CGSizeMake(cell.frame.size.width, cell.frame.size.height);
                           
                           
                           UIView *scollSubView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
                           [scrollview addSubview:scollSubView];
                           scrollview.backgroundColor = [UIColor yellowColor];
                           
                           //scrollview.indicatorStyle = UIScrollViewIndicatorStyleWhite;
                           
                           /*scrollview.minimumZoomScale = 1.0f;
                           scrollview.maximumZoomScale = 3.0f;
                           scrollview.zoomScale = 1.0f;*/
                          /* scrollview.delegate = self;
                           scrollview.bouncesZoom = YES;
                           scrollview.clipsToBounds = YES;
                           scrollview.backgroundColor = [UIColor yellowColor];
                           [scrollview setContentMode:UIViewContentModeScaleAspectFit];*/
                           
                       
                           
                           UIImageView *imageView = [[UIImageView alloc] initWithImage:responseObject];
                           [imageView setCenter:scrollview.center];
                           [imageView setContentMode:UIViewContentModeScaleAspectFill];
                           CGFloat aspect = imageView.frame.size.width / imageView.frame.size.height;
                           
                           imageView.frame = CGRectMake(0 , 0, cell.frame.size.width, cell.frame.size.width/aspect);
                           [imageView setCenter:scrollview.center];
                           [imageView setContentMode:UIViewContentModeScaleAspectFill];
                           [scollSubView addSubview:imageView];

                           //imageView.userInteractionEnabled = YES;
                           

                           
                           UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGestureDetected:)];
                           pinchGestureRecognizer.cancelsTouchesInView = NO;
                                                     pinchGestureRecognizer.delaysTouchesEnded = NO;
                           [scrollview addGestureRecognizer:pinchGestureRecognizer];
                           
                          
                           
                           TapGestureRecognizer *tapGestureRecognizer = [[TapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureDetected:)];
                         
                           [scrollview addGestureRecognizer:tapGestureRecognizer];
                           
                           
                           
                           
                           
                           
                           
                           UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureDetected:)];
                          
                           [scrollview addGestureRecognizer:panGestureRecognizer];
                           
                           
                           [cell addSubview:scrollview];
                           
                           
                           
                           
                           
                       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                           NSLog(@"Failed with error %@.", error);
                       }];
    
    
    
    
    return cell;
    
    
    //return nil;
}


- (void)tapGestureDetected:(TapGestureRecognizer *)recognizer {
    UIGestureRecognizerState state = [recognizer state];
    NSLog(@"Begsdafan");
}

- (void)panGestureDetected:(UIPanGestureRecognizer *)recognizer
{
    UIGestureRecognizerState state = [recognizer state];
    
    if (state == UIGestureRecognizerStateEnded)
    {
       // NSLog(@"Begsdafan");

    }
}

-(void) pinchGestureDetected: (UIPinchGestureRecognizer *) pinchRecogniser
{
    static CGFloat scaleStart;
    static CGPoint lastPoint;
    
    
    switch ([pinchRecogniser state])
    {
        case UIGestureRecognizerStateBegan:
        {
            NSLog(@"Began");
            [photoCollection setScrollEnabled: NO];
            scaleStart = 1.0f;
            lastPoint = [pinchRecogniser locationInView:[pinchRecogniser view]];
            break;
        }
            
        case UIGestureRecognizerStateChanged:
        {
            CGFloat currentScale = [[[pinchRecogniser view].layer valueForKeyPath:@"transform.scale"] floatValue];
            
            // Constants to adjust the max/min values of zoom
            const CGFloat kMaxScale = 2.0;
            const CGFloat kMinScale = 0.5;
            
            CGFloat scale = 1.0f - (scaleStart - pinchRecogniser.scale);
            scale = MIN(scale, kMaxScale / currentScale);
            scale = MAX(scale, kMinScale / currentScale);
           // CGFloat scale = [pinchRecogniser scale];
            [pinchRecogniser.view setTransform:CGAffineTransformScale(pinchRecogniser.view.transform, scale,scale)];
            [pinchRecogniser setScale:1.0];
            
            CGPoint point = [pinchRecogniser locationInView:[pinchRecogniser view]];
            CGAffineTransform transformTranslate = CGAffineTransformTranslate([[pinchRecogniser view] transform], point.x-lastPoint.x, point.y-lastPoint.y);
             [pinchRecogniser view].transform = transformTranslate;
            
            
           
            
            scaleStart = pinchRecogniser.scale;
            //lastPoint = [pinchRecogniser locationInView:self];
            
        }
            
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            
            
           // [photoCollection setScrollEnabled: YES];
        }
            
        default:
            break;
    }
}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = collectionView.bounds.size;
    NSInteger width = size.width;
    NSInteger height = size.height;
    
    return CGSizeMake(width, height);
}
/*
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    //get new width of the screen
    screenRect = [[UIScreen mainScreen] bounds];
    screenWidth = screenRect.size.width;
    
    //if landscape mode
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
    {
        screenDivide = 5;
    }
    else
    {
        screenDivide = 3;
    }
    
    //reload the collectionview layout after rotating
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.photoCollection.collectionViewLayout;
    [layout invalidateLayout];
}
*/



/*
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Adjust cell size for orientation
    if (UIDeviceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
        return CGSizeMake(170.f, 170.f);
    }
    return CGSizeMake(192.f, 192.f);
}
*/




-(IBAction)backPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(IBAction)leftPressed:(id)sender
{
    NSLog(@"left pressed");
    
    
    if (currentItemNum <= 1)
        return;
    
    [self.photoCollection scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:currentItemNum-2 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    
    currentItemNum --;
    
    counterLabel2.text = [NSString stringWithFormat:@"Изображение %i/%i", currentItemNum, numItems];
    if (currentItemNum == 1){
        _leftArrow.hidden = true;
    }
    _rightArrow.hidden = false;
}

-(IBAction)rightPressed:(id)sender
{
    NSLog(@"right pressed");
    
    
    if (currentItemNum >= numItems)
        return;
    [self.photoCollection scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:currentItemNum inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
    
    currentItemNum++;
    
    counterLabel2.text = [NSString stringWithFormat:@"Изображение %i/%i", currentItemNum, numItems];
    if (currentItemNum == numItems){
        _rightArrow.hidden = true;
    }
    _leftArrow.hidden = false;
   
}



- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGRect visibleRect = (CGRect){.origin = self.photoCollection.contentOffset, .size = self.photoCollection.bounds.size};
    CGPoint visiblePoint = CGPointMake(CGRectGetMidX(visibleRect), CGRectGetMidY(visibleRect));
    NSIndexPath *visibleIndexPath = [self.photoCollection indexPathForItemAtPoint:visiblePoint];
    
    
    currentItemNum = visibleIndexPath.row +1;
    
   
    counterLabel2.text = [NSString stringWithFormat:@"Изображение %i/%i", visibleIndexPath.row +1, numItems];
    
    if (visibleIndexPath.row < 1){
        _leftArrow.hidden = true;
        
    }else{
        _leftArrow.hidden = false;
        if(visibleIndexPath.row == (numItems - 1)){
            _rightArrow.hidden = true;
        }else{
            _rightArrow.hidden = false;
        }
    }


}

/*
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Adjust cell size for orientation
    if (UIDeviceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
        return CGSizeMake(170.f, 170.f);
    }
    return CGSizeMake(192.f, 192.f);
}
*/

/*

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    CGRect navigationToolbarFrame = self.navigationController.navigationBar.frame;
    
    float extraHeight = 0.0f;
    
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait) //!UIInterfaceOrientationIsLandscape(toInterfaceOrientation))
        extraHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    //if (toInterfaceOrientation  // == UIInterfaceOrientationIsLandscape(<#UIInterfaceOrientation orientation#>)
    
    //0.0,
    CGRect customToolbarFrame = CGRectOffset(navigationToolbarFrame, 0.0f,  navigationToolbarFrame.size.height + extraHeight*2);
    
   
    
    
    CGRect photoCollectionFrame = self.photoCollection.frame;
    
    
    CGRect customCollectionFrame = CGRectOffset(photoCollectionFrame, 0.0f,  photoCollectionFrame.size.height - extraHeight*2);
    
    
    
    [UIView animateWithDuration:duration animations:^{
        self.toolbar.frame = customToolbarFrame;
        
    //    self.photoCollection.frame = customCollectionFrame;
    }];
}*/


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
