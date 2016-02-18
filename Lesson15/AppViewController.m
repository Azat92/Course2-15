//
//  AppViewController.m
//  Lesson15
//
//  Created by Azat Almeev on 06.02.16.
//  Copyright © 2016 Azat Almeev. All rights reserved.
//

#import "AppViewController.h"
#import "NetManager.h"
#import "MBProgressHUD/MBProgressHUD.h"
#import "LoginViewController.h"

@interface AppViewController ()
@property NSMutableArray *arrayForDownloadData;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *logOutButton;

@end

@implementation AppViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.arrayForDownloadData = [NSMutableArray new];
    // Do any additional setup after loading the view.
}
- (IBAction)logoutDidClick:(id)sender  {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Are you shure?" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionYes = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[NetManager sharedInstance] signOut:^(NSError *error) {
            [hud hideAnimated:YES];
            [self performSegueWithIdentifier:@"logOutSegue" sender:nil];
        }];
    }];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:actionYes];
    [alert addAction:actionCancel];
    [self presentViewController:alert animated:YES completion:nil];
}


- (IBAction)loadDataDidClick:(id)sender {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.label.text = @"Loading some data";
    [[NetManager sharedInstance] loadSomeDataProgress:^(NSInteger progress) {
        hud.progress = progress / 100.;
        NSString *newValue = [NSString stringWithFormat:@"Data #"];
        newValue = [newValue stringByAppendingString:[NSString stringWithFormat:@"%ld", progress/10]];
        [self.arrayForDownloadData addObject:newValue];
        [self.tableView reloadData];

    } completion:^(NSError *error) {
        hud.progress = 1;
        hud.label.text = @"Completed successfully";
        [hud hideAnimated:YES afterDelay:1];

        
    }];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayForDownloadData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DataCell" forIndexPath:indexPath];
    cell.textLabel.text = [self.arrayForDownloadData objectAtIndex:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *nameOfSelectedRow = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    NSString *stringForHubLoadData = @"Load data for row ";
    stringForHubLoadData = [stringForHubLoadData stringByAppendingString:nameOfSelectedRow];
    NSString *stringForHubLoadedData = @"Data was load for row ";
    stringForHubLoadedData = [stringForHubLoadedData stringByAppendingString:nameOfSelectedRow];
    __block double timeDellay;
    [[NetManager sharedInstance] loadSomeDataForRow:indexPath.row delay:^(double dellay) {
        hud.label.text = stringForHubLoadData;
        timeDellay = dellay;
        
    } completion:^(NSError *error) {
        hud.mode = MBProgressHUDModeText;
        NSString *stringOfDellay = @"Dellay, ";
        stringOfDellay = [stringOfDellay stringByAppendingString:[NSString stringWithFormat:@"%f", timeDellay]];
        hud.label.text = stringForHubLoadedData;
        hud.detailsLabel.text = stringOfDellay;
        [hud hideAnimated:YES afterDelay:3];
    }];
}

@end
