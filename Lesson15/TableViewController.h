//
//  TableViewController.h
//  Lesson15
//
//  Created by Мария Тимофеева on 13.02.16.
//  Copyright © 2016 Azat Almeev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewController : UITableViewController
@property (strong, atomic) NSMutableArray<NSString *> *data;
-(void)addObject:(NSString *)object;
- (void)prepareForSender:(id)sender;
@end
