//
//  OffersUITableViewCell.h
//  Pets
//
//  Created by Gosho Goshev on 11/5/14.
//  Copyright (c) 2014 Gosho Goshev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OffersUITableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice;

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
