//
//  LGHSaveMutableArray.m
//  Litter_item
//
//  Created by 小肥观 on 2020/12/3.
//

#import "LGHSaveMutableArray.h"

#define LGH_INIT(...) self = super.init; \
if (!self) return nil; \
__VA_ARGS__; \
if (!_arr) return nil; \
NSString *uuid = [NSString stringWithFormat:@"com.shuxia.array_%p",self];\
_ayncQueue = dispatch_queue_create([uuid UTF8String], DISPATCH_QUEUE_CONCURRENT);\
return self;

#define LGH_LOCK(type,obj, ...)  __block type obj ; \
dispatch_sync(_ayncQueue, ^{ __VA_ARGS__; });

#define LGH_LOCK_VOID(...)  dispatch_sync(_ayncQueue, ^{ __VA_ARGS__; });

#define LGH_UNLOCK(...)  dispatch_barrier_async(_ayncQueue, ^{ __VA_ARGS__;});





@interface LGHSaveMutableArray()
{
    NSMutableArray *_arr;  
    dispatch_queue_t _ayncQueue;
}

@end

@implementation LGHSaveMutableArray
#pragma mark - init

- (instancetype)init {
    LGH_INIT(_arr = [[NSMutableArray alloc] init]);
}

- (instancetype)initWithCapacity:(NSUInteger)numItems {
    LGH_INIT(_arr = [[NSMutableArray alloc] initWithCapacity:numItems]);
}

- (instancetype)initWithArray:(NSArray *)array {
    LGH_INIT(_arr = [[NSMutableArray alloc] initWithArray:array]);
}

- (instancetype)initWithObjects:(const id[])objects count:(NSUInteger)cnt {
    LGH_INIT(_arr = [[NSMutableArray alloc] initWithObjects:objects count:cnt]);
}

- (instancetype)initWithContentsOfFile:(NSString *)path {
    LGH_INIT(_arr = [[NSMutableArray alloc] initWithContentsOfFile:path]);
}

- (instancetype)initWithContentsOfURL:(NSURL *)url {
    LGH_INIT(_arr = [[NSMutableArray alloc] initWithContentsOfURL:url]);
}


#pragma mark - mutable

- (void)addObject:(id)anObject {
    LGH_UNLOCK([_arr addObject:anObject]);
}

- (void)insertObject:(id)anObject atIndex:(NSUInteger)index {
    LGH_UNLOCK([_arr insertObject:anObject atIndex:index]);
}

- (void)removeLastObject {
    LGH_UNLOCK([_arr removeLastObject]);
}

- (void)removeObjectAtIndex:(NSUInteger)index {
    LGH_UNLOCK([_arr removeObjectAtIndex:index]);
}

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
    LGH_UNLOCK([_arr replaceObjectAtIndex:index withObject:anObject]);
}

- (void)addObjectsFromArray:(NSArray *)otherArray {
    LGH_UNLOCK([_arr addObjectsFromArray:otherArray]);
}

- (void)exchangeObjectAtIndex:(NSUInteger)idx1 withObjectAtIndex:(NSUInteger)idx2 {
    LGH_UNLOCK([_arr exchangeObjectAtIndex:idx1 withObjectAtIndex:idx2]);
}

- (void)removeAllObjects {
    LGH_UNLOCK([_arr removeAllObjects]);
}

- (void)removeObject:(id)anObject inRange:(NSRange)range {
    LGH_UNLOCK([_arr removeObject:anObject inRange:range]);
}

- (void)removeObject:(id)anObject {
    LGH_UNLOCK([_arr removeObject:anObject]);
}

- (void)removeObjectIdenticalTo:(id)anObject inRange:(NSRange)range {
    LGH_UNLOCK([_arr removeObjectIdenticalTo:anObject inRange:range]);
}

- (void)removeObjectIdenticalTo:(id)anObject {
    LGH_UNLOCK([_arr removeObjectIdenticalTo:anObject]);
}

- (void)removeObjectsInArray:(NSArray *)otherArray {
    LGH_UNLOCK([_arr removeObjectsInArray:otherArray]);
}

- (void)removeObjectsInRange:(NSRange)range {
    LGH_UNLOCK([_arr removeObjectsInRange:range]);
}

- (void)replaceObjectsInRange:(NSRange)range withObjectsFromArray:(NSArray *)otherArray range:(NSRange)otherRange {
    LGH_UNLOCK([_arr replaceObjectsInRange:range withObjectsFromArray:otherArray range:otherRange]);
}

- (void)replaceObjectsInRange:(NSRange)range withObjectsFromArray:(NSArray *)otherArray {
    LGH_UNLOCK([_arr replaceObjectsInRange:range withObjectsFromArray:otherArray]);
}

- (void)setArray:(NSArray *)otherArray {
    LGH_UNLOCK([_arr setArray:otherArray]);
}

