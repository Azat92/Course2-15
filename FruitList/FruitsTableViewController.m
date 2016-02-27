//
//  FruitsTableViewController.m
//  FruitList
//
//  Created by Эдуард Рязапов on 27.02.16.
//  Copyright © 2016 Эдуард Рязапов. All rights reserved.
//

#import "FruitsTableViewController.h"
#import "FruitViewController.h"
#import "FriutTableViewCell.h"
#import "Fruit.h"
#import "MBProgressHUD.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface FruitsTableViewController ()

@property NSMutableArray<Fruit *> *fruits;
@property NSInteger selectFruitNumber;
@property NSURL *url;

@end

@implementation FruitsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fruits = [NSMutableArray new];
    self.url = [NSURL URLWithString:@"https://dl.dropboxusercontent.com/u/55523423/Fructs.json"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.fruits.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FriutTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fruitCellIdentify" forIndexPath:indexPath];
    cell.fruitNameLabel.text = self.fruits[indexPath.row].fruitName;
    [cell.fruitImage sd_setImageWithURL:self.fruits[indexPath.row].thumb];
    return cell;
}

- (IBAction)loadFruits:(id)sender {
    __block NSMutableArray *fruits = [NSMutableArray new];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading";
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error;
        NSData *jsonData = [[NSData alloc] initWithContentsOfURL:self.url];
        NSMutableArray *allElements = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        
        for (NSDictionary *d in allElements) {
            Fruit *fruit = [Fruit new];
            fruit.fruitName = d[@"title"];
            fruit.thumb = [NSURL URLWithString:d[@"thumb"]];
            fruit.img = [NSURL URLWithString:d[@"img"]];
            [fruits addObject:fruit];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hide:YES];
            self.fruits = nil;
            self.fruits = fruits;
            fruits = nil;
            [self.tableView reloadData];
        });
    });
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    FruitViewController *fruitController = (FruitViewController *)segue.destinationViewController;
    fruitController.fruit = self.fruits[self.selectFruitNumber];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectFruitNumber = indexPath.row;
    return indexPath;
}

@end
