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
    Boolean screenLanOrient;
    
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
    if(screenSizes.size.width > screenSizes.size.height){
        screenLanOrient = true;
    }else{
        screenLanOrient = false;
    }
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
    
    self.counterLabel2.hidden = YES;
    
   [toolbar setBackgroundImage:[[UIImage alloc] init] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
   
    //[self.counterLabel2 setText:[NSString stringWithFormat:@"Изображение %i/%i", currentItemNum, numItems]];
    
    [counterBgView setHidden:YES];

   
    //for rotation
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(orientationChanged:)
     name:UIDeviceOrientationDidChangeNotification
     object:[UIDevice currentDevice]];
    
    
    
   


    [self.photoCollection registerClass:[PhotoCollectionViewCell class] forCellWithReuseIdentifier:@"photoCollectionCell"];
    
    //CustomPinchGestureRecognizer UIPinchGestureRecognizer
    CustomPinchGestureRecognizer *pinchGestureRecognizer = [[CustomPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGestureDetected:)];
    [photoCollection addGestureRecognizer:pinchGestureRecognizer];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureDetected:)];
    panGestureRecognizer.delegate = self;
    panGestureRecognizer.cancelsTouchesInView = NO;
    _recognizerRightEnabled = NO;
    _recognizerLeftEnabled = NO;
    [photoCollection addGestureRecognizer:panGestureRecognizer];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureDetected:)];
    doubleTap.numberOfTapsRequired = 2;
    [photoCollection addGestureRecognizer:doubleTap];
    [pinchGestureRecognizer requireGestureRecognizerToFail:doubleTap];
    

}




- (void) orientationChanged:(NSNotification *)note
{
    loaded = false;
    UIDevice * device = note.object;
    
    UICollectionViewFlowLayout *flowLayout = (id)self.photoCollection.collectionViewLayout;
    
    screenSizes = [[UIScreen mainScreen] bounds];
    if(screenSizes.size.width > screenSizes.size.height){
        screenLanOrient = true;
    }else{
        screenLanOrient = false;
    }
   
    NSInteger width = screenSizes.size.width;
    NSInteger height = screenSizes.size.height;

   
    
    
    flowLayout.itemSize = CGSizeMake(width, height);
    [flowLayout invalidateLayout];
    
    
    [self viewWillAppear:YES];
    [self viewDidAppear:YES];
    [self.photoCollection  scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:(currentItemNum - 1) inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    
    [self.photoCollection reloadData];
    
   
    
  
    [self.photoCollection reloadItemsAtIndexPaths:0];
    
    
    
}


- (void)viewDidLayoutSubviews
{
    [self.photoCollection layoutIfNeeded];
    if(loaded == false){
        [self.photoCollection  scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:(currentItemNum - 1) inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        loaded = true;
       
    }
}


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
    
    NSLog(@"@sdas %f", cell.imageView.frame.size.width);
    NSLog(@"@sdas %f", cell.imageView.frame.size.height);
    NSLog(@"@sdas %f", cell.scrollview.frame.size.width);
    
    cell.scrollview.transform = CGAffineTransformMakeScale(1.0, 1.0);
    cell.scrollview.frame = CGRectMake( 0,  0, screenSizes.size.width, screenSizes.size.height );
    
    
    if(screenLanOrient == false)
        cell.imageView.frame = CGRectMake( 0,  (screenSizes.size.height - screenSizes.size.width / 358 * 224)/2 + 6, screenSizes.size.width, screenSizes.size.width / 358 * 224);
    else
        cell.imageView.frame = CGRectMake( (screenSizes.size.width - (screenSizes.size.height / 224 * 358))/2,  0, (screenSizes.size.height / 224 * 358), screenSizes.size.height );
    
    
    _recognizerRightEnabled = YES;
    _recognizerLeftEnabled = YES;
    
    [self.operationManager GET:  imageArr[indexPath.row] 
        parameters:nil
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               
               cell.imageView.image = responseObject;
               [cell setTag:indexPath.row];

           } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               NSLog(@"Failed with error %@.", error);
           }];

    return cell;

}

