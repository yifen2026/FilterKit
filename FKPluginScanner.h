#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface FKPluginScanner : NSObject
+ (NSArray<NSDictionary<NSString *, id> *> *)scan;
@end
NS_ASSUME_NONNULL_END
