//
//  MyScrollView.h
//  MyScrollView
//
//  Created by Jennifier on 16/7/16.
//  Copyright © 2016年 xiuping xie. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyScrollView;

//协议
@protocol MyScrollViewDelegate <NSObject>

@optional

- (void)didClickPage:(MyScrollView *)view atIndex:(NSInteger)index;

@end


@interface MyScrollView : UIView

/** 属性 */
@property(nonatomic,strong)NSArray *imageNames;
/** 代理 */
@property (nonatomic, assign) id<MyScrollViewDelegate> delegate;

@end