- (void)sortUsingFunction:(NSInteger (*)(id, id, void *))compare context:(void *)context {
    LGH_UNLOCK([_arr sortUsingFunction:compare context:context]);
}

- (void)sortUsingSelector:(SEL)comparator {
    LGH_UNLOCK([_arr sortUsingSelector:comparator]);
}

- (void)insertObjects:(NSArray *)objects atIndexes:(NSIndexSet *)indexes {
    LGH_UNLOCK([_arr insertObjects:objects atIndexes:indexes]);
}

- (void)removeObjectsAtIndexes:(NSIndexSet *)indexes {
    LGH_UNLOCK([_arr removeObjectsAtIndexes:indexes]);
}

- (void)replaceObjectsAtIndexes:(NSIndexSet *)indexes withObjects:(NSArray *)objects {
    LGH_UNLOCK([_arr replaceObjectsAtIndexes:indexes withObjects:objects]);
}

- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)idx {
    LGH_UNLOCK([_arr setObject:obj atIndexedSubscript:idx]);
}

- (void)sortUsingComparator:(NSComparator)cmptr {
    LGH_UNLOCK([_arr sortUsingComparator:cmptr]);
}

- (void)sortWithOptions:(NSSortOptions)opts usingComparator:(NSComparator)cmptr {
    LGH_UNLOCK([_arr sortWithOptions:opts usingComparator:cmptr]);
}


#pragma mark - lock method
- (NSUInteger)count {
    LGH_LOCK(NSUInteger,count,count = _arr.count); return count;
}

- (id)objectAtIndex:(NSUInteger)index {
    LGH_LOCK(id, obj,obj = [_arr objectAtIndex:index]); return obj;
}

- (NSArray *)arrayByAddingObject:(id)anObject {
    LGH_LOCK(NSArray * ,arr,arr = [_arr arrayByAddingObject:anObject]); return arr;
}

- (NSArray *)arrayByAddingObjectsFromArray:(NSArray *)otherArray {
    LGH_LOCK(NSArray * ,arr, arr= [_arr arrayByAddingObjectsFromArray:otherArray]); return arr;
}

- (NSString *)componentsJoinedByString:(NSString *)separator {
    LGH_LOCK(NSString * ,str ,str = [_arr componentsJoinedByString:separator]); return str;
}

- (BOOL)containsObject:(id)anObject {
    LGH_LOCK(BOOL, c,c = [_arr containsObject:anObject]); return c;
}

- (NSString *)description {
    LGH_LOCK(NSString *, d,d = _arr.description); return d;
}

- (NSString *)descriptionWithLocale:(id)locale {
    LGH_LOCK(NSString *, d,d = [_arr descriptionWithLocale:locale]); return d;
}

- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level {
    LGH_LOCK(NSString * ,d ,d= [_arr descriptionWithLocale:locale indent:level]); return d;
}

- (id)firstObjectCommonWithArray:(NSArray *)otherArray {
    LGH_LOCK(id, o,o = [_arr firstObjectCommonWithArray:otherArray]); return o;
}

- (void)getObjects:(id __unsafe_unretained[])objects range:(NSRange)range {
    LGH_LOCK_VOID([_arr getObjects:objects range:range]);
}

- (NSUInteger)indexOfObject:(id)anObject {
    LGH_LOCK(NSUInteger ,i,i = [_arr indexOfObject:anObject]); return i;
}

- (NSUInteger)indexOfObject:(id)anObject inRange:(NSRange)range {
    LGH_LOCK(NSUInteger ,i,i = [_arr indexOfObject:anObject inRange:range]); return i;
}

- (NSUInteger)indexOfObjectIdenticalTo:(id)anObject {
    LGH_LOCK(NSUInteger ,i , i = [_arr indexOfObjectIdenticalTo:anObject]); return i;
}

- (NSUInteger)indexOfObjectIdenticalTo:(id)anObject inRange:(NSRange)range {
    LGH_LOCK(NSUInteger ,i , i = [_arr indexOfObjectIdenticalTo:anObject inRange:range]); return i;
}

- (id)firstObject {
    LGH_LOCK(id , o , o= _arr.firstObject); return o;
}

- (id)lastObject {
    LGH_LOCK(id , o , o= _arr.lastObject); return o;
}

- (NSEnumerator *)objectEnumerator {
    LGH_LOCK(NSEnumerator * , e , e = [_arr objectEnumerator]); return e;
}

- (NSEnumerator *)reverseObjectEnumerator {
    LGH_LOCK(NSEnumerator * , e , e = [_arr reverseObjectEnumerator]); return e;
}

- (NSData *)sortedArrayHint {
    LGH_LOCK(NSData * ,d , d = [_arr sortedArrayHint]); return d;
}

