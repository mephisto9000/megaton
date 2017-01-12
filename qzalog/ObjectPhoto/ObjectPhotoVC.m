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
    CGRect screenSizes;
    
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
    screenSizes = [[UIScreen mainScreen] bounds];
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

    [self.photoCollection registerClass:[PhotoCollectionViewCell class] forCellWithReuseIdentifier:@"photoCollectionCell"];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureDetected:)];
    panGestureRecognizer.delegate = self;
    panGestureRecognizer.cancelsTouchesInView = NO;
    _recognizerRightEnabled = NO;
    _recognizerLeftEnabled = NO;
    [photoCollection addGestureRecognizer:panGestureRecognizer];
   
    
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
   

    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photoCollectionCell" forIndexPath:indexPath];
    cell.scrollview.transform = CGAffineTransformMakeScale(1.0, 1.0);
    cell.scrollview.frame = CGRectMake( 0,  0, screenSizes.size.width, screenSizes.size.height );
    
    
    _recognizerRightEnabled = YES;
    _recognizerLeftEnabled = YES;
    
    //cell.contentView.backgroundColor = [UIColor blackColor];
    //[[[cell contentView] subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self.operationManager GET:  imageArr[indexPath.row] 
                    parameters:nil
                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                           
                           /*cell.scrollview.frame = CGRectMake(0, 0, cell.scrollview.frame.size.width, cell.scrollview.frame.size.height );*/
                           cell.imageView.image = responseObject;
                           
                          
                           UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGestureDetected:)];
                           pinchGestureRecognizer.cancelsTouchesInView = NO;
                           pinchGestureRecognizer.delaysTouchesEnded = NO;
                           [cell.scrollview addGestureRecognizer:pinchGestureRecognizer];
                           
                           
                          
                           
                           [cell setTag:indexPath.row];
                           
                          
                        
                           //imageView.userInteractionEnabled = YES;
                           

                           /*
                           UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGestureDetected:)];
                           pinchGestureRecognizer.cancelsTouchesInView = NO;
                           pinchGestureRecognizer.delaysTouchesEnded = NO;
                           [scrollview addGestureRecognizer:pinchGestureRecognizer];
                           */
                          
                           
                           /*TapGestureRecognizer *tapGestureRecognizer = [[TapGestureRecognizer alloc] initWithTarget:self action:nil];
                           [scrollview addGestureRecognizer:tapGestureRecognizer];
                           
                           
                           
                           
                           
                          
                           
                           UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureDetected:)];
                           //panGestureRecognizer.delegate = self;
                           panGestureRecognizer.cancelsTouchesInView = NO;
                       
                           [scrollview addGestureRecognizer:panGestureRecognizer];
                           
                           
                           [cell addSubview:scrollview];*/
                           
                          // [photoCollection.panGestureRecognizer requireGestureRecognizerToFail:scrollview.panGestureRecognizer];
                           
                           
                           
                       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                           NSLog(@"Failed with error %@.", error);
                       }];
    
    
    
    
    return cell;

}



