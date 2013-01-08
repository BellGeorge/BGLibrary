//
//  BGFileTypeUtilities.m
//  BGMagazine
//
//  Created by Lawrence Lomax on 02/10/2012.
//  Copyright (c) 2012 Bell George. All rights reserved.
//

#import "BGFileTypeUtilities.h"
#import "BGLibraryMacros.h"

#import <MobileCoreServices/MobileCoreServices.h>

@implementation BGFileTypeUtilities

+ (NSDictionary *) fileExtensionDictionary
{
    static NSDictionary * dictionary = nil;
    
    if(!dictionary)
    {
        dictionary = @{
        @"pdf" : @(BGFileTypePDF),
        @"mov" : @(BGFileTypeMovie),
        @"mp4" : @(BGFileTypeMovie),
        @"m4v" : @(BGFileTypeMovie),
        @"mp3" : @(BGFileTypeAudio),
        @"m4a" : @(BGFileTypeAudio),
        @"html" : @(BGFileTypeWebContent),
        @"htm" : @(BGFileTypeWebContent)
        };
    }
    
    return dictionary;
}

+ (NSDictionary *) mimeTypeDictionary
{
    static NSDictionary * dictionary = nil;
    
    if(!dictionary)
    {
        dictionary = @{
        @"application/pdf" : @(BGFileTypePDF),
        @"video/mpeg" : @(BGFileTypeMovie),
        @"video/mp4" : @(BGFileTypeMovie),
        @"video/quicktime" : @(BGFileTypeMovie),
        @"text/html" : @(BGFileTypeWebContent),
        };
    }
    
    return dictionary;
}

+ (BGFileTypes) fileTypeForMimeType:(NSString *)mimeType
{
    NSNumber * number = nil;
    if(BGNotNull(mimeType))
    {
        number = [self mimeTypeDictionary][mimeType];
    }
    
    if(BGIsNull(number))
    {
        return BGFileTypeUnknown;
    }
    
    return [number intValue];
}

+ (BGFileTypes) fileTypeForExtension:(NSString *)extension
{
    NSNumber * number = nil;
    if(BGNotNull(extension))
    {
        number = [self fileExtensionDictionary][extension];
    }
    
    if(BGIsNull(number))
    {
        return BGFileTypeUnknown;
    }
    
    return [number intValue];
}


+ (BGFileTypes) fileTypeForURL:(NSURL *)url
{
    CFStringRef pathExtension = (__bridge_retained CFStringRef)[url pathExtension];
    CFStringRef type = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension, NULL);
    CFRelease(pathExtension);
    
    NSString * mimeType = (__bridge_transfer NSString *)UTTypeCopyPreferredTagWithClass(type, kUTTagClassMIMEType);
    
    BGFileTypes fileType = BGFileTypeUnknown;
    
    if(BGNotNull(mimeType))
    {
        fileType = [self fileTypeForMimeType:mimeType];
    }

    if(fileType == BGFileTypeUnknown)
    {
        fileType = [self fileTypeForExtension:[url pathExtension]];
    }
    
    if (type != NULL)
    {
        CFRelease(type);
    }
    
    return fileType;
}

@end
