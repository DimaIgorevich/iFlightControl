//
//  FCJoyStickView.h
//  iFlightControl
//
//  Created by dRumyankov on 4/6/17.
//  Copyright © 2017 iFlight. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, FCJoyStickViewAxisAccesType) {
    FCJoyStickViewAxisAccesTypeAll        = 0,
    FCJoyStickViewAxisAccesTypeHorizontal = 1,
    FCJoyStickViewAxisAccesTypeVertical   = 2
};

@interface FCJoyStickView : UIView

@property (copy, nonatomic) UIImage *backgroundStick;

@property (copy, nonatomic) UIImage *imageNormalStick;

@property (copy, nonatomic) UIImage *imageHoldStick;

@property (nonatomic) FCJoyStickViewAxisAccesType axisAccesType;

@end
