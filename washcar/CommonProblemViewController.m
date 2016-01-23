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
//    myCollapseClick = [[CollapseClick alloc]init];
//    myCollapseClick.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-80);
//    [self.view addSubview:myCollapseClick];
//    myCollapseClick.CollapseClickDelegate = self;
//    [self loadData];
    
    
    
    UIColor *titleBgColor = [UIColor colorWithRed:179/255.0 green:143/255.0 blue:195/255.0 alpha:1];
    CGRect rect = [UIScreen mainScreen ].bounds;
    
//    if (!OSVersionIsAtLeastiOS7())
//    {
//        rect.size.height -= 20 + 44;
//        [self.navigationController.navigationBar setTintColor:titleBgColor];
//    }
//    else
//    {
//        [self.navigationController.navigationBar setBarTintColor:titleBgColor];
//    }
    
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
//    view.layer.backgroundColor  = [UIColor colorWithRed:246/255.0 green:213/255.0 blue:105/255.0 alpha:1].CGColor;
//    view.layer.masksToBounds    = YES;
//    view.layer.borderWidth      = 0.5;
//    view.layer.borderColor      = [UIColor colorWithRed:250/255.0 green:77/255.0 blue:83/255.0 alpha:1].CGColor;
    
    
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(8, 0, SCREEN_WIDTH-8, 0)];
        lable.font = [UIFont boldSystemFontOfSize:13];
        lable.textAlignment = NSTextAlignmentNatural;
        lable.numberOfLines = 100;
        lable.textColor = [UIColor grayColor];
        lable.backgroundColor = [UIColor clearColor];
        NSDictionary *_dictionary = _array[current_open_index];
        NSString *content = [_dictionary objectForKey:@"da"];
    
        CGSize size = [content sizeWithFont:lable.font constrainedToSize:CGSizeMake(lable.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
        //根据计算结果重新设置UILabel的尺寸
        [lable setFrame:CGRectMake(8, 8, SCREEN_WIDTH-8, size.height)];
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
    return 44;
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
//    header.layer.backgroundColor    = [UIColor colorWithRed:222/255.0 green:222/255.0 blue:222/255.0 alpha:1].CGColor;
    header.layer.masksToBounds      = YES;
    header.layer.borderWidth        = 0.5;
    header.layer.borderColor        = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1].CGColor;
    UILabel *titleView = [[UILabel alloc]initWithFrame:CGRectMake(8, 0, SCREEN_WIDTH-8,44)];
    titleView.textColor = [UIColor grayColor];
    NSDictionary *_dictionary = _array[section];
     titleView.font = [UIFont boldSystemFontOfSize:15];
    NSString *title =[_dictionary objectForKey:@"wen"];
    titleView.text = title;
    [header addSubview:titleView];
    return header;
}


- (void)mTableView:(TQMultistageTableView *)mTableView willOpenHeaderAtSection:(NSInteger)section
{
    current_open_index =section;
}


@end
