//
//  AppViewController.m
//  Lesson15
//
//  Created by Azat Almeev on 06.02.16.
//  Copyright © 2016 Azat Almeev. All rights reserved.
//

#import "AppViewController.h"
#import "NetManager.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface AppViewController ()

@end

@implementation AppViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)loadDataDidClick:(id)sender {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.label.text = @"Loading some data";
    [[NetManager sharedInstance] loadSomeDataProgress:^(NSInteger progress) {
        hud.progress = progress / 100.;
    } completion:^(NSError *error) {
        hud.progress = 1;
        hud.label.text = @"Completed successfully";
        [hud hideAnimated:YES afterDelay:1];
    }];
}

@end
