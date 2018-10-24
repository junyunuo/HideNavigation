//
//  CategoryTableViewCell.m
//  App
//
//  Created by guoqiang on 2018/10/22.
//  Copyright © 2018年 guoqiang. All rights reserved.
//

#import "CategoryTableViewCell.h"
#import "CategoryCollectionViewCell.h"

#define CellHeight 200

@interface CategoryTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

/* collectionview */
@property (strong , nonatomic)UICollectionView *collectionView;
@property(nonatomic,strong)UIButton* pageBtn;

@end

@implementation CategoryTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self initSubView];
    }
    return self;
}

- (void)initSubView{
    
    UICollectionViewFlowLayout *dcFlowLayout = [UICollectionViewFlowLayout new];
    dcFlowLayout.minimumLineSpacing = dcFlowLayout.minimumInteritemSpacing = 0;
    dcFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:dcFlowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.frame = CGRectMake(0, 0, kMainScreenOfWidth, CellHeight);
    self.collectionView.pagingEnabled = YES;
    self.collectionView.bounces = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor redColor];
    [self addSubview:self.collectionView];
    [self.collectionView registerClass:[CategoryCollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    
    
    self.pageBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.collectionView.gq_bottom, kMainScreenOfWidth, 30)];
    [self.pageBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.pageBtn setTitleColor:[UIColor redColor] forState:0];
    [self.pageBtn setTitle:@"1" forState:0];
    [self addSubview:self.pageBtn];
    
    
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
//    if(indexPath.row == 1){
//        cell.backgroundColor = [UIColor grayColor];
//    }else if(indexPath.row == 2){
//        cell.backgroundColor = [UIColor greenColor];
//    }
    
    return cell;
}

#pragma mark - <UICollectionViewDelegateFlowLayout>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kMainScreenOfWidth, CellHeight);
}

#pragma mark - 通过代理来让她滑到最后一页再左滑动就切换控制器
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    CGPoint currentPoint = scrollView.contentOffset;
    NSInteger page = currentPoint.x / scrollView.gq_width;
    [self.pageBtn setTitle:[NSString stringWithFormat:@"%ld",page+1] forState:0];
//    _pageControl.currentPage = page;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
