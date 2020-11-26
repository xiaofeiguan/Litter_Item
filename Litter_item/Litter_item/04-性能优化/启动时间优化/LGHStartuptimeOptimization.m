//
//  LGHStartuptimeOptimization.m
//  Litter_item
//
//  Created by 小肥观 on 2020/11/24.
//

#import "LGHStartuptimeOptimization.h"
#include <stdint.h>
#include <stdio.h>
#include <stddef.h>
#include <sanitizer/coverage_interface.h>
#import <dlfcn.h>
#import <libkern/OSAtomic.h>
@implementation LGHStartuptimeOptimization
/*
博客见: 有道云笔记  第28次课-Clang插桩(听课笔记)
推荐文章：
 https://www.jianshu.com/p/bae1e9bddcc9
 https://juejin.cn/post/6844904130406793224
 */

//定义原子队列
static OSQueueHead symbolList = OS_ATOMIC_QUEUE_INIT;

//定义符号结构体
typedef struct{
    void *pc;
    void *next;
} SYNode;

void __sanitizer_cov_trace_pc_guard_init(uint32_t *start,
                                         uint32_t *stop) {
    static uint64_t N;
    if (start == stop || *start) return;
    printf("<<<INIT>>>: %p %p\n", start, stop);
    for (uint32_t *x = start; x < stop; x++)
    *x = ++N;
}
void __sanitizer_cov_trace_pc_guard(uint32_t *guard) {
    //    if (!*guard) return;
    // 当前函数返回到上一个调用的地址
    void *PC = __builtin_return_address(0);
    // 存入原子队列
    SYNode * node = malloc(sizeof(SYNode));
    *node = (SYNode){PC,NULL};
    //加入结构!
    OSAtomicEnqueue(&symbolList, node, offsetof(SYNode, next));
    
}

+(void)getOrderFile{
    //定义数组
    NSMutableArray<NSString *> * symbolNames = [NSMutableArray array];
    while (YES) {
        // 一次循环！也会被hook一次
        //  只要有b 或bl的汇编指令就会hook一次，即循环，会进行跳转
        
        SYNode *node = OSAtomicDequeue(&symbolList, offsetof(SYNode, next));
        if (node == NULL) {
            break;;
        }
        Dl_info info = {0};
        dladdr(node->pc, &info);
        NSString *name = @(info.dli_sname);
        if ([name hasPrefix:@"+["]||[name hasPrefix:@"-["]) {
            [symbolNames addObject:name];
            continue;
        }
        [symbolNames addObject:[@"_" stringByAppendingString:name]];
    }
    // 倒序排序
    NSEnumerator * enumerator = [symbolNames reverseObjectEnumerator];
    //创建一个新数组
    NSMutableArray * funcs = [NSMutableArray arrayWithCapacity:symbolNames.count];
    NSString * name;
    //去重!
    while (name = [enumerator nextObject]) {
        if (![funcs containsObject:name]) {//数组中不包含name
            [funcs addObject:name];
        }
    }
    [funcs removeObject:[NSString stringWithFormat:@"_%s",__FUNCTION__]];
    [funcs removeObject:[NSString stringWithFormat:@"%s",__FUNCTION__]];
    //数组转成字符串
    NSString * funcStr = [funcs componentsJoinedByString:@"\n"];
    //字符串写入文件
    //文件路径
    NSString * filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"lgh_order_file.order"];
    //文件内容
    NSData * fileContents = [funcStr dataUsingEncoding:NSUTF8StringEncoding];
    [[NSFileManager defaultManager] createFileAtPath:filePath contents:fileContents attributes:nil];
}



@end
