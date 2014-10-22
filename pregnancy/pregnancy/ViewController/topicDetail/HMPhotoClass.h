//
//  HMPhotoClass.h
//  lama
//
//  Created by mac on 14-3-27.
//  Copyright (c) 2014年 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMPhotoItem : NSObject

@property (nonatomic, retain) NSString *m_PhotoId;
@property (nonatomic, retain) NSString *m_BigUrl;
@property (nonatomic, retain) NSString *m_SmallUrl;

@property (nonatomic, assign) BOOL m_isDeleted;

@end

@interface HMPhotoClass : NSObject

@property (nonatomic, retain) NSMutableArray *m_PhotoList;
@property (nonatomic, retain) NSString *m_DateString;

@property (nonatomic, assign, readonly) NSInteger m_PhotoCount;

@property (nonatomic, assign) BOOL m_ShowDetail;

@property (nonatomic, assign) BOOL m_CanDelete;

@end
