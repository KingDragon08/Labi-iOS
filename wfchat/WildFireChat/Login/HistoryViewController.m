//
//  HistoryViewController.m
//  WildFireChat
//
//  Created by xxx on 2018/12/22.
//  Copyright © 2018 WildFireChat. All rights reserved.
//

#import "HistoryViewController.h"
#import "MoneyListController.h"
@interface HistoryViewController () {
    UIView *_view1;
    UIView *_view2;
}
@property (weak, nonatomic) IBOutlet UISegmentedControl *segement;

@end

@implementation HistoryViewController

- (IBAction)youxijifen:(id)sender {
    UISegmentedControl *control = (UISegmentedControl *)sender;
   
    if (control.selectedSegmentIndex == 0) {
        _view2.hidden = YES;
        _view1.hidden = NO;
    } else {
        _view2.hidden = NO;
        _view1.hidden = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIColor *greenColor = [UIColor blackColor];
    NSDictionary *colorAttr = [NSDictionary dictionaryWithObject:greenColor forKey:NSForegroundColorAttributeName];
    [_segement setTitleTextAttributes:colorAttr forState:UIControlStateNormal];
    MoneyListController *list1 = [MoneyListController new];
    list1.type = @"1";
    
    MoneyListController *list2 = [MoneyListController new];
    list2.type = @"2";
    [self addChildViewController:list1];
    [self addChildViewController:list2];
    
    [self.view addSubview:list1.view];
    [self.view addSubview:list2.view];
    _view1 = list1.view;
    _view2 = list2.view;
    _view2.hidden = YES;
    _view1.frame = CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height - 40);
    _view2.frame = _view1.frame;
    [self.view bringSubviewToFront:self.segement];
    // Do any additional setup after loading the view from its nib.
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
