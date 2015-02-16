#import <UIKit/UIKit.h>

@interface RQAnimationsMaterializeLabel : UILabel

@property (nonatomic) CGFloat animationDuration;

- (void)hideText;
- (void)showTextWithAnimation:(BOOL)animated;

@end
