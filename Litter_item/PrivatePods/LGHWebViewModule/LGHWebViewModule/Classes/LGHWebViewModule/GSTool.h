//
//  GSTool.h
//  Help
//
//  Created by gamesirDev on 14/4/2020.
//  Copyright © 2020 Lfm. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GSTool : NSObject

+ (instancetype)shared;

- (NSString*)getLocalLanguage;

@end

NS_ASSUME_NONNULL_END
