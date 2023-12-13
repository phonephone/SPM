//
//  ChatBubbleCell.m
//  PMS
//
//  Created by Truk Karawawattana on 7/2/2564 BE.
//  Copyright © 2564 TMA Digital Company Limited. All rights reserved.
//

#import "ChatBubbleCell.h"
#import <QuartzCore/QuartzCore.h>

const CGFloat ChatBubbleCellWidthOffset = 30.0f;
const CGFloat ChatBubbleCellImageSize = 50.0f;
const CGFloat ChatBubbleCellSpace = 10.0f;


@implementation ChatBubbleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        _bubbleView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _bubbleView.userInteractionEnabled = YES;
        [self.contentView addSubview:_bubbleView];
        
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.numberOfLines = 0;
        self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.textLabel.textColor = [UIColor blackColor];
        self.textLabel.font = [UIFont systemFontOfSize:14.0];
        
        self.detailTextLabel.backgroundColor = [UIColor clearColor];
        self.detailTextLabel.numberOfLines = 1;
        self.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.detailTextLabel.textColor = [UIColor blackColor];
        self.detailTextLabel.font = [UIFont systemFontOfSize:14.0];
        
        self.imageView.userInteractionEnabled = YES;
        self.imageView.layer.cornerRadius = 5.0;
        self.imageView.layer.masksToBounds = YES;
        
        UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        [_bubbleView addGestureRecognizer:longPressRecognizer];
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [_bubbleView addGestureRecognizer:tapRecognizer];
        
        // Defaults
        //_selectedBubbleColor = ChatBubbleCellBubbleColorAqua;
        _canCopyContents = YES;
        _selectionAdjustsColor = YES;
    }
    
    return self;
}

- (void)updateFramesForAuthorType:(AuthorType)type
{
    [self setImageForBubbleColor:self.bubbleColor];
    
    CGFloat minInset = 0.0f;
    if([self.dataSource respondsToSelector:@selector(minInsetForCell:atIndexPath:)])
    {
        minInset = [self.dataSource minInsetForCell:self atIndexPath:[[self tableView] indexPathForCell:self]];
    }
    
    CGSize size;
    CGSize detailsize;
    
    if (self.bubbleColor == ChatBubbleCellBubblePic)
    {
        //CGFloat ratio = _bubbleView.image.size.height/_bubbleView.image.size.width;
        CGFloat width = self.frame.size.width*0.65;
        CGFloat height = (width/4)*3;//width*ratio;
        size = CGSizeMake(width,height);
        
        /*
         _bubbleView.layer.shadowColor = [UIColor grayColor].CGColor;
         _bubbleView.layer.shadowOffset = CGSizeMake(1, 1);
         _bubbleView.layer.shadowOpacity = 1;
         _bubbleView.layer.shadowRadius = 2.0;
         _bubbleView.clipsToBounds = NO;
         */
        _bubbleView.layer.cornerRadius = 8.0;
        _bubbleView.layer.masksToBounds = YES;
        
        //_bubbleView.layer.borderColor = [UIColor grayColor].CGColor;
        //_bubbleView.layer.borderWidth = 1;
        
        self.textLabel.hidden = YES;
    }
    else if(self.imageView.image)
    {
        size = [self.textLabel.text boundingRectWithSize:CGSizeMake(self.frame.size.width - minInset - ChatBubbleCellWidthOffset - ChatBubbleCellImageSize - 8.0f, CGFLOAT_MAX)
                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                              attributes:@{NSFontAttributeName:self.textLabel.font}
                                                 context:nil].size;
        self.textLabel.hidden = NO;
    }
    else
    {
        size = [self.textLabel.text boundingRectWithSize:CGSizeMake(self.frame.size.width - minInset - ChatBubbleCellWidthOffset, CGFLOAT_MAX)
                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                              attributes:@{NSFontAttributeName:self.textLabel.font}
                                                 context:nil].size;
        self.textLabel.hidden = NO;
    }
    
    detailsize = [self.detailTextLabel.text boundingRectWithSize:CGSizeMake(self.frame.size.width - minInset - ChatBubbleCellWidthOffset, CGFLOAT_MAX)
                                                         options:NSStringDrawingUsesLineFragmentOrigin
                                                      attributes:@{NSFontAttributeName:self.textLabel.font}
                                                         context:nil].size;
    
    // You can always play with these values if you need to
    if(type == ChatBubbleCellAuthorTypeSelf)
    {
        if(self.imageView.image)
        {
            self.bubbleView.frame = CGRectMake(self.frame.size.width - (size.width + ChatBubbleCellWidthOffset) - ChatBubbleCellImageSize - 8.0f, 1, size.width + ChatBubbleCellWidthOffset, size.height + 15.0f);
            self.imageView.frame = CGRectMake(self.frame.size.width - ChatBubbleCellImageSize - 5.0f, 0, ChatBubbleCellImageSize, ChatBubbleCellImageSize);
            self.textLabel.frame = CGRectMake(self.frame.size.width - (size.width + ChatBubbleCellWidthOffset - 16.0f) - ChatBubbleCellImageSize - 8.0f, 8.0f, size.width + ChatBubbleCellWidthOffset - 23.0f, size.height);
            
            self.detailTextLabel.frame = CGRectMake(self.frame.size.width/2, size.height + 12.0f, self.frame.size.width/2 - ChatBubbleCellImageSize - ChatBubbleCellSpace-8, detailsize.height);
        }
        else
        {
            self.bubbleView.frame = CGRectMake(self.frame.size.width-ChatBubbleCellSpace - (size.width + ChatBubbleCellWidthOffset), 1, size.width + ChatBubbleCellWidthOffset, size.height + 15.0f);
            self.imageView.frame = CGRectZero;
            self.textLabel.frame = CGRectMake(self.frame.size.width-ChatBubbleCellSpace - (size.width + ChatBubbleCellWidthOffset - 16.0f), 8.0f, size.width + ChatBubbleCellWidthOffset - 23.0f, size.height);
            
            self.detailTextLabel.frame = CGRectMake(self.frame.size.width/2, size.height + 12.0f, self.frame.size.width/2 - ChatBubbleCellSpace-8, detailsize.height);
        }
        
        self.textLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        self.detailTextLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        self.detailTextLabel.textAlignment = NSTextAlignmentRight;
        self.bubbleView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        self.bubbleView.transform = CGAffineTransformIdentity;
    }
    else
    {
        if(self.imageView.image)
        {
            self.bubbleView.frame = CGRectMake(ChatBubbleCellImageSize + 8.0f, 1, size.width + ChatBubbleCellWidthOffset, size.height + 15.0f);
            self.imageView.frame = CGRectMake(5.0, 0, ChatBubbleCellImageSize, ChatBubbleCellImageSize);
            self.textLabel.frame = CGRectMake(ChatBubbleCellImageSize + 8.0f + 16.0f, 6.0f, size.width + ChatBubbleCellWidthOffset - 23.0f, size.height);
            
            self.detailTextLabel.frame = CGRectMake(ChatBubbleCellImageSize+ChatBubbleCellSpace+8, size.height + 12.0f, size.width + ChatBubbleCellWidthOffset - 23.0f, detailsize.height);
        }
        else
        {
            self.bubbleView.frame = CGRectMake(ChatBubbleCellSpace, 1, size.width + ChatBubbleCellWidthOffset, size.height + 15.0f);
            self.imageView.frame = CGRectZero;
            self.textLabel.frame = CGRectMake(16.0f+ChatBubbleCellSpace, 6.0f, size.width + ChatBubbleCellWidthOffset - 23.0f, size.height);
            
            self.detailTextLabel.frame = CGRectMake(ChatBubbleCellSpace+8, size.height + 12.0f, self.frame.size.width/2 - ChatBubbleCellSpace, detailsize.height);
        }
        
        self.textLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        self.detailTextLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        self.detailTextLabel.textAlignment = NSTextAlignmentLeft;
        self.bubbleView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        self.bubbleView.transform = CGAffineTransformIdentity;
        if (self.bubbleColor != ChatBubbleCellBubblePic)
        {
            self.bubbleView.transform = CGAffineTransformMakeScale(-1.0f, 1.0f);
        }
    }
}

