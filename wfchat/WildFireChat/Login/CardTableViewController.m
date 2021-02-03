//
//  CardTableViewController.m
//  WildFireChat
//
//  Created by xxx on 2018/12/12.
//  Copyright © 2018 WildFireChat. All rights reserved.
//

#import "CardTableViewController.h"
#import "BindCardViewController.h"
#import "CardModel.h"
#import "ImageTableViewCell.h"
#import "MBProgressHUD.h"
#import "CardTableViewCell.h"
#import "ModelSingleLeton.h"

@interface CardTableViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    NSData *_data;
}
@property (nonatomic, strong) NSMutableArray <CardModel*>*list;
@property (nonatomic, strong) NSIndexPath *selectedIndex;

@end

@implementation CardTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.list = [NSMutableArray arrayWithCapacity:1];
    [self.tableView registerClass:[CardTableViewCell class] forCellReuseIdentifier:@"reuseIdentifier"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CardTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CardTableViewCell"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.bind) {
        [self loadData];
    }else {
        [self.list removeAllObjects];
//        CardModel *model = [CardModel new];
//        model.name = [NSString stringWithFormat:@"%@", staticCarModel.name];
//        model.bank = [NSString stringWithFormat:@"%@", staticCarModel.bank];;
//        model.number = [NSString stringWithFormat:@"%@", staticCarModel.number];;
        if (![ModelSingleLeton share].cModel.isEmptys && [ModelSingleLeton share].cModel) {
            [self.list addObject:[ModelSingleLeton share].cModel];
        }
        [self.tableView reloadData];
    }
}

- (void)sure {
    
    if (self.bind) {
        BindCardViewController *vc = [BindCardViewController new];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    if (!self.selectedIndex) {
        [MBProgressHUD showHUDText:@"Select card" addedTo:self.view];
        return;
    }
    CardModel *model = self.list[_selectedIndex.row];
    if (self.block) {
        self.block(model.number);
    }
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)loadData {
    [[NetworkAPI sharedInstance] v2GetWithUrl:APP_getChargeBankCards params:nil successComplection:^(NSDictionary * _Nonnull done) {
        self.list = [CardModel mj_objectArrayWithKeyValuesArray:done[@"data"]];
        [self.tableView reloadData];
    } failureComplection:^(NSDictionary * _Nonnull done) {
        
    }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return 160;
    }
    return 116;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 90)];
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(45, 15, self.view.frame.size.width - 90, 50)];
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 25;
        btn.backgroundColor = Tools.getThemeColor;
        [btn setTitle:LocalizedString(@"Ok") forState:UIControlStateNormal];
        if(self.bind) {
            [btn setTitle:LocalizedString(@"ReBindCard") forState:UIControlStateNormal];
        }
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(sure) forControlEvents:UIControlEventTouchUpInside];
        [v addSubview:btn];
        return v;
    }
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 90;
    }
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return 1;
    }
    return _list.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.bind) {
        return;
    }
    UITableViewCell *tCell = [tableView cellForRowAtIndexPath:indexPath];
    CardModel *cmodel = self.list[indexPath.row];
    if (self.selectedIndex != indexPath) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:self.selectedIndex];
        cell.accessoryType = UITableViewCellAccessoryNone;
        if (self.selectedIndex.row < self.list.count) {
            self.list[_selectedIndex.row].selected = NO;
        }
        tCell.accessoryType = UITableViewCellAccessoryCheckmark;
        cmodel.selected = YES;
        self.selectedIndex = indexPath;
    } else {
        cmodel.selected = NO;
        tCell.accessoryType = UITableViewCellAccessoryNone;
        self.selectedIndex = nil;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CardTableViewCell" forIndexPath:indexPath];
    CardModel *cmodel = self.list[indexPath.row];
    cell.numberLabel.text = cmodel.number;
    cell.namelabel.text = cmodel.name;
    cell.bankName.text = cmodel.bank;
    if (cmodel.isSelected) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}





/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end


