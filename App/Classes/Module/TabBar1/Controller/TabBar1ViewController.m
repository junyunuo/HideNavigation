//
//  TabBar1ViewController.m
//  App
//
//  Created by guoqiang on 2018/9/13.
//  Copyright © 2018年 guoqiang. All rights reserved.
//

#import "TabBar1ViewController.h"
#import "ListTableViewCell.h"
#import "TopView.h"
#import "TabBar2ViewController.h"
#import "BannerTableViewCell.h"
#import "CategoryTableViewCell.h"
#import "SortSegmentedControl.h"

#define oriOfftY -64
#define oriHeight 200

@interface TabBar1ViewController ()<UITableViewDelegate,UITableViewDataSource,SortSegmentedControlDelegate>
@property(nonatomic,strong)UITableView* tableView;
@property(nonatomic,strong)TopView* topView;
@property (nonatomic,strong) UIView *nav;
@property(nonatomic,strong)UISearchBar* searchBar;
@property(nonatomic,strong)SortSegmentedControl * sortSegmentedControl;


@end

@implementation TabBar1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor redColor];
    self.navigationItem.title = @"TabBar1";
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[BannerTableViewCell class] forCellReuseIdentifier:@"BannerCell"];
    [self.tableView registerClass:[CategoryTableViewCell class] forCellReuseIdentifier:@"CategoryCell"];
    
        [self.tableView registerClass:[ListTableViewCell class] forCellReuseIdentifier:@"Cell"];

   // [self.tableView registerNib:[UINib nibWithNibName:@"ListTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initNavigationView];
}

#pragma mark --- 初始化导航栏
- (void)initNavigationView{
    
    self.nav = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenOfWidth, 64)];
    self.nav.backgroundColor = [UIColor whiteColor];
    self.nav.alpha = 0;
    [self.view addSubview:self.nav];
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(10, 20,kMainScreenOfWidth - 80, 44)];
    self.searchBar.placeholder = @"输入商家,商品名称";
    UITextField* searchField = [self.searchBar valueForKey:@"searchField"];
    if(searchField){
        [searchField setBackgroundColor:[UIColor colorWithHexRGB:@"EAEAEA"]];
        searchField.layer.cornerRadius=18;//设置圆角具体根据实际情况来设置
        searchField.layer.masksToBounds=YES;
    }
    for(int i =  0 ;i < _searchBar.subviews.count;i++){
        UIView * backView = _searchBar.subviews[i];
        if ([backView isKindOfClass:NSClassFromString(@"UISearchBarBackground")] == YES) {
            [backView removeFromSuperview];
            [_searchBar setBackgroundColor:[UIColor clearColor]];
            break;
        }else{
            NSArray * arr = _searchBar.subviews[i].subviews;
            for(int j = 0;j<arr.count;j++   ){
                UIView * barView = arr[i];
                if ([barView isKindOfClass:NSClassFromString(@"UISearchBarBackground")] == YES) {
                    [barView removeFromSuperview];
                    [_searchBar setBackgroundColor:[UIColor clearColor]];
                    break;
                }
            }
        }
    }
    [self.nav addSubview:self.searchBar];
    
    UIButton* signBtn  = [[UIButton alloc] initWithFrame:CGRectMake(self.nav.gq_width - 44 - 10, self.searchBar.gq_top, 44, 44)];
    [signBtn setTitle:@"sign" forState:0];
    [signBtn setTitleColor:[UIColor blackColor] forState:0];
    [self.nav addSubview:signBtn];
    
    UIButton* messageBtn = [[UIButton alloc] initWithFrame:CGRectMake(signBtn.gq_left - 10 -44, signBtn.gq_top, 44, 44)];
    [messageBtn setTitle:@"mess" forState:0];
    [messageBtn setTitleColor:[UIColor blackColor] forState:0];
    [self.nav addSubview:messageBtn];
    self.searchBar.gq_width = messageBtn.gq_left -10;
    
}


- (UITableView*)tableView{
    if(!_tableView){
        // 1. 创建tableView
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, kMainScreenOfWidth,kMainScreenOfHeight - 64 + 20) style:UITableViewStylePlain];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.backgroundColor = [UIColor backGroundColor];
        tableView.showsVerticalScrollIndicator = NO;
        tableView.tableFooterView = [UIView new];
//        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.tableHeaderView =  [[TopView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenOfWidth, 120)];
        tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
        self.tableView = tableView;
    }
    return _tableView;
}
#pragma mark - scrollview
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"%f", scrollView.contentOffset.y);
    CGFloat offset = scrollView.contentOffset.y;

    CGFloat alpha = offset * 1 / 136.0;   // (200 - 64) / 136.0f
    if(offset > 350){
        alpha = 1- (offset - 350 ) * 1 /136.0;
        if(alpha < 0){
            alpha = 0;
        }
    }else{
        if (alpha >= 1) {
            alpha = 1;
        }
    }
    self.nav.alpha = alpha;

//    //根据透明度来生成图片
//    //找最大值/
//    CGFloat alpha = offset * 1 / 136.0;   // (200 - 64) / 136.0f
//    if (alpha >= 1) {
//        alpha = 1;
//       // self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
//      //  self.tableView.gq_top = 64;
//    }else{
//       // self.tableView.contentInset = UIEdgeInsetsMake(-24, 0, 0, 0);
//       // self.tableView.gq_top = 0;
//    }
//    if(offset >400){
//        self.nav.alpha = -alpha;
//    }else{
//        self.nav.alpha = alpha;
//    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(section == 0 || section == 1){
        return 1;
    }
    return 100;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 1){
        return 230;
    }
    return 100;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 0){
        BannerTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"BannerCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if(indexPath.section == 1){
        CategoryTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CategoryCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        ListTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if(section == 0 || section == 1){
        return 0;
    }
    return 100;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenOfWidth, 100)];
    view.backgroundColor = [UIColor whiteColor];
    
    
    UILabel* titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(15,25, 100,20);
    [titleLabel setText:@"推荐商家"];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font=[UIFont systemFontOfSize:20];
    [view addSubview:titleLabel];
    
//    AXRatingView *stepRatingView = [[AXRatingView alloc] initWithFrame:CGRectMake(titleLabel.gq_right,25, 100, 20)];
//    [stepRatingView sizeToFit];
//    [stepRatingView setStepInterval:1.0];
//    [view addSubview:stepRatingView];
    
    _sortSegmentedControl = [[SortSegmentedControl alloc] initWithFrame:CGRectMake(0,titleLabel.gq_bottom + 5, kMainScreenOfWidth, 50)];
    _sortSegmentedControl.titleFont = [UIFont systemFontOfSize:14];
    _sortSegmentedControl.normalColor = [UIColor colorWithHexRGB:@"666666"];
    _sortSegmentedControl.delegate = self;
    _sortSegmentedControl.selectColor = [UIColor blackColor];
    [_sortSegmentedControl setControlTitles:@[@"综合排序",@"销量最高",@"距离最近",@"筛选"]];
    [view addSubview:_sortSegmentedControl];
    
    return view;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TabBar2ViewController* vc = [[TabBar2ViewController alloc] init];
    [self pushViewController:vc animated:true];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
