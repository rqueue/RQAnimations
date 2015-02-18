#import <UIKit/UIKit.h>

@interface RQMaterializeLabel : UILabel

/*
 Animation duration in seconds.
*/
@property (nonatomic) CGFloat animationDuration;

/*
 This should be a number between 0.0 and 1.0, which represents the
 percentage of the animationDuration the maximum delay for a single
 character can be before it fades in.
*/
@property (nonatomic) CGFloat maxDelay;

- (void)hideText;
- (void)showTextWithAnimation:(BOOL)animated;

@end
