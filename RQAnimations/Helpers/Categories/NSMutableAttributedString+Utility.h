#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (Utility)

- (void)modifyEachCharacterAttribute:(void(^)(NSUInteger characterIndex, NSMutableDictionary *mutableAttributes))block;

@end
