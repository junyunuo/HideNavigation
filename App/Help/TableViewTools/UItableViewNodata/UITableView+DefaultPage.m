//
//  UITableView+DefaultPage.m
//  jianzhiApp
//
//  Created by 花落永恒 on 16/10/19.
//  Copyright © 2016年 花落永恒. All rights reserved.
//

#import "UITableView+DefaultPage.h"
#import <objc/runtime.h>

static char UITableViewDefaultPageView;

@implementation UITableView (DefaultPage)

@dynamic defaultPageView;


- (UIView *)defaultPageView
{
  //  self.separatorStyle = UITableViewCellSeparatorStyleNone;
    return objc_getAssociatedObject(self, &UITableViewDefaultPageView);
}

- (void)setDefaultPageView:(UIView *)defaultPageView
{
    [self willChangeValueForKey:@"LSDefaultPageView"];
    objc_setAssociatedObject(self, &UITableViewDefaultPageView,
                             defaultPageView,
                             OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"LSDefaultPageView"];
}
- (void)removeForView{
    [self.defaultPageView removeFromSuperview];
    self.defaultPageView = nil;
}
- (void)addDefaultPageWithImageName:(NSString*)imageName andTitle:(NSString*)title
{
    
    if (!self.defaultPageView)
    {
        UIView *defaultBgView = [[UIView alloc]init];
        [defaultBgView setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.gq_height)];
        defaultBgView.backgroundColor = [UIColor clearColor];
        
        UIButton *backImageView = [[UIButton alloc]init];
        backImageView.tag = 100;
        [backImageView setFrame:CGRectMake(0, 53, defaultBgView.frame.size.width, 155)];
        [backImageView setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        backImageView.contentMode = UIViewContentModeCenter;
        backImageView.adjustsImageWhenHighlighted = NO;
        [defaultBgView addSubview:backImageView];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        [titleLabel setFrame:CGRectMake(15, backImageView.gq_bottom + 15, defaultBgView.frame.size.width-30, 14)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textColor = [UIColor colorWithRed:(188)/255.0 green:(188)/255.0 blue:(188)/255.0 alpha:1.0];
        [titleLabel setNumberOfLines:0];
        [titleLabel setTag:101];
        [defaultBgView addSubview:titleLabel];
        
        [self addSubview:defaultBgView];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 5.0f;
        paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
        paragraphStyle.alignment = NSTextAlignmentCenter;
        
        NSDictionary *_attribute =  @{NSFontAttributeName:titleLabel.font,
                                      NSForegroundColorAttributeName:titleLabel.textColor,
                                      NSParagraphStyleAttributeName:paragraphStyle};
        [titleLabel setAttributedText:[[NSMutableAttributedString alloc] initWithString:title attributes:_attribute]];
        
        CGFloat widthMsg = titleLabel.bounds.size.width;
        CGSize sizeMsg = [title boundingRectWithSize:CGSizeMake(widthMsg, MAXFLOAT)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:_attribute
                                             context:nil].size;
        
        //根据计算的Size，设置消息标签的Frame
        [titleLabel setFrame:CGRectMake(15.0f, CGRectGetMaxY(backImageView.frame) + 10.0f, defaultBgView.frame.size.width-30.0f, floorf(sizeMsg.height)+1.0f)];
        
//        [defaultBgView setHidden:YES];
        
        self.defaultPageView = defaultBgView;
        
    }
}

- (void)addDefaultPageWithImageName:(NSString*)imageName andTitle:(NSString*)title andSubTitle:(NSString *)subTitle
{
    if (!self.defaultPageView)
    {
        [self addDefaultPageWithImageName:imageName andTitle:title];
        
        
        UILabel *titleLabel = [self.defaultPageView viewWithTag:101];
        UILabel *subTitleLabel = [[UILabel alloc]init];
        subTitleLabel.tag = 102;
        [subTitleLabel setFrame:CGRectMake(15, CGRectGetMaxY(titleLabel.frame) + 8.0f, self.defaultPageView.frame.size.width - 30, 14)];
        subTitleLabel.text = subTitle;
        subTitleLabel.textAlignment = NSTextAlignmentCenter;
        subTitleLabel.font = [UIFont systemFontOfSize:14];
        subTitleLabel.textColor = [UIColor colorWithRed:(188)/255.0 green:(188)/255.0 blue:(188)/255.0 alpha:1.0];
        [self.defaultPageView addSubview:subTitleLabel];
    }
    
}

- (void)addDefaultPageWithImageName:(NSString *)imageName andTitle:(NSString *)title andSubTitle:(NSString *)subTitle andBtnImage:(NSString *)btnImageName andbtnTitle:(NSString *)btnTitle andBtnAction:(SEL)action withTarget:(id)target
{
    if (!self.defaultPageView)
    {
        [self addDefaultPageWithImageName:imageName andTitle:title andSubTitle:subTitle];
        UILabel *subTitleLabel = [self.defaultPageView viewWithTag:102];
        
        UIButton *btn = [[UIButton alloc] init];
        [btn setFrame:CGRectMake(CGRectGetWidth(self.defaultPageView.frame)/2.0f-67.5, CGRectGetMaxY(subTitleLabel.frame), 135, 30)];
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = [UIColor colorWithRed:(32)/255.0 green:(198)/255.0 blue:(122)/255.0 alpha:1.0].CGColor;
        btn.layer.cornerRadius = 15;
        btn.layer.masksToBounds = YES;
        btn.tag = 103;
        if (btnImageName.length > 0) {
            [btn setBackgroundImage:[UIImage imageNamed:btnImageName] forState:UIControlStateNormal];
        }
        [btn setTitle:btnTitle forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithRed:(32)/255.0 green:(198)/255.0 blue:(122)/255.0 alpha:1.0] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        //当前tableView的superView对按钮的点击做响应
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        if (btnTitle.length == 0) {
            [btn setHidden:YES];
        } else {
            [btn setHidden:NO];
        }
        [self.defaultPageView addSubview:btn];
        
    }
}

- (void)addDefaultPageWithImageName:(NSString *)imageName andTitle:(NSString *)title andSubTitle:(NSString *)subTitle andBtnImage:(NSString *)btnImageName andbtnTitle:(NSString *)btnTitle andBtnAction:(SEL)action
{
    if (!self.defaultPageView)
    {
        [self addDefaultPageWithImageName:imageName andTitle:title andSubTitle:subTitle];
        UILabel *subTitleLabel = [self.defaultPageView viewWithTag:102];
        UIButton *btn = [[UIButton alloc]init];
        btn.tag = 103;
        [btn setFrame:CGRectMake(CGRectGetWidth(self.defaultPageView.frame)/2.0f-67.5, CGRectGetMaxY(subTitleLabel.frame), 135, 30)];
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = [UIColor colorWithRed:(32)/255.0 green:(198)/255.0 blue:(122)/255.0 alpha:1.0].CGColor;
//        btn.layer.cornerRadius = 15;
        btn.layer.masksToBounds = YES;
        if (btnImageName.length > 0) {
            [btn setBackgroundImage:[UIImage imageNamed:btnImageName] forState:UIControlStateNormal];
        }
        [btn setTitle:btnTitle forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        //当前tableView的superView对按钮的点击做响应
        [btn addTarget:self.superview action:action forControlEvents:UIControlEventTouchUpInside];
        if (btnTitle.length == 0) {
            [btn setHidden:YES];
        } else {
            [btn setHidden:NO];
        }
        [self.defaultPageView addSubview:btn];
    }
    
}

- (void)setDefaultPageWithImageName:(NSString *)imageName andTitle:(NSString *)title andSubTitle:(NSString *)subTitle andBtnImage:(NSString *)btnImageName andbtnTitle:(NSString *)btnTitle andBtnAction:(SEL)action
{
    UIButton *backImageView = [self.defaultPageView viewWithTag:100];
    if (backImageView == nil) {
        return;
    }
    UIImage *imageState = (imageName.length > 0) ? [UIImage imageNamed:imageName] : [[UIImage alloc] init];
    [backImageView setImage:imageState forState:UIControlStateNormal];
    
    UILabel *titleLabel = [self.defaultPageView viewWithTag:101];
    if (titleLabel == nil) {
        return;
    }
    [titleLabel setText:(title.length > 0) ? title:nil];
    
    UILabel *subTitleLabel = [self.defaultPageView viewWithTag:102];
    if (subTitleLabel == nil) {
        return;
    }
    
    [subTitleLabel setText:(subTitle.length > 0) ? subTitle:nil];
    
    UIButton *btn = [self.defaultPageView viewWithTag:103];
    if (btn == nil) {
        return;
    }
    [btn setTitle:(btnTitle.length > 0) ? btnTitle:nil forState:UIControlStateNormal];
    [btn addTarget:self.superview action:action forControlEvents:UIControlEventTouchUpInside];
    
    if (btnTitle.length == 0) {
        [btn setHidden:YES];
    }else {
        [btn setHidden:NO];
    }
}

- (void)setDefaultPageWithImageName:(NSString *)imageName andTitle:(NSString *)title andSubTitle:(NSString *)subTitle andBtnImage:(NSString *)btnImageName andbtnTitle:(NSString *)btnTitle andBtnAction:(SEL)action withTarget:(id)target
{
    UIButton *backImageView = [self.defaultPageView viewWithTag:100];
    if (backImageView == nil) {
        return;
    }
    UIImage *imageState = (imageName.length > 0) ? [UIImage imageNamed:imageName] : [[UIImage alloc] init];
    [backImageView setImage:imageState forState:UIControlStateNormal];
    
    UILabel *titleLabel = [self.defaultPageView viewWithTag:101];
    if (titleLabel == nil) {
        return;
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5.0f;
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary *_attribute =  @{NSFontAttributeName:titleLabel.font,
                                  NSForegroundColorAttributeName:titleLabel.textColor,
                                  NSParagraphStyleAttributeName:paragraphStyle};
    [titleLabel setAttributedText:[[NSMutableAttributedString alloc] initWithString:title attributes:_attribute]];
    
    CGFloat widthMsg = titleLabel.bounds.size.width;
    CGSize sizeMsg = [title boundingRectWithSize:CGSizeMake(widthMsg, MAXFLOAT)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:_attribute
                                         context:nil].size;
    
    //根据计算的Size，设置消息标签的Frame
    [titleLabel setFrame:CGRectMake(15.0f, CGRectGetMaxY(backImageView.frame) + 10.0f, titleLabel.frame.size.width, floorf(sizeMsg.height)+1.0f)];
    
    UILabel *subTitleLabel = [self.defaultPageView viewWithTag:102];
    if (subTitleLabel == nil) {
        return;
    }
    
    [subTitleLabel setText:(subTitle.length > 0) ? subTitle:nil];
    
    UIButton *btn = [self.defaultPageView viewWithTag:103];
    if (btn == nil) {
        return;
    }
    [btn setFrame:CGRectMake(btn.frame.origin.x, CGRectGetMaxY(titleLabel.frame) + 20.0f, btn.frame.size.width, btn.frame.size.height)];
    [btn setTitle:(btnTitle.length > 0) ? btnTitle:nil forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    if (btnTitle.length == 0) {
        [btn setHidden:YES];
    }else {
        [btn setHidden:NO];
    }
}

@end
