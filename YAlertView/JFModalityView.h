//
//  JFModalityView.h
//  WAF
//
//  Created by yanqs on 15/11/23.
//  Copyright © 2015年 西安交大捷普网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Category.h"

enum
{
    JFModalityViewStyleWonderful,
    JFModalityViewStyleStanderd,
    JFModalityViewStylePlain,
};

typedef int JFModalityViewStyle;

@interface JFModalityView : UIView
{
    @private
    JFModalityViewStyle _style;
}

- (instancetype)initWithView:(UIView *)view AtStyle:(JFModalityViewStyle)style;

- (void)show;
@property (nonatomic, copy) void (^closeTapped)();
- (void)close;

@end
