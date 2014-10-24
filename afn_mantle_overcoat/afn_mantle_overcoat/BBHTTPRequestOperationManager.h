
//
//  BBHTTPRequestOperationManager.h
//  afn_mantle_overcoat
//
//  Created by liumiao on 10/24/14.
//  Copyright (c) 2014 liumiao. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "AFHTTPRequestOperationManager+AutoRetry.h"
@interface BBHTTPRequestOperationManager : AFHTTPRequestOperationManager

- (void)cancelAllRequests;


- (AFHTTPRequestOperation *)GET:(NSString *)APIString
                     parameters:(NSDictionary *)parameters
                     completion:(void (^)(id response, NSError *error))completion;


- (AFHTTPRequestOperation *)HEAD:(NSString *)APIString
                      parameters:(id)parameters
                      completion:(void (^)(id response, NSError *error))completion;


- (AFHTTPRequestOperation *)POST:(NSString *)APIString
                      parameters:(NSDictionary *)parameters
                      completion:(void (^)(id response, NSError *error))completion;


- (AFHTTPRequestOperation *)POST:(NSString *)APIString
                      parameters:(NSDictionary *)parameters
       constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                      completion:(void (^)(id response, NSError *error))completion;

- (AFHTTPRequestOperation *)PUT:(NSString *)APIString
                     parameters:(NSDictionary *)parameters
                     completion:(void (^)(id response, NSError *error))completion;

- (AFHTTPRequestOperation *)PATCH:(NSString *)APIString
                       parameters:(NSDictionary *)parameters
                       completion:(void (^)(id response, NSError *error))completion;


- (AFHTTPRequestOperation *)DELETE:(NSString *)APIString
                        parameters:(NSDictionary *)parameters
                        completion:(void (^)(id response, NSError *error))completion;

@end