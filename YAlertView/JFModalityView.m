//
//  JFModalityView.m
//  WAF
//
//  Created by yanqs on 15/11/23.
//  Copyright © 2015年 西安交大捷普网络科技有限公司. All rights reserved.
//

#import "JFModalityView.h"

@interface JFModalityView ()

@end

@implementation JFModalityView
{
    UIToolbar *_toolBar;
    CALayer *_mask;
    
    UITapGestureRecognizer *_tap;
}

- (void)dealloc
{
    NSLog(@"dealloc:%@", self);
}

- (instancetype)initWithView:(UIView *)view AtStyle:(JFModalityViewStyle)style
{
    if (self == [super initWithFrame:CGRectMake(view.width / 5, view.height / 5, view.width / 5 * 3, view.height / 5 * 3)]) {
        
        self.hidden = YES;
        _style = style;
        
        self.backgroundColor = [UIColor clearColor];
        [view addSubview:self];
    }
    return self;
}

- (void)_blurBgViewWithSuperview:(UIView *)superView
{
    if (!_toolBar) {
        
        _toolBar = [[UIToolbar alloc] initWithFrame:self.superview.bounds];
        _toolBar.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _toolBar.alpha = 0;
        
        [superView addSubview:_toolBar];
        [self _addGestureWithView:_toolBar];
        [self bringToFront];
    }
}

- (void)_mask
{
    if (!_mask) {
        
        _mask = [CALayer layer];
        _mask.frame = self.superview.bounds;
        _mask.backgroundColor = RGB(20, 20, 20).CGColor;
        _mask.opacity = 0;
        [self.superview.layer addSublayer:_mask];
        [self _addGestureWithView:self.superview];
        [self bringToFront];
    }
}

- (void)_addGestureWithView:(UIView *)view
{
    _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTapped:)];
    [view addGestureRecognizer:_tap];
}

- (void)tapTapped:(UIGestureRecognizer *)gesture
{
    [self close];
}

- (void)show
{
    if (self.subviews.count > 0) {
        
        self.frame = CGRectMake((self.superview.width - self.subviews[0].width) / 2, (self.superview.height - self.subviews[0].height) / 2, self.subviews[0].width, self.subviews[0].height);
        if (self.top < self.left / self.superview.width * self.superview.height) {
            
            self.top = self.left / self.superview.width * self.superview.height;
            self.height = self.superview.height - self.left / self.superview.width * self.superview.height * 2;
            self.subviews[0].height = self.height;
        }
    }
    
    switch (_style) {
        case JFModalityViewStyleWonderful: {
            
            [self _blurBgViewWithSuperview:self.superview];
            self.backgroundColor = [UIColor whiteColor];
        } break;
        case JFModalityViewStyleStanderd: {
            
            [self _mask];
            [self _blurBgViewWithSuperview:self];
        } break;
        case JFModalityViewStylePlain: {
            
            [self _mask];
            self.backgroundColor = [UIColor whiteColor];
        } break;
        default:
            break;
    }
    
    self.hidden = NO;
    __weak typeof(self) weakSelf = self;
    self.transform = CGAffineTransformMakeScale(0, 0);
    [UIView animateWithDuration:0.3 animations:^{
        
        weakSelf.transform = CGAffineTransformMakeScale(1.2, 1.2);
        weakSelf.layer.masksToBounds = YES;
        weakSelf.layer.cornerRadius = 30;
        if (_toolBar) {
            _toolBar.alpha = 1;
        }
        if (_mask) {
            _mask.opacity = 0.05;
        }
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            weakSelf.transform = CGAffineTransformMakeScale(1, 1);
        } completion:^(BOOL finished) {
            //...
        }];
    }];
}

- (void)close
{
    if (self.closeTapped) {
        self.closeTapped();
    }
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        
        weakSelf.transform = CGAffineTransformMakeScale(0, 0);
        if (_toolBar) {
            _toolBar.alpha = 0;
        }
        if (_mask) {
            _mask.opacity = 0;
        }
    } completion:^(BOOL finished) {
        
        if (_toolBar) {
            [_toolBar removeFromSuperview];
        }
        if (_mask) {
            
            BOOL isRmeoved = [self.superview removeGesture:_tap];
            if (!isRmeoved) {
                [self.superview removeAllGesture];
            }
            [_mask removeFromSuperlayer];
        }
        [weakSelf removeFromSuperview];
    }];
}

@end
