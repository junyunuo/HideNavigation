//
//  DSJ_MineInputSecurityPasswordView.m
//
//  Created by 李忠 on 2016/12/1.
//

#import "DSJ_MineInputSecurityPasswordView.h"
#import <Masonry/Masonry.h>
#define IMG(name) [UIImage imageNamed:name]
#define PASSWORDLENGTH (6)
#define PPIWIDTHORHEIGHT(num) num
@interface DSJ_MineInputSecurityPasswordView ()<UITextFieldDelegate>

/** 用于输入的TextField*/
@property (weak, nonatomic) UITextField *inputTextField;
/** 显示密码*/
@property (strong, nonatomic) NSArray<UITextField *> *displays;
/** 六个TextField存放view*/
@property (weak, nonatomic) UIView *displayView;

/** 取消输入密码按钮*/
@property (weak, nonatomic) UIButton *cancelButton;
/** 标题*/
@property (weak, nonatomic) UILabel *titleLabel;

/** 提示输入密码:正确输入，输入错误*/
@property (weak, nonatomic) UIButton *noticeInputButton;
/** 忘记密码按钮*/
@property (weak, nonatomic) UIButton *forgetButton;
/** toolbar*/
@property (weak, nonatomic) UIView *inputToolView;

/** 分割线*/
@property (weak, nonatomic) UIView *splitView;
/** 分割线*/
@property (weak, nonatomic) UIView *bottomView;

/** 输入的密码*/
@property (strong, nonatomic) NSMutableString *passwordNumber;



@end

@implementation DSJ_MineInputSecurityPasswordView

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setupUI];
    [self setupLayout];
}

- (void)setupUI{
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.2];
    
    UIView *inputToolView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 144.0f)];
    _inputToolView = inputToolView;
    _inputToolView.backgroundColor = [UIColor whiteColor];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _cancelButton = cancelButton;
    [_cancelButton setImage:IMG(@"navigationButtonCancel") forState:UIControlStateNormal];
    [_cancelButton addTarget:self action:@selector(clickCancelButton) forControlEvents:UIControlEventTouchUpInside];
    [_inputToolView addSubview:_cancelButton];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    _titleLabel = titleLabel;
    _titleLabel.text = self.balance;
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.font = [UIFont systemFontOfSize:17.0f];
    [_inputToolView addSubview:_titleLabel];
    
    UIView *splitView = [[UIView alloc] init];
    _splitView = splitView;
    _splitView.backgroundColor = [UIColor grayColor];
    [_inputToolView addSubview:_splitView];
    
    UIView *bottomView = [[UIView alloc] init];
    _bottomView = bottomView;
    _bottomView.backgroundColor = [UIColor grayColor];
    [_inputToolView addSubview:_bottomView];
    
    UIButton *noticeInputButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _noticeInputButton = noticeInputButton;
    _noticeInputButton.userInteractionEnabled = NO;
    [_noticeInputButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [_noticeInputButton setTitle:@"请输入支付密码" forState:UIControlStateNormal];
    [_noticeInputButton setTitle:@"输入密码错误！" forState:UIControlStateSelected];
    [_noticeInputButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [_noticeInputButton setTitleColor:[UIColor colorWithHexRGB:@"929196"] forState:UIControlStateNormal];
    [_inputToolView addSubview:_noticeInputButton];
    
    UIButton *forgetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _forgetButton = forgetButton;
    [_forgetButton setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [_forgetButton setTitleColor:[UIColor colorWithHexRGB:@"008BED"] forState:UIControlStateNormal];
    [_forgetButton addTarget:self action:@selector(clickForgetButton) forControlEvents:UIControlEventTouchUpInside];
    [_inputToolView addSubview:_forgetButton];
    [_forgetButton.titleLabel setFont:[UIFont systemFontOfSize:15]];

    
    UIView *displayView = [[UIView alloc] init];
    _displayView = displayView;
    _displayView.backgroundColor = [UIColor clearColor];
    [self.inputToolView addSubview:_displayView];
    
    UITextField *inputTextField = [[UITextField alloc] init];
    _inputTextField = inputTextField;
    _inputTextField.backgroundColor = [UIColor whiteColor];
    _inputTextField.keyboardType = UIKeyboardTypeNumberPad;
    _inputTextField.layer.borderColor = [UIColor grayColor].CGColor;
    _inputTextField.layer.borderWidth = 1.0f;
#warning 使用的时候把inputTextField 隐藏掉
    _inputTextField.hidden = YES;
    _inputTextField.delegate = self;
    
    _inputTextField.inputAccessoryView = _inputToolView;
    [self.view addSubview:_inputTextField];
    
}


- (void)setupLayout{
    
    [_inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_offset(PPIWIDTHORHEIGHT(10.0f));
        make.trailing.mas_offset(-PPIWIDTHORHEIGHT(10.0f));
        make.height.mas_offset(51.0f);
        make.top.mas_equalTo(100.0f);
    }];

    [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(12.0f);
        make.leading.mas_offset(PPIWIDTHORHEIGHT(10.0f));
        make.size.mas_offset(CGSizeMake(16.0f, 16.0f));
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(12.0f);
        make.centerX.mas_equalTo(_inputToolView.mas_centerX);
    }];
    [_splitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_cancelButton.mas_bottom).mas_offset(15.0f);
        make.leading.trailing.mas_offset(0.0f);
        make.height.mas_offset(1.0f);
    }];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_inputToolView.mas_bottom).mas_offset(-1.0f);
        make.leading.trailing.mas_offset(0.0f);
        make.height.mas_offset(1.0f);
    }];
    [_noticeInputButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_splitView.mas_bottom).mas_offset(13.0f);
        make.leading.mas_offset(PPIWIDTHORHEIGHT(10.0f));
        
    }];
    
    [_displayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_noticeInputButton.mas_bottom).mas_offset(13.0f);
        make.leading.trailing.mas_offset(0.0f);
        make.height.mas_offset(51.0f);
        make.bottom.mas_offset(-12.0f);
    }];
    
    [self.displays mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:PPIWIDTHORHEIGHT(10.0f) leadSpacing:PPIWIDTHORHEIGHT(10.0f) tailSpacing:PPIWIDTHORHEIGHT(10.0f)];
    [self.displays mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_offset(0.0f);
    }];
    
    [_forgetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_splitView.mas_bottom).mas_offset(13.0f);
        make.trailing.mas_offset(-PPIWIDTHORHEIGHT(10.0f));
        make.bottom.mas_equalTo(_noticeInputButton.mas_bottom);
    }];

}


