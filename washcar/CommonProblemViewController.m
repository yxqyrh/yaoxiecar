//
//  CommonProblemViewController.m
//  MayiCar
//
//  Created by xiejingya on 9/26/15.
//  Copyright (c) 2015 xiejingya. All rights reserved.
//

#import "CommonProblemViewController.h"
#import "MayiHttpRequestManager.h"
#import "CommonProblem.h"
#import "Constant.h"
#define SCREEN_WIDTH                    ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT                   ([UIScreen mainScreen].bounds.size.height)
@interface CommonProblemViewController (){
    NSArray *_array ;
    int current_open_index ;
}

@end
//http://g.pps.tv/api/ginterface/getFaqInfo
@implementation CommonProblemViewController
-(void)viewWillAppear:(BOOL)animated{
    [self initNav];
}

-(void)initNav{
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"常见问题";
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    UIColor *titleBgColor = [UIColor colorWithRed:179/255.0 green:143/255.0 blue:195/255.0 alpha:1];
    CGRect rect = [UIScreen mainScreen ].bounds;
    self.mTableView = [[TQMultistageTableView alloc] initWithFrame:rect];
    self.mTableView.dataSource = self;
    self.mTableView.delegate   = self;
    self.mTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.mTableView];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.mTableView.bounds.size.width, 100)];
    view.backgroundColor = [UIColor colorWithRed:251/255.0 green:125/255.0 blue:91/255.0 alpha:1];
    self.mTableView.atomView = view;
     [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)loadData{
    NSDictionary *parameters = [NSMutableDictionary dictionary];
    [[MayiHttpRequestManager sharedInstance] POST:problemApi parameters:parameters showLoadingView:self.view success:^(id responseObject) {
        NSLog(@"responseObject%@",responseObject);
        NSString *res = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"res"]];
        if ([@"1" isEqualToString:res]) {
            _array= [responseObject objectForKey:@"list"];
            
            if (_array!=nil&&_array.count>0) {
                [ self.mTableView  reloadData];
            }
        }
    } failture:^(NSError *error) {
       
    }];
}
- (NSInteger)mTableView:(TQMultistageTableView *)mTableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)mTableView:(TQMultistageTableView *)mTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"TQMultistageTableViewCell";
    UITableViewCell *cell = [mTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    UIView *view = [[UIView alloc] initWithFrame:cell.bounds] ;
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(8, 0, SCREEN_WIDTH-16, 0)];
    lable.font = [UIFont boldSystemFontOfSize:13];
    lable.textAlignment = NSTextAlignmentNatural;
    lable.numberOfLines = 0;
    lable.textColor = [UIColor grayColor];
    lable.backgroundColor = [UIColor clearColor];
    NSDictionary *_dictionary = _array[current_open_index];
    NSString *content = [_dictionary objectForKey:@"da"];
    CGSize size = [content sizeWithFont:lable.font constrainedToSize:CGSizeMake(lable.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
        //根据计算结果重新设置UILabel的尺寸
    [lable setFrame:CGRectMake(8, 8, SCREEN_WIDTH-16, size.height)];
    lable.text = content;
    [view addSubview:lable];
    cell.backgroundView = view;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(TQMultistageTableView *)mTableView
{
        if(_array == nil){
            return 0;
        }
        return _array.count;
}

#pragma mark - Table view delegate

- (CGFloat)mTableView:(TQMultistageTableView *)mTableView heightForHeaderInSection:(NSInteger)section
{
    NSDictionary *_dictionary = _array[section];
    NSString *title =[_dictionary objectForKey:@"wen"];
    UIFont *font_mes = [UIFont systemFontOfSize:14];
    CGSize size_mes = [title sizeWithFont:font_mes constrainedToSize:CGSizeMake(SCREEN_WIDTH-100, 1000.0f) lineBreakMode:UILineBreakModeWordWrap];
    return size_mes.height+16;
}

- (CGFloat)mTableView:(TQMultistageTableView *)mTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(16, 0, SCREEN_WIDTH-8, 0)];
    lable.font = [UIFont boldSystemFontOfSize:13];
    lable.textAlignment = NSTextAlignmentNatural;
    lable.numberOfLines = 100;
    lable.textColor = [UIColor whiteColor];
    lable.backgroundColor = [UIColor clearColor];
    NSDictionary *_dictionary = _array[current_open_index];
    NSString *content = [_dictionary objectForKey:@"da"];
    CGSize size = [content sizeWithFont:lable.font constrainedToSize:CGSizeMake(lable.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    return size.height+20;
}

- (CGFloat)mTableView:(TQMultistageTableView *)mTableView heightForAtomAtIndexPath:(NSIndexPath *)indexPath
{
    return 0;
}

- (UIView *)mTableView:(TQMultistageTableView *)mTableView viewForHeaderInSection:(NSInteger)section;
{
    UIView *header = [[UIView alloc] init];
    header.layer.backgroundColor =  [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0].CGColor;
    header.layer.masksToBounds      = YES;
    header.layer.borderWidth        = 0.5;
    header.layer.borderColor        = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1].CGColor;
    NSDictionary *_dictionary = _array[section];
    NSString *title =[_dictionary objectForKey:@"wen"];
    UIFont *font_mes = [UIFont systemFontOfSize:14];
    CGSize size_mes = [title sizeWithFont:font_mes constrainedToSize:CGSizeMake(SCREEN_WIDTH-100, 1000.0f) lineBreakMode:UILineBreakModeWordWrap];
    UILabel *titleView = [[UILabel alloc]initWithFrame:CGRectMake(8, 8, SCREEN_WIDTH-16,size_mes.height)];
    titleView.textColor = [UIColor grayColor];
     titleView.font = [UIFont boldSystemFontOfSize:14];
    titleView.lineBreakMode = UILineBreakModeWordWrap;
    titleView.numberOfLines = 0;//上面两行设置多行显示
    titleView.text = title;
    [header addSubview:titleView];
    return header;
}


- (void)mTableView:(TQMultistageTableView *)mTableView willOpenHeaderAtSection:(NSInteger)section
{
    current_open_index =section;
}


@end
