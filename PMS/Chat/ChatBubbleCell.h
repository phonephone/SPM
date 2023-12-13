//
//  ChatBubbleCell.h
//  PMS
//
//  Created by Truk Karawawattana on 7/2/2564 BE.
//  Copyright © 2564 TMA Digital Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChatBubbleCellDataSource, ChatBubbleCellDelegate;

extern const CGFloat ChatBubbleCellWidthOffset; // Extra width added to bubble
extern const CGFloat ChatBubbleCellImageSize; // The size of the image

typedef NS_ENUM(NSUInteger, AuthorType) {
    ChatBubbleCellAuthorTypeSelf = 0,
    ChatBubbleCellAuthorTypeOther = 1
};

typedef NS_ENUM(NSUInteger, BubbleColor) {
    ChatBubbleCellBubbleSelf = 0,
    ChatBubbleCellBubbleRecieve = 1,
    ChatBubbleCellBubblePic = 2
};

@interface ChatBubbleCell : UITableViewCell

@property (nonatomic, strong, readonly) UIImageView *bubbleView;
@property (nonatomic, assign) AuthorType authorType;
@property (nonatomic, assign) BubbleColor bubbleColor;
@property (nonatomic, assign) BubbleColor selectedBubbleColor;
@property (nonatomic, assign) BOOL canCopyContents; // Defaults to YES
@property (nonatomic, assign) BOOL selectionAdjustsColor; // Defaults to YES
@property (nonatomic, weak) id <ChatBubbleCellDataSource> dataSource;
@property (nonatomic, weak) id <ChatBubbleCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIView *dateBg;

@end

@protocol ChatBubbleCellDataSource <NSObject>
@optional
- (CGFloat)minInsetForCell:(ChatBubbleCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@protocol ChatBubbleCellDelegate <NSObject>
@optional
- (void)tappedImageOfCell:(ChatBubbleCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end
