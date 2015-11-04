//
//  ViewController.h
//  Map
//
//  Created by 王宝 on 15/10/22.
//  Copyright © 2015年 王宝. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AddressBook/AddressBook.h>

@interface ViewController : UIViewController<CLLocationManagerDelegate>

@property (nonatomic ,strong) CLLocationManager *locationManager;

@end

