//
//  ViewController.m
//  Lesson15
//
//  Created by Azat Almeev on 06.02.16.
//  Copyright © 2016 Azat Almeev. All rights reserved.
//

#import "LoginViewController.h"
#import "NetManager.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface LoginViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *loginTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalOffsetConstraint;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self) self_ = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillShowNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        CGFloat height = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
        [UIView animateWithDuration:0.3 animations:^{
            self_.verticalOffsetConstraint.constant = -height / 2;
            [self_.view layoutIfNeeded];
        }];
    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillHideNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        [UIView animateWithDuration:0.3 animations:^{
            self_.verticalOffsetConstraint.constant = 0;
            [self_.view layoutIfNeeded];
        }];
    }];
}

- (IBAction)logoutSegue:(UIStoryboardSegue *)sender {
    
}

- (IBAction)signInButtonDidClick:(UIButton *)sender {
    [self.loginTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[NetManager sharedInstance] signInUsingLogin:self.loginTextField.text andPassword:self.passwordTextField.text completion:^(NSError *error) {
        if (error) {
            hud.mode = MBProgressHUDModeText;
            hud.label.text = error.localizedDescription;
//            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
//            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
//            [self presentViewController:alert animated:YES completion:nil];
            [hud hideAnimated:YES afterDelay:1];
        }
        else {
            [hud hideAnimated:YES];
            self.loginTextField.text = nil;
            self.passwordTextField.text = nil;
            [self performSegueWithIdentifier:@"SignInSegue" sender:self];
        }
    }];
}

#pragma mark - Text Field Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.loginTextField)
        [self.passwordTextField becomeFirstResponder];
    else
        [textField resignFirstResponder];
    return YES;
}

@end