- (void)setImageForBubbleColor:(BubbleColor)color
{
    switch (color) {
        case 0:
            self.bubbleView.image = [[UIImage imageNamed:@"chat_self"] resizableImageWithCapInsets:UIEdgeInsetsMake(12.0f, 15.0f, 16.0f, 18.0f)];
            break;
            
        case 1:
            self.bubbleView.image = [[UIImage imageNamed:@"chat_recieve"] resizableImageWithCapInsets:UIEdgeInsetsMake(12.0f, 15.0f, 16.0f, 18.0f)];
            break;
            
        case 2://รูปภาพ
            break;
    }
    
    //self.bubbleView.image = [[UIImage imageNamed:[NSString stringWithFormat:@"Bubble-%lu.png", (long)color]] resizableImageWithCapInsets:UIEdgeInsetsMake(12.0f, 15.0f, 16.0f, 18.0f)];
    
}

- (void)layoutSubviews
{
    [self updateFramesForAuthorType:self.authorType];
}

- (UITableView *)tableView
{
    UIView *tableView = self.superview;
    
    while(tableView)
    {
        if([tableView isKindOfClass:[UITableView class]])
        {
            return (UITableView *)tableView;
        }
        
        tableView = tableView.superview;
    }
    
    return nil;
}

#pragma mark - Setters

- (void)setAuthorType:(AuthorType)type
{
    _authorType = type;
    [self updateFramesForAuthorType:_authorType];
}

- (void)setBubbleColor:(BubbleColor)color
{
    _bubbleColor = color;
    [self setImageForBubbleColor:_bubbleColor];
}

#pragma mark - UIGestureRecognizer methods

- (void)longPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        if(self.canCopyContents && self.bubbleColor != ChatBubbleCellBubblePic)
        {
            UIMenuController *menuController = [UIMenuController sharedMenuController];
            [self becomeFirstResponder];
            [menuController setTargetRect:self.bubbleView.frame inView:self];
            [menuController setMenuVisible:YES animated:YES];
            
            if(self.selectionAdjustsColor)
            {
                //[self setImageForBubbleColor:self.selectedBubbleColor];
            }
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willHideMenuController:) name:UIMenuControllerWillHideMenuNotification object:nil];
        }
    }
}

- (void)tap:(UITapGestureRecognizer *)gestureRecognizer
{
    if([self.delegate respondsToSelector:@selector(tappedImageOfCell:atIndexPath:)] && self.bubbleColor == ChatBubbleCellBubblePic)
    {
        [self.delegate tappedImageOfCell:self atIndexPath:[[self tableView] indexPathForCell:self]];
    }
}

#pragma mark - UIMenuController methods

- (BOOL)canPerformAction:(SEL)selector withSender:(id)sender
{
    if(selector == @selector(copy:))
    {
        return YES;
    }
    
    return NO;
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)copy:(id)sender
{
    [[UIPasteboard generalPasteboard] setString:self.textLabel.text];
}

- (void)willHideMenuController:(NSNotification *)notification
{
    [self setImageForBubbleColor:self.bubbleColor];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIMenuControllerWillHideMenuNotification object:nil];
}

@end