- (void)panGestureDetected:(UIPanGestureRecognizer *)recognizer
{
    UIGestureRecognizerState state = [recognizer state];
    PhotoCollectionViewCell *currentCell;
    CGFloat xScale = 1.0;
    CGFloat screenWidth;
    CGFloat screenHeight;
    CGFloat imageWidth;
    CGFloat imageHeight;
    
    for (PhotoCollectionViewCell *cell in [self.photoCollection visibleCells]) {
        currentCell = cell;
    }
    
    
    if (state == UIGestureRecognizerStateBegan || state == UIGestureRecognizerStateChanged)
    {
       
        xScale = currentCell.scrollview.transform.a;
        screenWidth = screenSizes.size.width;
        screenHeight = screenSizes.size.height;
        imageWidth = screenWidth * xScale;
        imageHeight = imageWidth * 224 / 358;
        
        
        //CGFloat imageY = 0;
        CGPoint translation = [recognizer translationInView:currentCell.scrollview];
        CGRect imageFrame = [currentCell convertRect:currentCell.imageView.frame fromView:currentCell.scrollview];
        
       
        
        //imageFrame.origin.y = currentCell.imageView.frame.origin.y * xScale + currentCell.scrollview.frame.origin.y;
        
        
        CGFloat translationX = translation.x;
        CGFloat translationY = translation.y;
        
        
        
        if(xScale <= 1){
            recognizer.enabled = YES;
            return;
        }
        
        //Отключаем смещение высоты если высота изображения меньше высоты экрана
        if(imageHeight <= screenHeight){
            translationY = 0;
            
        }
        
        [currentCell.scrollview setTransform:CGAffineTransformTranslate(currentCell.scrollview.transform, translationX, translationY)];
        [recognizer setTranslation:CGPointZero inView:currentCell.scrollview];
        
        
        CGFloat scrollPosY = currentCell.scrollview.frame.origin.y;
        CGFloat scrollPosX = currentCell.scrollview.frame.origin.x;
        if(translationY != 0){
            imageFrame = [currentCell convertRect:currentCell.imageView.frame fromView:currentCell.scrollview];
            if(translationY>0){
                if((imageFrame.origin.y)>=0){
                    scrollPosY = currentCell.imageView.frame.origin.y * xScale * -1;
                }
            }else{
                if((imageFrame.origin.y + imageHeight + translationY)<screenHeight){
                    scrollPosY = currentCell.imageView.frame.origin.y * xScale * -1 + (screenHeight - imageHeight);
                    
                }
            }
        }
        
       
        
        
        if(translationX != 0){
            
            
            if(translationX>0){
                 if(currentCell.scrollview.frame.origin.x>=0){
                    scrollPosX = 0;
                    
                    
                 }
            }else{
                if((currentCell.scrollview.frame.origin.x + currentCell.scrollview.frame.size.width + translationX)<screenSizes.size.width){
                    scrollPosX = screenSizes.size.width - imageWidth;
                    
                    
                    
                }
            }
            
        }
        currentCell.scrollview.frame = CGRectMake( scrollPosX,  scrollPosY, currentCell.scrollview.frame.size.width, currentCell.scrollview.frame.size.height );

        
    }
    
    if (state == UIGestureRecognizerStateEnded || state == UIGestureRecognizerStateCancelled){
        _recognizerRightEnabled = YES;
        _recognizerLeftEnabled = YES;
        if(currentCell.scrollview.frame.origin.x >= 0){
            _recognizerLeftEnabled = NO;
            _recognizerRightEnabled = YES;
        }
        
        if((currentCell.scrollview.frame.origin.x + currentCell.scrollview.frame.size.width)<=screenSizes.size.width){
            _recognizerRightEnabled = NO;
            _recognizerLeftEnabled = YES;
        }
        
    }
}


- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)recognizer {
    
    CGFloat xScale = 1;
    PhotoCollectionViewCell *currentCell = nil;
    for (PhotoCollectionViewCell *cell in [self.photoCollection visibleCells]) {
         xScale = cell.scrollview.transform.a;
         currentCell = cell;
    }
    CGPoint translation = [recognizer translationInView:recognizer.view];
    
   
    if(xScale>1){
        
        
        
        CGRect imageFrame = [currentCell convertRect:currentCell.imageView.frame fromView:currentCell.scrollview];
        if(translation.x>0){
            
            if(currentCell.scrollview.frame.origin.x==0){
                _recognizerLeftEnabled = NO;
            }
            
            if(_recognizerLeftEnabled == NO){
                return NO;
            }
        }
        
        if(translation.x<0){
            
             NSLog(@"Cell width %f", (currentCell.scrollview.frame.origin.x + currentCell.scrollview.frame.size.width));
            NSLog(@"screenSizes.size.width %f", screenSizes.size.width);
            
            CGFloat CellScreen = currentCell.scrollview.frame.origin.x + currentCell.scrollview.frame.size.width-screenSizes.size.width-1;
            
            if(CellScreen < 0){
                _recognizerRightEnabled = NO;
            }
            if(_recognizerRightEnabled == NO){
                return NO;
            }
        }
        
        
        
        
        
        NSLog(@"enable all dir");
       
        return YES;
    }
    
    
    return NO;
    
}

