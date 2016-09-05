//
//  SNAlbumCell.m
//  SNIconPickerDemo
//
//  Created by Spectator on 16/9/5.
//  Copyright © 2016年 Spectator. All rights reserved.
//

#import "SNAlbumCell.h"

@implementation SNAlbumCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
    }
    
    return self;
}

@end
