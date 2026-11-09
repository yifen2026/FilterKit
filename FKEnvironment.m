#import "FKEnvironment.h"
#import <sys/utsname.h>
#import <sys/types.h>
#import <unistd.h>

@implementation FKEnvironment
+ (NSDictionary<NSString *,id> *)snapshot {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *executable = NSBundle.mainBundle.executablePath ?: @"";
    NSRange marker = [executable rangeOfString:@"/.jbroot-"];
    NSString *jbroot = @"";
    if (marker.location != NSNotFound) {
        NSUInteger start = marker.location + 1;
        NSRange end = [executable rangeOfString:@"/" options:0 range:NSMakeRange(start + 1, executable.length - start - 1)];
        if (end.location != NSNotFound) jbroot = [executable substringToIndex:end.location];
    }
    NSString *jailbreakType = jbroot.length ? @"roothide_rootless" : @"unknown";
    return @{
        @"app_version": NSBundle.mainBundle.infoDictionary[@"CFBundleShortVersionString"] ?: @"0.0.1",
        @"ios_version": UIDevice.currentDevice.systemVersion ?: @"unknown",
        @"device_model": [NSString stringWithUTF8String:systemInfo.machine] ?: @"unknown",
        @"cpu_arch": @"runtime_detected_by_build",
        @"jailbreak_type": jailbreakType,
        @"jbroot_path": jbroot,
        @"executable_path": executable,
        @"uid": @(getuid()), @"euid": @(geteuid()),
        @"gid": @(getgid()), @"egid": @(getegid()),
        @"detection_note": jbroot.length ? @"从当前可执行文件路径发现 .jbroot；尚未调用 RootHide API。" : @"未取得足够证据，环境标记为 unknown。"
    };
}
@end
