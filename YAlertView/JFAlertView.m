//
//  JFAlertView.m
//  WAF
//
//  Created by yanqs on 15/12/2.
//  Copyright © 2015年 西安交大捷普网络科技有限公司. All rights reserved.
//

#import "JFAlertView.h"
#import <objc/runtime.h>
#import "UIView+Category.h"
static char RI_BUTTON_ASS_KEY = 'Z';

@implementation JFAlertView

- (instancetype)initWithView:(UIView *)view AtStyle:(JFModalityViewStyle)style withTitle:(NSString *)inTitle message:(NSString *)inMessage cancelButtonItem:(RIButtonItem *)inCancelButtonItem otherButtonItems:(RIButtonItem *)inOtherButtonItems, ...
{
    if (self = [super initWithView:view AtStyle:style]) {
        
        NSMutableArray *buttonsArray = [NSMutableArray array];
        
        RIButtonItem *eachItem;
        va_list argumentList;
        if (inOtherButtonItems) {
            
            [buttonsArray addObject: inOtherButtonItems];
            va_start(argumentList, inOtherButtonItems);
            while((eachItem = va_arg(argumentList, RIButtonItem *))) {
                [buttonsArray addObject: eachItem];
            }
            va_end(argumentList);
        }
        
        UIView *operationPanel = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 150)];
        operationPanel.backgroundColor = [UIColor clearColor];
        [self addSubview:operationPanel];
        
        NSMutableArray *buttons = [NSMutableArray new];
        void (^addBtn) (NSInteger tag, NSString *title) = ^ (NSInteger tag, NSString *title) {
            
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn setTitle:title forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(btnTapped:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = tag;
            btn.titleLabel.font = [UIFont systemFontOfSize:13];
            [operationPanel addSubview:btn];
            [buttons addObject:btn];
        };
        
        for (int i = 0; i < buttonsArray.count; i ++) {

            RIButtonItem *item = (RIButtonItem *)buttonsArray[i];
            addBtn(i + 1000, item.label);
        }
        
        UILabel *title;
        if (inTitle) {
            
            title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, operationPanel.width, 30)];
            title.font = [UIFont systemFontOfSize:15];
            title.textAlignment = NSTextAlignmentCenter;
            title.textColor = [UIColor blackColor];
            title.text = inTitle;
            [operationPanel addSubview:title];
        }
        
        UILabel *description;
        if (inMessage) {
            
            description = [[UILabel alloc] initWithFrame:CGRectMake(10, (title)? title.bottom + 10 : 0, operationPanel.width - 20, 30)];
            description.font = [UIFont systemFontOfSize:13.5];
            description.textAlignment = NSTextAlignmentCenter;
            description.numberOfLines = 0;
            description.lineBreakMode = NSLineBreakByCharWrapping;
            description.height = [inMessage sizeWithFont:description.font constrainedToSize:CGSizeMake(description.width, 1000) lineBreakMode:NSLineBreakByCharWrapping].height;
            description.textColor = [UIColor blackColor];
            description.text = inMessage;
            [operationPanel addSubview:description];
        }
        
        if (inCancelButtonItem) {
            
            if ([inCancelButtonItem isKindOfClass:[NSString class]]) {
                
                [buttonsArray addObject:[RIButtonItem itemWithLabel:(NSString *)inCancelButtonItem]];
                addBtn(buttonsArray.count + 1000, (NSString *)inCancelButtonItem);
            }
            else{
                [buttonsArray addObject:inCancelButtonItem];
                addBtn(buttonsArray.count + 1000, ((RIButtonItem *)inCancelButtonItem).label);
            }
        }
        
        BOOL veriable = NO;
        if (buttons.count > 2) {
            veriable = YES;
        }
        else{
            for (int i = 0; i < buttons.count; i ++) {
                
                UIButton *btn = buttons[i];
                CGFloat width = [btn.titleLabel.text sizeWithFont:btn.titleLabel.font constrainedToSize:CGSizeMake(1000, btn.titleLabel.font.pointSize + 2) lineBreakMode:btn.titleLabel.lineBreakMode].width;
                if (width > operationPanel.width / 2) {
                    veriable = YES;
                }
            }
        }
        for (int i = 0; i < buttons.count; i ++) {
            
           UIButton *btn = buttons[i];
            btn.width = [btn.titleLabel.text sizeWithFont:btn.titleLabel.font constrainedToSize:CGSizeMake(1000, btn.titleLabel.font.pointSize + 2) lineBreakMode:btn.titleLabel.lineBreakMode].width;
            if (btn.width > operationPanel.width) {
                btn.width = operationPanel.width;
            }
            if (veriable) {
                
                btn.top = i * 40 + ((description)? description.bottom + 10 : ((title)? title.bottom + 10 : 10));
                btn.centerX = operationPanel.width / 2;
            }
            else{
                
                btn.centerX = (buttons.count > 1)? (i == 0)? operationPanel.width / 4 : operationPanel.width / 4 * 3 : operationPanel.width / 2;
                btn.top = ((description)? description.bottom + 10 : ((title)? title.bottom + 10 : 10));
            }
            if (i == buttons.count - 1) {
                operationPanel.height = btn.bottom + 10;
            }
        }
        if (buttons.count == 0) {
            operationPanel.height = ((description)? description.bottom + 30 : ((title)? title.bottom + 30 : 30));
        }

        objc_setAssociatedObject(self, (const void *)&RI_BUTTON_ASS_KEY, buttonsArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return self;
}

- (void)btnTapped:(UIButton *)button
{
    // If the button index is -1 it means we were dismissed with no selection
    
    NSArray *buttonsArray = objc_getAssociatedObject(self, (const void *)&RI_BUTTON_ASS_KEY);
    if (button.tag - 1000 < buttonsArray.count && button.tag - 1000 >= 0) {
        
        RIButtonItem *item = [buttonsArray objectAtIndex:button.tag - 1000];
        if (item.action)
            item.action();
    }
    
    objc_setAssociatedObject(self, (const void *)&RI_BUTTON_ASS_KEY, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self close];
}

@end
