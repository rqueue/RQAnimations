#import <UIKit/UIKit.h>

typedef void(^AnimationBlock)(NSMutableAttributedString *mutableAttributedText, BOOL show, CGFloat timeElapsed);

@interface RQAnimationLabel : UILabel

/**
 Animation duration in seconds.
 */
@property (nonatomic) CGFloat animationDuration;

/**
 Hides the text.
 
 @param animated Boolean to indicate whether hiding the text should be animated.
 @param completion The completion block to run after the text has been hidden.
*/
- (void)hideTextWithAnimation:(BOOL)animated completion:(void(^)())completion;

/**
 Shows the text.

 @param animated Boolean to indicate whether showing the text should be animated.
 @param completion The completion block to run after the text has been shown.
 */
- (void)showTextWithAnimation:(BOOL)animated completion:(void(^)())completion;

/**
 Set the animation that will be used during the show and hide animations.

 @param preAnimationBlock The block that will be run before any show or hide animations run. It should be used to perform any set up of values that may need to be accessed by the animation block. The attributed string of the text that will be shown/hidden is provided.
        Note: This block will be retained. The caller of this method should be concious of potential retain cycles.
 @param animationBlock The block that is called during each frame update. The `mutableAttributedText` will be used to set the contents of the labels `attributedText` after the animation block finishes running. The `show` boolean inidicates if the text is animating to be shown or hidden. The `timeElapsed`value is a number between 0.0 and 1.0, which indicates the progress of the animation.
 */
- (void)setPreAnimationBlock:(void(^)(NSAttributedString *))preAnimationBlock animationBlock:(AnimationBlock)animationBlock;

@end
