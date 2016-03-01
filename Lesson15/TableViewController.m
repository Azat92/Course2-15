//
//  TableViewController.m
//  Lesson15
//
//  Created by Мария Тимофеева on 13.02.16.
//  Copyright © 2016 Azat Almeev. All rights reserved.
//

#import "TableViewController.h"
#import "NetManager.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface TableViewController ()

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _data = [[NSMutableArray alloc] init];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)loadDataDidClick:(id)sender {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.label.text = @"Loading some data";
    [[NetManager sharedInstance] loadSomeDataProgress:^(NSInteger progress) {
        [self addObject:[NSString stringWithFormat:@"Data #%lu", (unsigned long)[_data count]+1]];
        hud.progress = progress / 100.;
        
    } completion:^(NSError *error) {
        hud.progress = 1;
        hud.label.text = @"Completed successfully";
        [hud hideAnimated:YES afterDelay:1];
    }];
    
    
}

//
- (IBAction)signOutButtonDidClick:(UIBarButtonItem *)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Sign out" message:@"Are you sure?" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[NetManager sharedInstance]  signOutCompletion:^(NSError *error) {
            if (error) {
                hud.mode = MBProgressHUDModeText;
                hud.label.text = error.localizedDescription;
                
                [hud hideAnimated:YES afterDelay:1];
            }
            else {
                [hud hideAnimated:YES];
                [self performSegueWithIdentifier:@"SignOutSegue" sender:self];
            }
        }];

        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil]];
    
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
   cell.textLabel.text = _data[indexPath.row];
    
    return cell;

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_data count];
    
}

-(void)addObject:(NSString *)object{
    
    [_data addObject:object];
    [self.tableView reloadData];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CFTimeInterval startTime = CACurrentMediaTime();
   
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = [NSString stringWithFormat: @"Load data for row %ld", (long)indexPath.row + 1];
    [[NetManager sharedInstance] getDataWithNumber:indexPath.row  completion:^(NSError *error) {
        
        if (error) {
            hud.mode = MBProgressHUDModeText;
            hud.label.text =@"Error";
            
        }
        else {
            CFTimeInterval elapsedTime = CACurrentMediaTime() - startTime;
            NSString *date = [NSString stringWithFormat:@"%f", elapsedTime];
            hud.mode = MBProgressHUDModeText;
            hud.label.numberOfLines = 2;
            hud.label.text =[NSString stringWithFormat: @"Load data for row %ld \n load time: %@ sec", (long)indexPath.row + 1, date];
          
        }
        [hud hideAnimated:YES afterDelay:2];
    }];

   
}
@end
