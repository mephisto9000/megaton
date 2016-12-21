//
//  ObjectPhotoVC.m
//  qzalog
//
//  Created by Mus Bai on 17.12.16.
//  Copyright © 2016 Mus Bai. All rights reserved.
//

#import "ObjectPhotoVC.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>

@interface ObjectPhotoVC ()
{
    int numItems;
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
    
    numItems = 0;
    
    if (imageArr != nil)
    {
        numItems = [imageArr count];
    }
    
    if (currentItemNum == 0)
        currentItemNum = 1;
    
       [self.counterLabel2 setText:[NSString stringWithFormat:@"Изображение %i/%i", currentItemNum, numItems]];
    
    [counterBgView setHidden:YES];
    
    //[photoCollection
     //selectItemAtIndexPath:[NSIndexPath indexPathForItem:(currentItemNum - 1) inSection:0]
     //animated:YES
     //scrollPosition:UICollectionViewScrollPositionCenteredVertically];
     //photoCollection.selectItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0), animated: false, scrollPosition: .None)
    
    
    //[photoCollection selectItemAtIndexPath:[NSIndexPath indexPathForItem:(currentItemNum - 1) inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionCenteredVertically];
    
   
    
}


-(void) viewWillAppear:(BOOL)animated
{
    
    NSLog(@"currentItemNum == %li", currentItemNum);
    
    [photoCollection scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:(currentItemNum - 1) inSection:0]  atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    
    
    //photoCollection scrollToIte
    
    [photoCollection reloadData];
    
    
    [super viewWillAppear:animated];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
                           cell.backgroundView = [[UIImageView alloc] initWithImage:responseObject];
                           cell.backgroundView.contentMode = UIViewContentModeScaleAspectFit;
                           NSLog(@"image download complete");
                           
                           
                       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                           NSLog(@"Failed with error %@.", error);
                       }];
    
    
    
    
    return cell;
    
    
    //return nil;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // cell to have the size of the collectionView
    return photoCollection.frame.size;
}


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
}

-(IBAction)rightPressed:(id)sender
{
    NSLog(@"right pressed");
    
    
    if (currentItemNum >= numItems)
        return;
    [self.photoCollection scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:currentItemNum inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
    
    currentItemNum++;
    
    counterLabel2.text = [NSString stringWithFormat:@"Изображение %i/%i", currentItemNum, numItems];

}



- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGRect visibleRect = (CGRect){.origin = self.photoCollection.contentOffset, .size = self.photoCollection.bounds.size};
    CGPoint visiblePoint = CGPointMake(CGRectGetMidX(visibleRect), CGRectGetMidY(visibleRect));
    NSIndexPath *visibleIndexPath = [self.photoCollection indexPathForItemAtPoint:visiblePoint];
    
    
    currentItemNum = visibleIndexPath.row +1;
    
   
    counterLabel2.text = [NSString stringWithFormat:@"%i/%i", visibleIndexPath.row +1, numItems];
}





/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
