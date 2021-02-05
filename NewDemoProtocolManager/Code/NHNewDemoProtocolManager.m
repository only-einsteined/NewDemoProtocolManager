//
//  NHNewDemoProtocolManager.m
//  NewDemoProtocolManager
//
//  Created by only-einsteined on 12/28/2020.
//  Copyright (c) 2020 only-einsteined. All rights reserved..
//


#import "NHNewDemoProtocolManager.h"
#import <objc/runtime.h>

@interface NHNewDemoProtocolManager ()

@property (strong, nonatomic) NSMutableDictionary <NSString *, NSDictionary<NSString *, id> *> *dictClass;
@property (strong, nonatomic) NSRecursiveLock *lock;
@property (strong, nonatomic) NSMutableDictionary <NSString *, NSDictionary<NSString *, id> *> *dictInstance;

@end

@implementation NHNewDemoProtocolManager

+ (NHNewDemoProtocolManager *)sharedInstance; {
    static dispatch_once_t onceToken;
    static NHNewDemoProtocolManager *sharedManager = nil;
    dispatch_once(&onceToken, ^{
        sharedManager = [[NHNewDemoProtocolManager alloc] init];
        sharedManager.dictClass = [NSMutableDictionary dictionary];
        sharedManager.lock = [[NSRecursiveLock alloc] init];
        sharedManager.dictInstance = [NSMutableDictionary dictionary];
    });
    return sharedManager;
}

+ (id)objectWithProtocol:(Protocol *)protocol instance:(BOOL)instance; {
    if (protocol == nil) {
        return nil;
    }
    NSMutableDictionary *dictTarget = instance ? self.sharedInstance.dictInstance : self.sharedInstance.dictClass;
    [self.sharedInstance.lock lock];
    NSString *key = NSStringFromProtocol(protocol);
    NSDictionary *dict = dictTarget[key];
    id object = dict[@"object"];
    if (object == nil) {
        if (instance) {
            object = [[self.sharedInstance.dictClass[key][@"object"] alloc] init];
        } else {
            object = [self.sharedInstance.dictInstance[key][@"object"] class];
        }
    }
    [self.sharedInstance.lock unlock];
    return object;
}

void objectIsRegister(id object, Protocol *protocol) {
    void(^objectIsRegister)(BOOL instanceMethod) = ^(BOOL instanceMethod) {
        unsigned int count = 0;
        struct objc_method_description *methodDescription = protocol_copyMethodDescriptionList(protocol, YES, instanceMethod, &count);
        for (NSUInteger i = 0; i < count; i++) {
            struct objc_method_description description = methodDescription[i];
            if (instanceMethod) {
                if ([[object class] instancesRespondToSelector:description.name] == NO) {
                    NSString *errorMessage = [NSString stringWithFormat:@"\n⚠️⚠️⚠️⚠️(重要)⚠️⚠️⚠️⚠️---------\n%@未实现%@中的%@方法\n⚠️⚠️⚠️⚠️--------",[object class], protocol, NSStringFromSelector(description.name)];
                }
            } else {
                if ([[object class] respondsToSelector:description.name] == NO) {
                    NSString *errorMessage = [NSString stringWithFormat:@"\n⚠️⚠️⚠️⚠️(重要)⚠️⚠️⚠️⚠️---------\n%@未实现%@中的%@方法\n⚠️⚠️⚠️⚠️--------",[object class], protocol, NSStringFromSelector(description.name)];
                }
            }
        }
    };
    objectIsRegister(NO);
    objectIsRegister(YES);
}

+ (void)registerObject:(id)object instance:(BOOL)instance protocol:(Protocol *)protocol priority:(NHPriority)priority; {
    if (protocol == nil || object == nil) {
        return;
    }
    objectIsRegister(object, protocol);
    [self.sharedInstance.lock lock];
    NSString *key = NSStringFromProtocol(protocol);
    NSMutableDictionary *dictTarget = instance ? self.sharedInstance.dictInstance : self.sharedInstance.dictClass;
    NSDictionary *dict = dictTarget[key];
    if (dict == nil || priority > [dict[@"priority"] integerValue]) {
        dictTarget[key] = @{@"priority" : @(priority), @"object" : object};
        [self.sharedInstance.lock unlock];
    } else {
        [self.sharedInstance.lock unlock];
        NSString *errorMessage = [NSString stringWithFormat:@"%@协议已经被%@lei类注册过,不能再次注册%@", key, dictTarget[key], object];
    }
}

@end


@implementation NHNewDemoProtocolManager (NHInstanceProtocolManager)

+ (id _Nullable)loadInstanceWithProtocol:(Protocol *_Nonnull)protocol; {
    return [self objectWithProtocol:protocol instance:YES];
}

+ (void)registerInstance:(id<NSObject>  _Nonnull)object forProtocol:(Protocol *)protocol; {
    [self registerObject:object instance:YES protocol:protocol priority:NHPriorityNormal];
}

+ (void)registerInstance:(id<NSObject>  _Nonnull)object forProtocol:(Protocol *_Nonnull)protocol priority:(NHPriority)priority; {
    [self registerObject:object instance:YES protocol:protocol priority:priority];
}

@end

@implementation NHNewDemoProtocolManager (NHClassProtocolManager)

+ (Class _Nullable)loadClassWithProtocol:(Protocol *_Nonnull)protocol; {
    return [self objectWithProtocol:protocol instance:NO];
}

+ (void)registerClass:(Class<NSObject> _Nonnull)aClass forProtocol:(Protocol *_Nonnull)protocol; {
    [self registerObject:aClass instance:NO protocol:protocol priority:NHPriorityNormal];
}

+ (void)registerClass:(Class<NSObject> _Nonnull)aClass forProtocol:(Protocol *_Nonnull)protocol priority:(NHPriority)priority; {
    [self registerObject:aClass instance:NO protocol:protocol priority:priority];
}

@end
