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
#import "CategoryDetailVC.h"
#import "NetTools.h"



@implementation POIItem

@synthesize position;
@synthesize name;
@synthesize objId;

- (instancetype)initWithPosition:(CLLocationCoordinate2D)position name:(NSString *)name;
{
    self.position = position;
    self.name = name;
    
    return self;
}

@end


@interface MapVC ()
{
    NSArray<ObjectCoord *> *coords;
    int map_zoom;
    float map_coord_x;
    float map_coord_y;
    
    NSString *selectedObject;
    NSArray *selectedObjects;
    
    GMUClusterManager *_clusterManager;
}

@end

@implementation MapVC

@synthesize mapView;
//@synthesize objIds;
@synthesize mapUrl;

const NSString *TO_OBJECT_DETAILS1 = @"toObjectDetails";
const NSString *TO_CATEGORY_DETAILS1 = @"toCategoryDetails";



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    ObjectCoordLoader *ocLoader = [ObjectCoordLoader new];
    
    [ocLoader setDelegate:self];
    
    if (![NetTools hasConnectivity])
    {
        [self noData:self.view];
        return;
    }
    
    if (self.mapUrl != nil)
        [ocLoader loadDataFromUrl: self.mapUrl];
    else
        [ocLoader loadData ];//:@"31"
}


-(void) mapLoadFailed
{
    [self noData:self.view];
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
    
    
    ObjectCoord *oc = coords[0];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:map_coord_x
                                                            longitude:map_coord_y
                                                                 zoom:map_zoom];
    
    [self.mapView setCamera:camera];
    //[self.mapView setDelegate:self];
    self.mapView.myLocationEnabled = YES;
    
    
    id<GMUClusterAlgorithm> algorithm =
    [[GMUNonHierarchicalDistanceBasedAlgorithm alloc] init];
    id<GMUClusterIconGenerator> iconGenerator =
    [[GMUDefaultClusterIconGenerator alloc] init];
    id<GMUClusterRenderer> renderer =
    [[GMUDefaultClusterRenderer alloc] initWithMapView:self.mapView
                                  clusterIconGenerator:iconGenerator];
    _clusterManager =
    [[GMUClusterManager alloc] initWithMap:self.mapView
                                 algorithm:algorithm
                                  renderer:renderer];
    
    // Generate and add random items to the cluster manager.
    //[self generateClusterItems];
    
    
    /*
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
    */
    const double extent = 0.2;
    for (int i = 0; i < [coords count]; i++)
    {
        ObjectCoord *oc = coords[i];
        
        /*
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake(oc.coord_x, oc.coord_y);
        
        //marker.title = self->objectDetail.title;
        //marker.snippet = self->objectDetail.description;
        marker.userData = [NSNumber numberWithInt:i]; */
        NSString *name = @"name";
        
        id<GMUClusterItem> item =
        [[POIItem alloc] initWithPosition:CLLocationCoordinate2DMake(oc.coord_x, oc.coord_y)
                                     name:name];
        
        ((POIItem *) item).objId = [[NSNumber numberWithInt:i] integerValue];

        
        
        [_clusterManager addItem:item];
        //marker.map = self.mapView;
    }

    
    
    // Call cluster() after items have been added
    // to perform the clustering and rendering on map.
    [_clusterManager cluster];
    [_clusterManager setDelegate:self mapDelegate:self];

}

/*
- (void)generateClusterItems {
    const double extent = 0.2;
    for (int index = 1; index <= kClusterItemCount; ++index) {
        double lat = kCameraLatitude + extent * [self randomScale];
        double lng = kCameraLongitude + extent * [self randomScale];
        NSString *name = [NSString stringWithFormat:@"Item %d", index];
        id<GMUClusterItem> item =
        [[POIItem alloc] initWithPosition:CLLocationCoordinate2DMake(lat, lng)
                                     name:name];
        [_clusterManager addItem:item];
    }
}
*/


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
        
        
        //if (selectedObjects == nil)
            [od setObjectId:selectedObject];
        //else
          //  od setOb
    }
    
    if ([segue.identifier isEqualToString:TO_CATEGORY_DETAILS1])
    {
        CategoryDetailVC *catVC = (CategoryDetailVC *) segue.destinationViewController;
        
        [catVC setObjIds:selectedObjects];
    }
    
}


- (void)clusterManager:(GMUClusterManager *)clusterManager didTapCluster:(id<GMUCluster>)cluster {
   
    /*
    GMSCameraPosition *newCamera =
    [GMSCameraPosition cameraWithTarget:cluster.position zoom:self.mapView.camera.zoom + 1];
    GMSCameraUpdate *update = [GMSCameraUpdate setCamera:newCamera];
    [self.mapView moveCamera:update]; */
    
    //cluster it
    NSArray<id<GMUClusterItem>> *items = [cluster items];
    
    
    NSMutableArray *objIds = [NSMutableArray new];
    
    
    for (int i = 0; i < [items count]; i++)
    {
        //GMSMarker *marker = items[i];
        
        POIItem *poiItem = (POIItem *) items[i];//marker.userData;
        
        if (poiItem != nil) {
            
                [objIds addObject:coords[poiItem.objId].objId ];
            
        }
        
        
        
    }
    
    selectedObjects = [objIds copy];
    
    
    [self performSegueWithIdentifier:TO_CATEGORY_DETAILS1 sender:self];
}

#pragma mark GMSMapViewDelegate

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker {
    POIItem *poiItem = marker.userData;
    if (poiItem != nil) {
       // NSLog(@"Did tap marker for cluster item %@", poiItem.name);
        {
            selectedObject = coords[(int) poiItem.objId ].objId;
            
            [self performSegueWithIdentifier:TO_OBJECT_DETAILS1 sender:self];
        }
    } else {
        NSLog(@"Did tap a normal marker");
    }
    return NO;
}

/*
 -(BOOL) mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker
 {
 
 NSLog(@"marker tapped");
 selectedObject = coords[[marker.userData intValue]].objId;
 
 [self performSegueWithIdentifier:TO_OBJECT_DETAILS1 sender:self];
 
 return YES;
 }
 */




@end
