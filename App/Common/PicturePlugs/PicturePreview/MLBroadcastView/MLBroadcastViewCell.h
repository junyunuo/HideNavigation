//
//  MLBroadcastViewCell.h
//  ImageSelectAndCrop
//

#import <UIKit/UIKit.h>

@interface MLBroadcastViewCell : UIView

@property (nonatomic, readonly, copy) NSString *reuseIdentifier;

- (void)prepareForReuse;

- (instancetype)initWithReuseIdentifier:(NSString*)reuseIdentifier;

@end
