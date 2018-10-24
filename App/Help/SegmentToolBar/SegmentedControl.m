//
//  SegmentedControl.m
//  Copyright © 2015年 guoqiang. All rights reserved.
//

#import "SegmentedControl.h"
#import "UIColor+DSColor.h"

@interface SegmentedControl ()

@property (nonatomic, strong) NSMutableArray<UIButton *> *buttons;
@property (nonatomic, strong) UIView *indicatorView;

@end

@implementation SegmentedControl
@synthesize currentIndex;
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}


- (void)setControlTitles:(NSArray *)controlTitles{
    
    _controlTitles = controlTitles;
    _normalTextColor = [UIColor colorWithHexRGB:@"8c8c8c"];
    _focusedColor = [UIColor mainColor];
    
    self.buttons = [NSMutableArray array];
    NSInteger count =controlTitles.count;
    if (count == 0) {
        return;
    }
    CGFloat width = self.gq_width/count;
    CGFloat height = self.gq_height;
    for (int i = 0; i < count; ++i) {
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(width * i, 0, width, height)];
        [button setTitle:controlTitles[i] forState:UIControlStateNormal];
        [button setTitleColor:self.normalTextColor forState:UIControlStateNormal];
        [button setTitleColor:self.focusedColor forState:UIControlStateSelected];
        [button addTarget:self action:@selector(didClickOnButton:) forControlEvents:UIControlEventTouchUpInside];
        
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        if(self.baseFont){
            button.titleLabel.font = self.baseFont;
        }
        
        [self addSubview:button];
        [self.buttons addObject:button];
        
        UIImageView *badgeView = [[UIImageView alloc] initWithFrame:CGRectMake(width - 10, 10, 6, 6)];
        badgeView.backgroundColor = UIColorFromRGB(0xff6766);
        badgeView.hidden = YES;
        badgeView.tag = 10000;
        badgeView.layer.cornerRadius = 6/2;
        badgeView.layer.masksToBounds = YES;
        [button addSubview:badgeView];
    }
    
    UIImageView *topView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.gq_width, 1)];
    topView.image = [UIImage imageNamed:@"Line.png"];
    [self addSubview:topView];
    
    UIImageView *bottomView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.gq_height -0.5, self.gq_width, 0.5)];
    bottomView.image = [UIImage imageNamed:@"Line.png"];
    [self addSubview:bottomView];
    
    self.indicatorView = [[UIView alloc] initWithFrame:CGRectMake(width / 4, self.gq_height - 2, self.indicatorWidth, 2)];
    self.indicatorView.backgroundColor = self.focusedColor;
    [self addSubview:self.indicatorView];
   
    
    // [self didClickOnButton:self.buttons[0]];
   
    // [self didClickOnButton:self.buttons[self.currentIndex]];
}

#pragma mark 选择Button
- (void)didClickButtonForIndex:(NSInteger)index{
    
    if(self.buttons.count>0){
        UIButton* button = (UIButton*)self.buttons[index];
        [self didClickOnButton:button];
    }
}


#pragma mark Button 方法
- (IBAction)didClickOnButton:(UIButton *)sender{
    
    if (sender != self.selectedButton) {
        
        self.selectedButton.selected = NO;
        sender.selected = YES;
        self.selectedButton = sender;
        UIImageView *badgeView = [sender viewWithTag:10000];
        badgeView.hidden = YES;
        self.currentIndex = [self.buttons indexOfObject:sender];
        [UIView animateWithDuration:0.25 animations:^{
            
           // NSString *title = self.controlTitles[self.currentIndex];
           // NSDictionary *titleAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:15]};
            //CGSize size = [title sizeWithAttributes:titleAttributes];
            self.indicatorView.gq_width = self.gq_width/ ([self.buttons count]+1);
            CGPoint center = self.indicatorView.center;
            center.x = sender.center.x;
            self.indicatorView.center = center;
        }];
        
        [self.delegate segmentedControl:self didSelectItemAtIndex:self.currentIndex];
    }
}

- (void)hideBadge:(BOOL)shouldShow atIndex:(NSInteger)index{
    
    UIButton *button = self.buttons[index];
    UIImageView *badge = [button viewWithTag:10000];
    badge.hidden = shouldShow;
}



@end
