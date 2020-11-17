//
//  Color.h
//  Litter_item
//
//  Created by 小肥观 on 2020/11/13.
//

#ifndef Color_h
#define Color_h

#define UIColorFromHex(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0  alpha:1.0]

#define UIColorFromRGB(r,g,b)             [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0  alpha:1.0]



#endif /* Color_h */
