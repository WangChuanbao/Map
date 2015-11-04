//
//  Myannotation.h
//  Map
//
//  Created by 王宝 on 15/10/22.
//  Copyright © 2015年 王宝. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Myannotation : NSObject<MKAnnotation>

@property (nonatomic ,readwrite) CLLocationCoordinate2D coordinate;
@property (nonatomic ,strong) NSString *street;
@property (nonatomic ,strong) NSString *city;
@property (nonatomic ,strong) NSString *state;
@property (nonatomic ,strong) NSString *zip;    //邮编

@end
