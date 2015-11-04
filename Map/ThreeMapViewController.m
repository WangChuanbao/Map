//
//  ThreeMapViewController.m
//  Map
//
//  Created by 王宝 on 15/10/22.
//  Copyright © 2015年 王宝. All rights reserved.
//

#import "ThreeMapViewController.h"

@interface ThreeMapViewController ()

@end

@implementation ThreeMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)query:(id)sender {
    
    if (self.textFild.text == nil) {
        return;
    }
    
    //[self single];
    
    //如果有多个点需要标注
    [self multiple];
}

/**
 *  单个标注
 */
- (void)single {
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    [geocoder geocodeAddressString:self.textFild.text completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        if (placemarks.count > 0) {
            
            CLPlacemark *placemark = [placemarks firstObject];
            
            //CLLocationCoordinate2D coordinate = placemark.location.coordinate;
            //NSDictionary *addressDictionary = placemark.addressDictionary;
            //MKPlacemark *place = [[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:addressDictionary];
            
            MKPlacemark *place = [[MKPlacemark alloc] initWithPlacemark:placemark];
            //可以理解为标注点
            MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:place];
            
            NSDictionary *options = [NSDictionary dictionaryWithObject:MKLaunchOptionsDirectionsModeWalking forKey:MKLaunchOptionsDirectionsModeKey];
            
            /*
             调用苹果自带地图。该方法有一个参数，为字典类型。该参数包涵一些键,常用如下：
             MKLaunchOptionsDirectionsModeKey：设定路线模式，有两个值MKLaunchOptionsDirectionsModeDriving(驾车路线)和MKLaunchOptionsDirectionsModeWalking(步行路线)
             MKLaunchOptionsMapTypeKey：地图类型
             MKLaunchOptionsMapCenterKey：地图跨度
             MKLaunchOptionsMapSpanKeyMKLaunchOptionsShowsTrafficKey：显示交通状况
             */
            [mapItem openInMapsWithLaunchOptions:options];
            
            [self.textFild resignFirstResponder];
            
        }
        
    }];
}

/**
 *  多个标注
 */
- (void)multiple {
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    [geocoder geocodeAddressString:self.textFild.text completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        NSMutableArray *array = [NSMutableArray new];
        
        for (CLPlacemark *placemark in placemarks) {
            
            MKPlacemark *place = [[MKPlacemark alloc] initWithPlacemark:placemark];
            MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:place];
            
            [array addObject:mapItem];
        }
        
        [self.textFild resignFirstResponder];
        
        if (array.count > 0) {
            NSDictionary *options = [NSDictionary dictionaryWithObject:MKLaunchOptionsDirectionsModeWalking forKey:MKLaunchOptionsDirectionsModeKey];
            [MKMapItem openMapsWithItems:array launchOptions:options];
        }
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
