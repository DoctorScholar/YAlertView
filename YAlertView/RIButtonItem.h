//
//  RIButtonItem.h
//  Shibui
//
//  Created by Jiva DeVoe on 1/12/11.
//  modify By IOS_Doctor on 2014-10-27
//  Copyright 2011 Random Ideas, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RIButtonItem : NSObject
{
    NSString *label;
    void (^action)();
}
@property (retain, nonatomic) NSString *label;
@property (copy, nonatomic) void (^action)();
+ (id)item;
+ (id)itemWithLabel:(NSString *)inLabel;
+ (id)itemWithLabel:(NSString *)inLabel action:(void(^)(void))action;

@end

