//
//  KCLiveStreamChannelMessage.m
//  001---直播架构搭建
//
//  Created by cooci on 2018/10/23.
//  Copyright © 2018 cooci. All rights reserved.
//

#import "KCLiveStreamChannelMessage.h"

@implementation KCLiveStreamChannelMessage

- (TYTextContainer*)createRichTextContainer {
    TYTextContainer *textContainer = [[TYTextContainer alloc]init];
    textContainer.lineBreakMode = kCTLineBreakByWordWrapping;
    textContainer.characterSpacing = 0;
    return textContainer;
}

- (UIFont*)getContentFont {
    return [UIFont fontOfSystemFontWithMediumSize:15];
}

- (UIFont*)getNameFont {
    return [UIFont fontOfSystemFontWithSemiBoldSize:15];
}


@end