-(void) pinchGestureDetected: (UIPinchGestureRecognizer *) pinchRecogniser
{
    //начальнйы параметр маштаба
    static CGFloat scaleStart;
    //Точка последнего центра между пальцами
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
                //Проверка маштаба на макс и мин
                CGFloat currentScale = [[[pinchRecogniser view].layer valueForKeyPath:@"transform.scale"] floatValue];
                
                // Constants to adjust the max/min values of zoom
                const CGFloat kMaxScale = 5.0;
                const CGFloat kMinScale = 0.5;
                
                CGFloat scale = 1.0f - (scaleStart - pinchRecogniser.scale);
                scale = MIN(scale, kMaxScale / currentScale);
                scale = MAX(scale, kMinScale / currentScale);
                
                [pinchRecogniser.view setTransform:CGAffineTransformScale(pinchRecogniser.view.transform, scale,scale)];
                [pinchRecogniser setScale:1.0];
                scaleStart = pinchRecogniser.scale;
               
                
                //Расчет центра увел. блока
                CGPoint point = [pinchRecogniser locationInView:[pinchRecogniser view]];
                CGFloat scaleCenterX = point.x-lastPoint.x;
                CGFloat scaleCenterY = 0;
                
                
                //Получение отступа от левого края
                CGFloat leftX = pinchRecogniser.view.frame.origin.x;
                //Получение отступа от правого
                CGFloat rightX = pinchRecogniser.view.frame.size.width + pinchRecogniser.view.frame.origin.x - screenSizes.size.width;
                
                //Если фотка уменьшается
                if(scale<=1){
                    
                    if(pinchRecogniser.view.frame.size.width >= screenSizes.size.width){
                        //Модуль нужен для сравнения последующего
                        if(leftX < 0)
                            leftX = leftX * -1;

                        //Если блок в большей степени смещен влево
                        if(leftX > rightX){
                            NSLog(@"Scale right corner %f", rightX);
                            //ПРи уменьшение переживаем если только отступ от края меньше нуля
                            if(rightX<0){
                                 pinchRecogniser.view.frame = CGRectMake( screenSizes.size.width - pinchRecogniser.view.frame.size.width, pinchRecogniser.view.frame.origin.y, pinchRecogniser.view.frame.size.width, pinchRecogniser.view.frame.size.height );
                                
                            }
                        }else{
                            //Если отступ больше нуля
                            if(pinchRecogniser.view.frame.origin.x > 0){
                                 pinchRecogniser.view.frame = CGRectMake( 0, pinchRecogniser.view.frame.origin.y, pinchRecogniser.view.frame.size.width, pinchRecogniser.view.frame.size.height );
                                
                            }
                        }
                        //Сохраняем на случай если начнется увелечение (этот параметр используется только для увелечения)
                        lastPoint.x = point.x;
                        
                    }else{
                        //Выравниваем
                        pinchRecogniser.view.frame = CGRectMake( (screenSizes.size.width-pinchRecogniser.view.frame.size.width)/2, pinchRecogniser.view.frame.origin.y, pinchRecogniser.view.frame.size.width, pinchRecogniser.view.frame.size.height );
                        lastPoint.x = point.x;
                    }
                    
                }else{
                    
                    if(pinchRecogniser.view.frame.size.width >= screenSizes.size.width){
 
                        //Отцентровка изображения
                        CGAffineTransform transformTranslate = CGAffineTransformTranslate([[pinchRecogniser view] transform], scaleCenterX, scaleCenterY);
                        [pinchRecogniser view].transform = transformTranslate;
                        
                        //Проверка изображени на лищний отступы
                        if(pinchRecogniser.view.frame.origin.x>0){
                            pinchRecogniser.view.frame = CGRectMake( 0, pinchRecogniser.view.frame.origin.y, pinchRecogniser.view.frame.size.width, pinchRecogniser.view.frame.size.height );
                           
                        }else{
                            rightX = pinchRecogniser.view.frame.size.width + pinchRecogniser.view.frame.origin.x - screenSizes.size.width;
                            if(rightX < 0){
                                pinchRecogniser.view.frame = CGRectMake( screenSizes.size.width - pinchRecogniser.view.frame.size.width, pinchRecogniser.view.frame.origin.y, pinchRecogniser.view.frame.size.width, pinchRecogniser.view.frame.size.height );
                               
                            }

                        }
                        
                    }else{
                        lastPoint.x = point.x;
                    }
                }
            }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
            {
                [photoCollection setScrollEnabled: YES];
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





- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGRect visibleRect = (CGRect){.origin = self.photoCollection.contentOffset, .size = self.photoCollection.bounds.size};
    CGPoint visiblePoint = CGPointMake(CGRectGetMidX(visibleRect), CGRectGetMidY(visibleRect));
    NSIndexPath *visibleIndexPath = [self.photoCollection indexPathForItemAtPoint:visiblePoint];
    
    
    currentItemNum = visibleIndexPath.row +1;
    
   
    counterLabel2.text = [NSString stringWithFormat:@"Изображение %i/%i", visibleIndexPath.row +1, numItems];
    
    


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