- (NSArray *)sortedArrayUsingFunction:(NSInteger (*)(id, id, void *))comparator context:(void *)context {
    LGH_LOCK(NSArray *, arr , arr = [_arr sortedArrayUsingFunction:comparator context:context]) return arr;
}

- (NSArray *)sortedArrayUsingFunction:(NSInteger (*)(id, id, void *))comparator context:(void *)context hint:(NSData *)hint {
    LGH_LOCK(NSArray *, arr , arr = [_arr sortedArrayUsingFunction:comparator context:context hint:hint]); return arr;
}

- (NSArray *)sortedArrayUsingSelector:(SEL)comparator {
    LGH_LOCK(NSArray *, arr , arr = [_arr sortedArrayUsingSelector:comparator]); return arr;
}

- (NSArray *)subarrayWithRange:(NSRange)range {
    LGH_LOCK(NSArray *, arr , arr = [_arr subarrayWithRange:range]) return arr;
}

- (void)makeObjectsPerformSelector:(SEL)aSelector {
    LGH_LOCK_VOID([_arr makeObjectsPerformSelector:aSelector]);
}

- (void)makeObjectsPerformSelector:(SEL)aSelector withObject:(id)argument {
    LGH_LOCK_VOID([_arr makeObjectsPerformSelector:aSelector withObject:argument]);
}

- (NSArray *)objectsAtIndexes:(NSIndexSet *)indexes {
    LGH_LOCK(NSArray *, arr , arr = [_arr objectsAtIndexes:indexes]); return arr;
}

- (id)objectAtIndexedSubscript:(NSUInteger)idx {
    LGH_LOCK(id , o , o= [_arr objectAtIndexedSubscript:idx]); return o;
}

- (void)enumerateObjectsUsingBlock:(void (^)(id obj, NSUInteger idx, BOOL *stop))block {
    LGH_LOCK_VOID([_arr enumerateObjectsUsingBlock:block]);
}

- (void)enumerateObjectsWithOptions:(NSEnumerationOptions)opts usingBlock:(void (^)(id obj, NSUInteger idx, BOOL *stop))block {
    LGH_LOCK_VOID([_arr enumerateObjectsWithOptions:opts usingBlock:block]);
}

- (void)enumerateObjectsAtIndexes:(NSIndexSet *)s options:(NSEnumerationOptions)opts usingBlock:(void (^)(id obj, NSUInteger idx, BOOL *stop))block {
    LGH_LOCK_VOID([_arr enumerateObjectsAtIndexes:s options:opts usingBlock:block]);
}

- (NSUInteger)indexOfObjectPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate {
    LGH_LOCK(NSUInteger ,i , i = [_arr indexOfObjectPassingTest:predicate]); return i;
}

- (NSUInteger)indexOfObjectWithOptions:(NSEnumerationOptions)opts passingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate {
    LGH_LOCK(NSUInteger ,i , i = [_arr indexOfObjectWithOptions:opts passingTest:predicate]); return i;
}

- (NSUInteger)indexOfObjectAtIndexes:(NSIndexSet *)s options:(NSEnumerationOptions)opts passingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate {
    LGH_LOCK(NSUInteger ,i , i = [_arr indexOfObjectAtIndexes:s options:opts passingTest:predicate]); return i;
}

- (NSIndexSet *)indexesOfObjectsPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate {
    LGH_LOCK(NSIndexSet *, i  , i = [_arr indexesOfObjectsPassingTest:predicate]); return i;
}

- (NSIndexSet *)indexesOfObjectsWithOptions:(NSEnumerationOptions)opts passingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate {
    LGH_LOCK(NSIndexSet *, i  , i = [_arr indexesOfObjectsWithOptions:opts passingTest:predicate]); return i;
}

- (NSIndexSet *)indexesOfObjectsAtIndexes:(NSIndexSet *)s options:(NSEnumerationOptions)opts passingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate {
    LGH_LOCK(NSIndexSet *, i  , i = [_arr indexesOfObjectsAtIndexes:s options:opts passingTest:predicate]); return i;
}

- (NSArray *)sortedArrayUsingComparator:(NSComparator)cmptr {
    LGH_LOCK(NSArray * ,a, a = [_arr sortedArrayUsingComparator:cmptr]); return a;
}

- (NSArray *)sortedArrayWithOptions:(NSSortOptions)opts usingComparator:(NSComparator)cmptr {
    LGH_LOCK(NSArray * ,a, a = [_arr sortedArrayWithOptions:opts usingComparator:cmptr]); return a;
}

- (NSUInteger)indexOfObject:(id)obj inSortedRange:(NSRange)r options:(NSBinarySearchingOptions)opts usingComparator:(NSComparator)cmp {
    LGH_LOCK(NSUInteger ,i , i = [_arr indexOfObject:obj inSortedRange:r options:opts usingComparator:cmp]); return i;
}

@end
