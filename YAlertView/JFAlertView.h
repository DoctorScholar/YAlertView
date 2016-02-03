//
//  JFAlertView.h
//  WAF
//
//  Created by yanqs on 15/12/2.
//  Copyright © 2015年 西安交大捷普网络科技有限公司. All rights reserved.
//

#import "JFModalityView.h"
#import "RIButtonItem.h"

@interface JFAlertView : JFModalityView

- (instancetype)initWithView:(UIView *)view AtStyle:(JFModalityViewStyle)style withTitle:(NSString *)inTitle message:(NSString *)inMessage cancelButtonItem:(RIButtonItem *)inCancelButtonItem otherButtonItems:(RIButtonItem *)inOtherButtonItems, ... NS_REQUIRES_NIL_TERMINATION;

@end
