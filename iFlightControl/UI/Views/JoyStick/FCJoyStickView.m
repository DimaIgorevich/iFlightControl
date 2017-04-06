//
//  FCJoyStickView.m
//  iFlightControl
//
//  Created by dRumyankov on 4/6/17.
//  Copyright © 2017 iFlight. All rights reserved.
//

#import "FCJoyStickView.h"

CGFloat const FCJoyStickViewStickCenterTargetPosLen = 5.f;

CGFloat const FCJoyStickViewLenOffset = 0.001f;

NSInteger const FCJoyStickSingleTouch = 1;

@interface FCJoyStickView ()

@property (strong, nonatomic) IBOutlet UIView *view;

@property (weak, nonatomic) IBOutlet UIImageView *ivStickBase;

@property (strong, nonatomic) UIImageView *ivStick;

@property (assign, nonatomic) CGPoint middlePoint;

@property (nonatomic) BOOL isFocus;

@end

@implementation FCJoyStickView

#pragma mark - Lifecycle

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(FCJoyStickView.class) owner:self options:nil];
        [self.view setFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        [self addSubview:self.view];
        
        [self initStick];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(FCJoyStickView.class) owner:self options:nil];
        [self addSubview:self.view];
        
        [self initStick];
    }
    return self;
}

- (void)initStick {
    self.isFocus = NO;
    self.imageNormalStick = [UIImage imageNamed:@"stick_normal.png"];
    self.imageHoldStick = [UIImage imageNamed:@"stick_hold.png"];
    self.backgroundStick = [UIImage imageNamed:@"stick_base.png"];
    self.userInteractionEnabled = YES;
    self.view.userInteractionEnabled = YES;
    
    self.ivStick = [[UIImageView alloc] initWithImage:self.imageNormalStick];
    [self.ivStick setFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    [self.view addSubview:self.ivStick];
    self.middlePoint = CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 2);
}

#pragma mark - Setters

- (void)setImageHoldStick:(UIImage *)imageHoldStick {
    _imageHoldStick = imageHoldStick;
    if (self.isFocus) {
        self.ivStick.image = self.imageHoldStick;
    }
}

- (void)setImageNormalStick:(UIImage *)imageNormalStick {
    _imageNormalStick = imageNormalStick;
    if (!self.isFocus) {
        self.ivStick.image = self.imageNormalStick;
    }
}

- (void)setBackgroundStick:(UIImage *)backgroundStick {
    _backgroundStick = backgroundStick;
    
    self.ivStickBase.image = self.backgroundStick;
}

#pragma mark - Notifications

- (void)sendDirection:(CGPoint)direction {
    NSValue *valueDirection = [NSValue valueWithCGPoint:direction];
    NSDictionary *userInfo = @{kFCDirection : valueDirection};
    [[NSNotificationCenter defaultCenter] postNotificationName:FCStickChangedNotification object:nil userInfo:userInfo];
}

#pragma mark - StickView

- (void)stickMoveTo:(CGPoint)deltaToCenter {
    double len = sqrt(pow(deltaToCenter.x, 2) + pow(deltaToCenter.y, 2));
    double len_inv = (1.0 / len);
    
    double range = (CGRectGetHeight(self.frame) / FCJoyStickViewStickCenterTargetPosLen + CGRectGetWidth(self.frame) / FCJoyStickViewStickCenterTargetPosLen) / 2;
    
    if (len > range) {
        deltaToCenter.x = deltaToCenter.x * len_inv * range;
        deltaToCenter.y = deltaToCenter.y * len_inv * range;
    }
    
    CGRect frame = self.ivStick.frame;
    frame.origin = deltaToCenter;
    self.ivStick.frame = frame;
}

#pragma mark - UITouch

- (void)touchEvent:(NSSet *)touches {
    if([touches count] != FCJoyStickSingleTouch)
        return ;
    
    NSLog(@"touch");
    
    UITouch *touch = [touches anyObject];
    UIView *view = [touch view];
    if(view != self.view)
        return ;
    
    CGPoint touchPoint = [touch locationInView:view];
    CGPoint directionTarget, direction;
    
    directionTarget = CGPointZero;
    direction = CGPointMake(touchPoint.x - self.middlePoint.x, touchPoint.y - self.middlePoint.y);
    double len = sqrt(pow(direction.x, 2) + pow(direction.y, 2));
    if(len < FCJoyStickViewLenOffset && len > -FCJoyStickViewLenOffset) {
        direction = directionTarget = CGPointZero;
    } else {
        double len_inv = (1.0 / len);
        if (self.axisAccesType == FCJoyStickViewAxisAccesTypeAll) {
            direction = CGPointMake(direction.x * len_inv, direction.y * len_inv);
            directionTarget = CGPointMake(direction.x * len, direction.y * len);
        }
        
        if (self.axisAccesType == FCJoyStickViewAxisAccesTypeHorizontal) {
            direction = CGPointMake(direction.x * len_inv, 0);
            directionTarget = CGPointMake(direction.x * len, 0);
        }
        
        if (self.axisAccesType == FCJoyStickViewAxisAccesTypeVertical) {
            direction = CGPointMake(0, direction.y * len_inv);
            directionTarget = CGPointMake(0, direction.y * len);
        }
    }
    
    [self stickMoveTo:directionTarget];
    [self sendDirection:direction];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.ivStick.image = self.imageHoldStick;
    self.isFocus = YES;
    [self touchEvent:touches];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self touchEvent:touches];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.ivStick.image = self.imageNormalStick;
    self.isFocus = NO;
    CGPoint directionTarget, direction;
    direction = directionTarget = CGPointZero;
    [self stickMoveTo:directionTarget];
    [self sendDirection:direction];
}

@end
