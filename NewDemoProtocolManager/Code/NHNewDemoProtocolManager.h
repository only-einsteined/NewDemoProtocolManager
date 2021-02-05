//
//  NHNewDemoProtocolManager.h
//  NewDemoProtocolManager
//
//  Created by only-einsteined on 12/28/2020.
//  Copyright (c) 2020 only-einsteined. All rights reserved..
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, NHPriority) {
    NHPriorityNormal,
    NHPriorityHigh,
};

/**
 一个组件 向NHNewDemoProtocolManager 注册 其接口
 然后其他组件 用注册的接口接口向MGProtocolManager取 注册的组件的类，实例
 */

__attribute__((objc_subclassing_restricted))
@interface NHNewDemoProtocolManager : NSObject

@end

@interface NHNewDemoProtocolManager (NHInstanceProtocolManager)

+ (id _Nullable)loadInstanceWithProtocol:(Protocol *_Nonnull)protocol;

+ (void)registerInstance:(id<NSObject>  _Nonnull)object forProtocol:(Protocol *)protocol;

+ (void)registerInstance:(id<NSObject>  _Nonnull)object forProtocol:(Protocol *_Nonnull)protocol priority:(NHPriority)priority;

@end

@interface NHNewDemoProtocolManager (NHClassProtocolManager)

+ (Class _Nullable)loadClassWithProtocol:(Protocol *_Nonnull)protocol;

+ (void)registerClass:(Class<NSObject> _Nonnull)aClass forProtocol:(Protocol *_Nonnull)protocol;

+ (void)registerClass:(Class<NSObject> _Nonnull)aClass forProtocol:(Protocol *_Nonnull)protocol priority:(NHPriority)priority;

@end


NS_ASSUME_NONNULL_END