- (void)tapGestureDetected:(UITapGestureRecognizer *)recognizer
{
    PhotoCollectionViewCell *currentCell;
    for (PhotoCollectionViewCell *cell in [photoCollection visibleCells]) {
        currentCell = cell;
    }
    CGFloat xScale = currentCell.scrollview.transform.a;
    if(xScale <= 1){
        [UIView animateWithDuration:0.5
                         animations:^{
                             currentCell.scrollview.transform = CGAffineTransformMakeScale(2.0, 2.0);
                         }
                         completion:nil];
        
    }else{
        [UIView animateWithDuration:0.5
                         animations:^{
                             currentCell.scrollview.transform = CGAffineTransformMakeScale(1.0, 1.0);
                             currentCell.scrollview.frame = CGRectMake(0, 0, currentCell.frame.size.width, currentCell.frame.size.height );
                         }
                         completion:nil];
    }
    
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
    CGRect imageFrame = [currentCell convertRect:currentCell.imageView.frame fromView:currentCell.scrollview];

    xScale = currentCell.scrollview.transform.a;
    screenWidth = screenSizes.size.width;
    screenHeight = screenSizes.size.height;
    
    if(screenLanOrient == false){
        imageWidth = screenWidth * xScale;
        imageHeight = imageWidth * 224 / 358;
    }else{
        imageHeight = screenHeight * xScale;
        imageWidth = imageHeight / 224 * 358;
    }
    
    if (state == UIGestureRecognizerStateBegan || state == UIGestureRecognizerStateChanged)
    {
       
        
        
        //CGFloat imageY = 0;
        CGPoint translation = [recognizer translationInView:currentCell.scrollview];
        
 
        
        CGFloat translationX = translation.x;
        CGFloat translationY = translation.y;
        
        if(screenLanOrient == false){
           
            if(currentCell.scrollview.frame.size.width <= screenWidth){
                recognizer.enabled = YES;
                
                [currentCell.scrollview setTransform:CGAffineTransformTranslate(currentCell.scrollview.transform, 0, translationY)];
                [recognizer setTranslation:CGPointZero inView:currentCell.scrollview];
                
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
                NSLog(@"asd %f", imageFrame.origin.y);
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
        }else{
           
            
            if(currentCell.scrollview.frame.size.height <= screenHeight){
                recognizer.enabled = YES;
                
                [currentCell.scrollview setTransform:CGAffineTransformTranslate(currentCell.scrollview.transform, 0, translationY)];
                [recognizer setTranslation:CGPointZero inView:currentCell.scrollview];
                
                return;
            }
            
            
            if(imageWidth <= screenWidth){
                translationX = 0;
            }
            
            [currentCell.scrollview setTransform:CGAffineTransformTranslate(currentCell.scrollview.transform, translationX, translationY)];
            [recognizer setTranslation:CGPointZero inView:currentCell.scrollview];
            
            
            CGFloat scrollPosY = currentCell.scrollview.frame.origin.y;
            CGFloat scrollPosX = currentCell.scrollview.frame.origin.x;
            
            if(translationX != 0){
                if(translationX>0){
                    
                    if(imageFrame.origin.x>=-1){
                        scrollPosX = (imageWidth - currentCell.scrollview.frame.size.width)/2;
                        
                    }
                }else{
                    if((imageFrame.origin.x + imageWidth + translationX-1)<screenSizes.size.width){
                        scrollPosX = -1 * (currentCell.scrollview.frame.size.width - screenWidth) - (imageWidth - currentCell.scrollview.frame.size.width)/2;
                        
                    }
                }
                
            }
            
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
            
            
            currentCell.scrollview.frame = CGRectMake( scrollPosX,  scrollPosY, currentCell.scrollview.frame.size.width, currentCell.scrollview.frame.size.height );
        }

        
    }
    
    if (state == UIGestureRecognizerStateEnded || state == UIGestureRecognizerStateCancelled){
        if(currentCell.scrollview.frame.size.width <= screenSizes.size.width){
            if(currentCell.scrollview.frame.origin.y > (screenSizes.size.height/6) || currentCell.scrollview.frame.origin.y < (-1 * screenSizes.size.height/6)){
                if(currentCell.scrollview.frame.origin.y > (screenSizes.size.height/6))
                    [self.navigationController popViewControllerAnimated: YES];
                else
                     [self.navigationController popViewControllerAnimated: NO];
            }else{
                [UIView animateWithDuration:0.5
                     animations:^{
                         currentCell.scrollview.frame = CGRectMake(0, 0, currentCell.frame.size.width, currentCell.frame.size.height );
                     }
                     completion:nil];
            }
            return;
        }
        
        _recognizerRightEnabled = YES;
        _recognizerLeftEnabled = YES;
       
        if(screenLanOrient == false){
            if(currentCell.scrollview.frame.origin.x >= 0){
                _recognizerLeftEnabled = NO;
                _recognizerRightEnabled = YES;
            }
            if((currentCell.scrollview.frame.origin.x + currentCell.scrollview.frame.size.width)<=screenSizes.size.width){
                _recognizerRightEnabled = NO;
                _recognizerLeftEnabled = YES;
            }
        }else{
            if(imageFrame.origin.x >= -5){
                _recognizerLeftEnabled = NO;
                _recognizerRightEnabled = YES;
            }
            if((imageFrame.origin.x + imageWidth - 5)<=screenSizes.size.width){
                _recognizerRightEnabled = NO;
                _recognizerLeftEnabled = YES;
            }
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
        
       
        CGFloat imageWidth;
        CGFloat imageHeight;
        if(screenLanOrient == false){
            imageWidth = screenSizes.size.width * xScale;
            imageHeight = imageWidth * 224 / 358;
        }else{
            imageHeight = screenSizes.size.height * xScale;
            imageWidth = imageHeight / 224 * 358;
        }
        if(translation.x>0){
            //1 - это допускаемая погрещность
            if(currentCell.scrollview.frame.origin.x<=1 && currentCell.scrollview.frame.origin.x>=-1){
                _recognizerLeftEnabled = NO;
            }
            
            if(_recognizerLeftEnabled == NO){
                return NO;
            }
        }
        
        if(translation.x<0){
            CGFloat CellScreen = currentCell.scrollview.frame.origin.x + currentCell.scrollview.frame.size.width-screenSizes.size.width-5;
            
            
            if(CellScreen < 0){
                _recognizerRightEnabled = NO;
            }
            if((imageFrame.origin.x + imageWidth - 1)<=screenSizes.size.width){
                _recognizerRightEnabled = NO;
            }
            if(_recognizerRightEnabled == NO){
                return NO;
            }
        }
        
       
        return YES;
    }else{
        CGFloat panY = translation.y;
        CGFloat panX = translation.x;
        if(panY<0)
            panY = panY * -1;
        if(panX<0)
            panX = panX * -1;
        
        if(currentCell.scrollview.frame.size.width<=screenSizes.size.width && panY>panX){
             return YES;
        }
    }
    
    
    return NO;
    
}

-(void) pinchGestureDetected: (CustomPinchGestureRecognizer *) pinchRecogniser
{
    //начальнйы параметр маштаба
    static CGFloat scaleStart;
    //Точка последнего центра между пальцами
    static CGPoint lastPoint;
   
    PhotoCollectionViewCell *currentCell;
    
    for (PhotoCollectionViewCell *cell in [self.photoCollection visibleCells]) {
        currentCell = cell;
    }

    
    switch ([pinchRecogniser state])
    {
        case UIGestureRecognizerStateBegan:
            {
                NSLog(@"Began");
                [photoCollection setScrollEnabled: NO];
                scaleStart = 1.0f;
                lastPoint = [pinchRecogniser locationInView:currentCell.scrollview];
                
                break;
            }
            
        case UIGestureRecognizerStateChanged:
            {
                //Проверка маштаба на макс и мин
                CGFloat currentScale = [[currentCell.scrollview.layer valueForKeyPath:@"transform.scale"] floatValue];
                
                // Constants to adjust the max/min values of zoom
                const CGFloat kMaxScale = 3.0;
                const CGFloat kMinScale = 0.5;
                
                CGFloat scale = 1.0f - (scaleStart - pinchRecogniser.scale);
                scale = MIN(scale, kMaxScale / currentScale);
                scale = MAX(scale, kMinScale / currentScale);
                
                [currentCell.scrollview setTransform:CGAffineTransformScale(currentCell.scrollview.transform, scale,scale)];
                [pinchRecogniser setScale:1.0];
                scaleStart = pinchRecogniser.scale;
               
                
                //Расчет центра увел. блока
                CGPoint point = [pinchRecogniser locationInView:currentCell.scrollview];
                CGFloat scaleCenterX = point.x-lastPoint.x;
                CGFloat scaleCenterY = 0;
                
                
                //Получение отступа от левого края
                CGFloat leftX = currentCell.scrollview.frame.origin.x;
                //Получение отступа от правого
                CGFloat rightX = currentCell.scrollview.frame.size.width + currentCell.scrollview.frame.origin.x - screenSizes.size.width;
                
                //Если фотка уменьшается
                
                CGFloat scrollY = currentCell.scrollview.frame.origin.y;
                CGFloat scrollX = currentCell.scrollview.frame.origin.x;
                CGFloat xScale = currentCell.scrollview.transform.a;
                CGFloat scrollImageY = currentCell.imageView.frame.origin.y * xScale;
                
                CGRect imageFrame = [currentCell convertRect:currentCell.imageView.frame fromView:currentCell.scrollview];
                CGFloat imageWidth = screenSizes.size.width * xScale;
                CGFloat imageHeight = imageWidth * 224 / 358;
                
                if(scale<=1){
                    if(currentCell.scrollview.frame.size.width >= screenSizes.size.width){
                        if(imageHeight >= screenSizes.size.height){
                            
                            if(imageFrame.origin.y>0){
                                scrollY = currentCell.imageView.frame.origin.y * xScale * -1;
                            }else{
                                
                                if((imageFrame.origin.y + imageHeight)<screenSizes.size.height){
                                    scrollY = currentCell.imageView.frame.origin.y * xScale * -1 + (screenSizes.size.height - imageHeight);
                                    
                                }
                            }
                            
                        }else{
                            //scrollY = (screenSizes.size.height-currentCell.scrollview.frame.size.height)/2;
                           
                        }
                        
                        //Модуль нужен для сравнения последующего
                        if(leftX < 0)
                            leftX = leftX * -1;

                        //Если блок в большей степени смещен влево
                        if(leftX > rightX){
                            
                            //ПРи уменьшение переживаем если только отступ от края меньше нуля
                            if(rightX<0){
                                scrollX = screenSizes.size.width - currentCell.scrollview.frame.size.width;
                            }
                        }else{
                            //Если отступ больше нуля
                            if(currentCell.scrollview.frame.origin.x > 0){
                                scrollX = 0;
                            }
                        }
                        
                        currentCell.scrollview.frame = CGRectMake( scrollX, scrollY, currentCell.scrollview.frame.size.width, currentCell.scrollview.frame.size.height );
                        
                        //Сохраняем на случай если начнется увелечение (этот параметр используется только для увелечения)
                        lastPoint.x = point.x;
                        
                    }else{
                        //Выравниваем
                        currentCell.scrollview.frame = CGRectMake( (screenSizes.size.width-currentCell.scrollview.frame.size.width)/2, currentCell.scrollview.frame.origin.y, currentCell.scrollview.frame.size.width, currentCell.scrollview.frame.size.height );
                        lastPoint.x = point.x;
                    }
                    
                }else{
                    
                    if(currentCell.scrollview.frame.size.width >= screenSizes.size.width){
 
                        //Отцентровка изображения
                        CGAffineTransform transformTranslate = CGAffineTransformTranslate([currentCell.scrollview transform], scaleCenterX, scaleCenterY);
                        currentCell.scrollview.transform = transformTranslate;
                        
                        //Проверка изображени на лищний отступы
                        if(currentCell.scrollview.frame.origin.x>0){
                            currentCell.scrollview.frame = CGRectMake( 0, currentCell.scrollview.frame.origin.y, currentCell.scrollview.frame.size.width, currentCell.scrollview.frame.size.height );
                           
                        }else{
                            rightX = currentCell.scrollview.frame.size.width + currentCell.scrollview.frame.origin.x - screenSizes.size.width;
                            if(rightX < 0){
                                currentCell.scrollview.frame = CGRectMake( screenSizes.size.width - currentCell.scrollview.frame.size.width, currentCell.scrollview.frame.origin.y, currentCell.scrollview.frame.size.width, currentCell.scrollview.frame.size.height );
                               
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


-(IBAction)backPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGRect visibleRect = (CGRect){.origin = self.photoCollection.contentOffset, .size = self.photoCollection.bounds.size};
    CGPoint visiblePoint = CGPointMake(CGRectGetMidX(visibleRect), CGRectGetMidY(visibleRect));
    NSIndexPath *visibleIndexPath = [self.photoCollection indexPathForItemAtPoint:visiblePoint];
    
    
    currentItemNum = visibleIndexPath.row +1;


}



@end
