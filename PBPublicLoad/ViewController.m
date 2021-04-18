//
//  ViewController.m
//  PBPublicLoad
//
//  Created by wentao lu on 2021/4/18.
//

#import "ViewController.h"
//#import "ViewController+Load.h"
#import <objc/runtime.h>

@interface ViewController ()
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSNumber *age;
@end

@implementation ViewController

+ (void)load {
    NSLog(@"%s", __FUNCTION__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //1. 手动调用
    [ViewController load];
    
    self.name = @"lwt";
//    self.age = @(18);
    
    //2. 方法交换
    [self.class swizzleInstanceMethod:self.class original:@selector(name) swizzled:@selector(swizzle_name)];
    
    NSLog(@"%@", [self swizzle_name]);
}

- (NSString *)swizzle_name {
    return [self swizzle_name];
}

+ (void)swizzleInstanceMethod:(Class)target original:(SEL)originalSelector swizzled:(SEL)swizzledSelector {
    Method originalMethod = class_getInstanceMethod(target, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(target, swizzledSelector);
    
    if (originalSelector && swizzledSelector) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            if (class_addMethod(target, swizzledSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))) {
                method_exchangeImplementations(originalMethod, swizzledMethod);
            } else {
                method_exchangeImplementations(originalMethod, swizzledMethod);
            }
        });
    } else {
        @throw @"交换方法不存在";
    }
    
}


@end
