//
//  FriutTableViewCell.h
//  FruitList
//
//  Created by Эдуард Рязапов on 27.02.16.
//  Copyright © 2016 Эдуард Рязапов. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriutTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *fruitImage;
@property (weak, nonatomic) IBOutlet UILabel *fruitNameLabel;

@end
