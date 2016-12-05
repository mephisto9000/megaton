//
//  MapVC.m
//  qzalog
//
//  Created by Mus Bai on 29.11.16.
//  Copyright © 2016 Mus Bai. All rights reserved.
//

#import "MapVC.h"
#import "ObjectCoordLoader.h"
#import "ObjectDetailVC.h"

@interface MapVC ()
{
    NSArray<ObjectCoord *> *coords;
    int map_zoom;
    float map_coord_x;
    float map_coord_y;
    
    NSString *selectedObject;
}

@end

@implementation MapVC

@synthesize mapView;

const NSString *TO_OBJECT_DETAILS1 = @"toObjectDetails";


-(BOOL) mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker
{
    
    NSLog(@"marker tapped");
    selectedObject = coords[[marker.userData intValue]].objId;
    
    [self performSegueWithIdentifier:TO_OBJECT_DETAILS1 sender:self];
    
    return YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    ObjectCoordLoader *ocLoader = [ObjectCoordLoader new];
    
    [ocLoader setDelegate:self];
    
    [ocLoader loadData ];//:@"31"
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) mapLoadComplete:(NSArray<ObjectCoord *> *)coord map_zoom:(int)map_zoom map_coord_x:(float)map_coord_x map_coord_y:(float)map_coord_y
{
    coords = coord;
    
    self->map_zoom = map_zoom;
    self->map_coord_x = map_coord_x;
    self->map_coord_y = map_coord_y;
    
    [self performSelectorOnMainThread:@selector(mapLoadMainThread) withObject:nil waitUntilDone:YES];
    
}


-(void) mapLoadMainThread
{
    
    for (int i = 0; i < [coords count]; i++)
    {
        ObjectCoord *oc = coords[i];
        
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake(oc.coord_x, oc.coord_y);
        
        //marker.title = self->objectDetail.title;
        //marker.snippet = self->objectDetail.description;
        marker.userData = [NSNumber numberWithInt:i];
        
        marker.map = self.mapView;
    }
    
    ObjectCoord *oc = coords[0];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:map_coord_x
                                                            longitude:map_coord_y
                                                                 zoom:map_zoom];
    
    [self.mapView setCamera:camera];
    [self.mapView setDelegate:self];
    self.mapView.myLocationEnabled = YES;
    

}


-(IBAction) goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:TO_OBJECT_DETAILS1])
    {
        ObjectDetailVC *od = (ObjectDetailVC *) segue.destinationViewController;
        
        [od setObjectId:selectedObject];
    }
    
}


@end
