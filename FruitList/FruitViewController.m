//
//  FruitViewController.m
//  FruitList
//
//  Created by Эдуард Рязапов on 27.02.16.
//  Copyright © 2016 Эдуард Рязапов. All rights reserved.
//

#import "FruitViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface FruitViewController ()

@property (weak, nonatomic) IBOutlet UINavigationItem *fruitNavigationItem;
@property (weak, nonatomic) IBOutlet UIImageView *fruitImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation FruitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fruitNavigationItem.title = self.fruit.fruitName;
    [self.fruitImageView sd_setImageWithURL: self.fruit.img completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [self.activityIndicator stopAnimating];
    }];
}

@end