#pragma mark - 点击事件 -
- (void)clickCancelButton{
    [self.inputTextField resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)clickForgetButton{
    NSLog(@"clickForgetButton");
    if(self.forgetPsdCompleteBlock){
        [self dismissViewControllerAnimated:YES completion:nil];
        self.forgetPsdCompleteBlock();
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.inputTextField becomeFirstResponder];
}

#pragma mark - inputTextField第一响应者 -
- (void)inputBecomeFirst{
    [self.inputTextField becomeFirstResponder];
}
#pragma mark - 清除密码 -
- (void)clearPassword{
    [self.inputTextField setText:@""];
    for (UITextField *text in self.displays) {
        [text setText:@""];
    }
    self.passwordNumber = nil;
}
#pragma mark - UITextFiled 代理方法 -
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSInteger count = [self.inputTextField.text length];
    if ([string isEqualToString:@""]) {
        count--;
        NSRange range = NSMakeRange(count, 1);
        [self.passwordNumber deleteCharactersInRange:range];
        
    }
    if (count < PASSWORDLENGTH) {
        [self.passwordNumber appendString:string];
        [self.displays[count] setText:string];
#warning 密码超过指定位数
        if ([self.passwordNumber length] == PASSWORDLENGTH) {
            
            [self.inputTextField resignFirstResponder];
            
            if(self.inputCompleteBlock){
                [self dismissViewControllerAnimated:YES completion:nil];
                self.inputCompleteBlock(self.passwordNumber);
            }
        }
        return YES;
    }
    
    return NO;
}

#pragma mark - 属性 get方法 -
- (NSArray<UITextField *> *)displays{
    if (_displays == nil) {
        NSMutableArray<UITextField *> *arrM = [NSMutableArray array];
        for (int i = 0; i < PASSWORDLENGTH; i++) {
            [arrM addObject:[self createtextField]];
        }
        _displays = arrM.copy;
    }
    return _displays;
}
- (NSMutableString *)passwordNumber{
    if (_passwordNumber == nil) {
        _passwordNumber = [NSMutableString string];
    }
    return _passwordNumber;
}

#pragma mark - 快捷创建Field -
- (UITextField *)createtextField{
    UITextField *textfield = [[UITextField alloc] init];
    textfield.backgroundColor = [UIColor whiteColor];
    textfield.secureTextEntry = YES;
    textfield.layer.borderColor = [UIColor grayColor].CGColor;
    textfield.layer.borderWidth = 1.0f;
    textfield.userInteractionEnabled = NO;
    textfield.textAlignment = NSTextAlignmentCenter;
    [_displayView addSubview:textfield];
    return textfield;
}

@end
