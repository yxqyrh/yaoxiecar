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
    myCollapseClick = [[CollapseClick alloc]init];
    myCollapseClick.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-80);
    [self.view addSubview:myCollapseClick];
    myCollapseClick.CollapseClickDelegate = self;
//    [self loadData];
    
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

// Required Methods
-(int)numberOfCellsForCollapseClick {
    
    if(_array == nil){
        return 0;
    }
    return _array.count;
}

-(NSString *)titleForCollapseClickAtIndex:(int)index {
    CommonProblem *commpro = _array[index];
    
    NSDictionary *_dictionary = _array[index];
    
    return [_dictionary objectForKey:@"wen"];
    
}

-(UIView *)viewForCollapseClickContentViewAtIndex:(int)index {
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(8, 0, SCREEN_WIDTH-8, 0)];
    lable.font = [UIFont boldSystemFontOfSize:13];
    lable.textAlignment = NSTextAlignmentNatural;
    lable.numberOfLines = 100;
    lable.textColor = [UIColor grayColor];
    lable.backgroundColor = [UIColor clearColor];
    NSDictionary *_dictionary = _array[index];
    NSString *content = [_dictionary objectForKey:@"da"];
//    CommonProblem *commpro = _array[index];
    CGSize size = [content sizeWithFont:lable.font constrainedToSize:CGSizeMake(lable.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    //根据计算结果重新设置UILabel的尺寸
    [lable setFrame:CGRectMake(8, 0, SCREEN_WIDTH-8, size.height)];
    lable.text = content;
    return lable;
}

-(void)loadData{
    NSDictionary *parameters = [NSMutableDictionary dictionary];
    [[MayiHttpRequestManager sharedInstance] POST:problemApi parameters:parameters showLoadingView:self.view success:^(id responseObject) {
        NSLog(@"responseObject%@",responseObject);
        NSString *res = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"res"]];
        if ([@"1" isEqualToString:res]) {
            _array= [responseObject objectForKey:@"list"];
            
            if (_array!=nil&&_array.count>0) {
                [myCollapseClick reloadCollapseClick];
                [myCollapseClick openCollapseClickCellAtIndex:0 animated:NO];
                [myCollapseClick closeCollapseClickCellAtIndex:0 animated:NO];
            }

        }
    } failture:^(NSError *error) {
       
    }];
    
    
}


@end
