//
//  ListTableViewCell.h
//  App
//
//  Created by guoqiang on 2018/10/17.
//  Copyright © 2018年 guoqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

- (void)setCellData:(NSDictionary*)dict;

@end

NS_ASSUME_NONNULL_END
