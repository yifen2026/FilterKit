#import "FKMainViewController.h"
#import "FKEnvironment.h"
#import "FKPluginScanner.h"

@interface FKMainViewController ()
@property (nonatomic, strong) UITextView *textView;
@end
@implementation FKMainViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"FilterKit";
    self.view.backgroundColor = UIColor.systemBackgroundColor;
    self.textView = [[UITextView alloc] initWithFrame:self.view.bounds];
    self.textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.textView.editable = NO;
    self.textView.font = [UIFont monospacedSystemFontOfSize:12 weight:UIFontWeightRegular];
    [self.view addSubview:self.textView];
    [self refresh];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"刷新" style:UIBarButtonItemStylePlain target:self action:@selector(refresh)];
}
- (void)refresh {
    NSDictionary *environment = [FKEnvironment snapshot];
    NSArray *plugins = [FKPluginScanner scan];
    NSDictionary *result = @{@"environment": environment, @"plugins": plugins, @"mode": @"read_only", @"version": @"0.0.1"};
    NSData *data = [NSJSONSerialization dataWithJSONObject:result options:NSJSONWritingPrettyPrinted | NSJSONWritingSortedKeys error:nil];
    self.textView.text = data ? [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] : @"读取失败";
}
@end
