//
//  MyScrollView.m
//  MyScrollView
//
//  Created by Jennifier on 16/7/16.
//  Copyright © 2016年 xiuping xie. All rights reserved.
//

#import "MyScrollView.h"

@interface MyScrollView ()<UIScrollViewDelegate>
/** 滑动视图 */
@property(nonatomic,strong)UIScrollView *scrollView;
/** 分页控件 */
@property(nonatomic, strong)UIPageControl *pageControl;
/** 左边视图 */
@property(nonatomic, strong)UIImageView *leftImageView;
/** 中间视图 */
@property(nonatomic, strong)UIImageView *middleImageView;
/** 右边视图 */
@property(nonatomic, strong)UIImageView *rightImageView;
/** 当前页 */
@property(nonatomic, assign)NSInteger currentNumber;
/** 定时器 */
@property (nonatomic, strong) NSTimer *timer;
/** 手势识别器 */
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;


@end


@implementation MyScrollView

-(instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
    }
    
    return self;
}


-(void)setImageNames:(NSArray *)imageNames {
    
    _imageNames = imageNames;
    
    //创建子控件
    [self creatSubViews];
    
    [self startTimer];
}

#pragma mark - 1.创建子视图
-(void)creatSubViews {
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.contentSize = CGSizeMake(width * 3, height);
    
    [self addSubview:_scrollView];
    
    //创建分页控件
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 30, width, 30)];
    
    _pageControl.numberOfPages = _imageNames.count;
    _pageControl.currentPage = 0;
    
    _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    
    _pageControl.currentPageIndicatorTintColor = [UIColor grayColor];
    
    [self addSubview:_pageControl];

    
    //3.创建左中右三个图片视图
    _leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    
    _middleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(width, 0, width, height)];
    
    _rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(width *2 , 0, width, height)];
    
    
    [_scrollView addSubview:_leftImageView];
    [_scrollView addSubview:_middleImageView];
    [_scrollView addSubview:_rightImageView];
    
    //设置单击手势
    _tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    _tapGesture.numberOfTapsRequired = 1;
    _tapGesture.numberOfTouchesRequired = 1;
    [_scrollView addGestureRecognizer:_tapGesture];
    
    [self loadImage];
}

#pragma mark 单击手势
-(void)handleTap:(UITapGestureRecognizer*)sender
{
    // 判断代理有没有这个方法
    if ([self.delegate respondsToSelector:@selector(didClickPage:atIndex:)]) {
        [self.delegate didClickPage:self atIndex:_currentNumber];
    }
}

-(void)loadImage {
    
    _middleImageView.image = [UIImage imageNamed:_imageNames[_currentNumber]];
    
    
    NSInteger leftIndex = (_currentNumber - 1 + _imageNames.count) % _imageNames.count;
    _leftImageView.image = [UIImage imageNamed:_imageNames[leftIndex]];
    
    
    NSInteger rightIndex = (_currentNumber + 1) % _imageNames.count;
    _rightImageView.image = [UIImage imageNamed:_imageNames[rightIndex]];

    
    // 设置分页控件的当前页数
    _pageControl.currentPage = _currentNumber;
}


#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    //1.判断滑动方向
    if (scrollView.contentOffset.x > scrollView.bounds.size.width) {//向左滑动
        
        _currentNumber = (_currentNumber + 1) % _imageNames.count;
        
    }else if(scrollView.contentOffset.x < scrollView.bounds.size.width){ //向右滑动
        _currentNumber = (_currentNumber - 1 + _imageNames.count) % _imageNames.count;
        
    }
    
    [self loadImage];
    
    scrollView.contentOffset = CGPointMake(_scrollView.bounds.size.width, 0);
    
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self stopTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self startTimer];
}

#pragma mark - 定时器方法
- (void)stopTimer {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)startTimer {
    
    self.timer =  [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
}

/** 下一页 */
- (void)nextPage {
    
    // 说明向左在滑动
    _currentNumber = (_currentNumber + 1) % _imageNames.count;
    
    [self loadImage];
    
    //a) 偏移量设置
    _scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width, 0);
    
}

@end
