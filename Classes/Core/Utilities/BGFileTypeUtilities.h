//
//  BGFileTypeUtilities.h
//  BGMagazine
//
//  Created by Lawrence Lomax on 02/10/2012.
//  Copyright (c) 2012 Bell George. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    BGFileTypeUnknown,
    BGFileTypeWebContent,
    BGFileTypeMovie,
    BGFileTypeAudio,
    
    BGFileTypePDF
} BGFileTypes;

@interface BGFileTypeUtilities : NSObject

+ (BGFileTypes) fileTypeForURL:(NSURL *)url;

@end
