//
//  TXViewController.m
//  WildFireChat
//
//  Created by xxx on 2018/12/13.
//  Copyright © 2018 WildFireChat. All rights reserved.
//

#import "TXViewController.h"
#import "CardTableViewController.h"
#import "MBProgressHUD.h"
#import "BindCardViewController.h"
#import <WFChatClient/WFCChatClient.h>

@interface TXViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    NSData *_data;
    UIImage *_pic;
}
@property (weak, nonatomic) IBOutlet UITextField *field;
@property (weak, nonatomic) IBOutlet UILabel *cardLeft;
@property (weak, nonatomic) IBOutlet UIImageView *verfyImage;
@property (weak, nonatomic) IBOutlet UILabel *cardNumber;
@property (weak, nonatomic) IBOutlet UIButton *selectCard;
@property (weak, nonatomic) IBOutlet UIButton *addImage;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (weak, nonatomic) IBOutlet UILabel *selectImageHint;
@property (weak, nonatomic) IBOutlet UIButton *online;

@property (nonatomic, strong) NSString *num;

@end

@implementation TXViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAllLabel];
}

- (void)setAllLabel {
    self.field.placeholder = LocalizedString(@"InputMoney");
    self.cardLeft.text = LocalizedString(@"Card Num");
    self.selectImageHint.text = LocalizedString(@"SelectImage");
    [self.selectCard setTitle:LocalizedString(@"SelectCard") forState:UIControlStateNormal];
    [self.sureButton setTitle:LocalizedString(@"Submit") forState:UIControlStateNormal];
    [self.online setTitle:LocalizedString(@"online") forState:UIControlStateNormal];
}

- (IBAction)imageCLick:(id)sender {
    UIImagePickerController *picker = [UIImagePickerController new];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    picker.allowsEditing = false;
    [self presentViewController:picker animated:true completion:nil];
}

- (IBAction)sure:(id)sender {
    [self.view endEditing:YES];
    if (_field.text.length <=0 ) {
        [MBProgressHUD showHUDText:@"input num" addedTo:self.view];
        return;
    }
    
    if (!_pic) {
        [MBProgressHUD showHUDText:@"select Image" addedTo:self.view];
        return;
    }
    
    if (!_num) {
        [MBProgressHUD showHUDText:@"select card" addedTo:self.view];
        return;
    }
    
    NSString *sn = [WFCCNetworkService sharedInstance].userId;
    WFCCImageMessageContent *imgContent = [WFCCImageMessageContent contentFrom:_pic];
    WFCCConversation *conversation = [[WFCCConversation alloc] init];
    conversation.type = Single_Type;
    conversation.target = sn;
    conversation.line = 0;
    [ToastManager showToast:@"" inView:self.view];
    [[WFCCIMService sharedWFCIMService] sendMedia:conversation content:imgContent success:^(long long messageUid, long long timestamp) {
        WFCCImageMessageContent *content = [[WFCCIMService sharedWFCIMService] getMessageByUid:messageUid].content;
        [self postCZ:content.remoteUrl];
    } progress:nil error:nil];
}

- (void)postCZ:(NSString *)url {
    NSString *sn = [WFCCNetworkService sharedInstance].userId;
    NSDictionary *param = @{@"userId":sn,@"bank":_num, @"amount": _field.text, @"shortcut": url};
    [[NetworkAPI sharedInstance] v2GetWithUrl:APP_charge params:param successComplection:^(NSDictionary * _Nonnull done) {
        [MBProgressHUD showHUDText:@"success" addedTo:self.view];
        [self.navigationController popViewControllerAnimated:YES];
    } failureComplection:^(NSDictionary * _Nonnull done) {
        [MBProgressHUD showHUDText:done[@"msg"] addedTo:self.view];
    }];
}
- (IBAction)online:(id)sender {
    NSString *uid = [[WFCCNetworkService sharedInstance] userId];
    NSString *url = [NSString stringWithFormat:@"http://labi168.com/pay.php?uid=%@",uid];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

- (IBAction)selectedCard:(id)sender {
    CardTableViewController *vc = [CardTableViewController new];
    __weak typeof(self) weakSelf = self;
    vc.block = ^(NSString *card) {
        weakSelf.selectCard.hidden = YES;
        weakSelf.cardNumber.text = card;
        weakSelf.num = card;
    };
    [self.navigationController pushViewController:vc animated:true];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
  [UIApplication sharedApplication].statusBarHidden = NO;
  NSData *data = nil;
  NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];

  if ([mediaType isEqual:@"public.image"]) {
      UIImage *originImage =
      [info objectForKey:UIImagePickerControllerOriginalImage];
      _pic = originImage;
      //获取截取区域的图像
      data = UIImageJPEGRepresentation(originImage, 0.00001);
//      self.verfyImage.image = originImage;
      [_addImage setBackgroundImage:originImage forState:UIControlStateNormal];
  }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
