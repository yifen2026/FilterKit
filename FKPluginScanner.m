#import "FKPluginScanner.h"
#import "FKEnvironment.h"

@implementation FKPluginScanner
+ (NSArray<NSDictionary<NSString *,id> *> *)scan {
    NSDictionary *environment = [FKEnvironment snapshot];
    NSString *jbroot = environment[@"jbroot_path"];
    if (![jbroot isKindOfClass:NSString.class] || jbroot.length == 0) return @[];

    NSArray<NSString *> *relativeDirectories = @[
        @"Library/MobileSubstrate/DynamicLibraries",
        @"usr/lib/TweakInject"
    ];
    NSMutableDictionary<NSString *, NSDictionary *> *plugins = [NSMutableDictionary dictionary];
    NSFileManager *manager = NSFileManager.defaultManager;

    for (NSString *relative in relativeDirectories) {
        NSString *directory = [jbroot stringByAppendingPathComponent:relative];
        BOOL isDirectory = NO;
        if (![manager fileExistsAtPath:directory isDirectory:&isDirectory] || !isDirectory) continue;
        NSArray<NSString *> *files = [manager contentsOfDirectoryAtPath:directory error:nil];
        for (NSString *file in files) {
            if (![file.pathExtension.lowercaseString isEqualToString:@"dylib"]) continue;
            NSString *name = file.stringByDeletingPathExtension;
            NSString *dylibPath = [directory stringByAppendingPathComponent:file];
            NSString *plistPath = [[directory stringByAppendingPathComponent:name] stringByAppendingPathExtension:@"plist"];
            NSDictionary *filter = nil;
            NSData *plistData = [NSData dataWithContentsOfFile:plistPath];
            if (plistData) {
                id value = [NSPropertyListSerialization propertyListWithData:plistData options:NSPropertyListImmutable format:nil error:nil];
                if ([value isKindOfClass:NSDictionary.class]) filter = value;
            }
            NSMutableDictionary *entry = [@{
                @"name": name,
                @"dylib_path": dylibPath,
                @"plist_path": plistPath,
                @"plist_exists": @([manager fileExistsAtPath:plistPath]),
                @"filter": filter ?: NSNull.null,
                @"source_directory": directory
            } mutableCopy];
            plugins[name] = entry;
        }
    }
    return [[plugins allValues] sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *a, NSDictionary *b) {
        return [a[@"name"] localizedCaseInsensitiveCompare:b[@"name"]];
    }];
}
@end
