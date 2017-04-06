//
//  FCMainViewController.m
//  iFlightControl
//
//  Created by dRumyankov on 4/6/17.
//  Copyright © 2017 iFlight. All rights reserved.
//

#import "FCMainViewController.h"
#import "FCJoyStickView.h"

CGFloat const FCMainViewControllerMargin = 10;

NSInteger const FCMainViewControllerConuntJoyStick = 2;

@interface FCMainViewController ()

@property (strong, nonatomic) FCJoyStickView *vJoyStickServo;

@property (strong, nonatomic) FCJoyStickView *vJoyStickEngine;

@end

@implementation FCMainViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onStickChanged:) name:FCStickChangedNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self initJoySticks];
}

- (void)initJoySticks {
    CGFloat itemHeight = CGRectGetHeight(self.view.frame) * 0.75f;
//    CGFloat itemWidth = (CGRectGetWidth(self.view.frame) - FCMainViewControllerMargin) / FCMainViewControllerConuntJoyStick;
    
    self.vJoyStickServo = [[FCJoyStickView alloc] initWithFrame:CGRectMake(0, 0, itemHeight, itemHeight)];
    [self.view addSubview:self.vJoyStickServo];
    
    self.vJoyStickEngine = [[FCJoyStickView alloc] initWithFrame:CGRectMake(itemHeight + FCMainViewControllerMargin, 0, itemHeight, itemHeight)];
    self.vJoyStickEngine.axisAccesType = FCJoyStickViewAxisAccesTypeVertical;
    [self.view addSubview:self.vJoyStickEngine];
}

#pragma mark - Notifications

- (void)onStickChanged:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    CGPoint direction = [[userInfo valueForKey:kFCDirection] CGPointValue];
    NSLog(@"direction: x - %f y - %f", direction.x, direction.y);
}

@end
