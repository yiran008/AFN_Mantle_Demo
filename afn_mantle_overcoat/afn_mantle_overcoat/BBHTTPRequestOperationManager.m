//
//  BBHTTPRequestOperationManager.m
//  afn_mantle_overcoat
//
//  Created by liumiao on 10/24/14.
//  Copyright (c) 2014 liumiao. All rights reserved.
//

#import "BBHTTPRequestOperationManager.h"

@interface BBHTTPRequestOperationManager ()


@end

@implementation BBHTTPRequestOperationManager


- (void)dealloc {

}


- (void)cancelAllRequests {
    [self.operationQueue cancelAllOperations];
}

#pragma mark - Making requests

#warning 公共参数和错误处理 可以统一在这里加

- (AFHTTPRequestOperation *)GET:(NSString *)APIString
                     parameters:(NSDictionary *)parameters
                     completion:(void (^)(id, NSError *))completion
{
    return [self GET:APIString parameters:parameters
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 if (completion) completion(responseObject, nil);
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 if (completion) completion(operation.responseObject, error);
             } autoRetry:AFN_REQUEST_RETRY_COUNT];
}

- (AFHTTPRequestOperation *)HEAD:(NSString *)APIString
                      parameters:(id)parameters
                      completion:(void (^)(id, NSError *))completion
{
    return [self HEAD:APIString parameters:parameters
              success:^(AFHTTPRequestOperation *operation) {
                  if (completion) completion(operation.responseObject, nil);
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  if (completion) completion(operation.responseObject, error);
              } autoRetry:AFN_REQUEST_RETRY_COUNT];
}

- (AFHTTPRequestOperation *)POST:(NSString *)APIString
                      parameters:(NSDictionary *)parameters
                      completion:(void (^)(id, NSError *))completion
{
    return [self POST:APIString parameters:parameters
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  if (completion) completion(responseObject, nil);
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  if (completion) completion(operation.responseObject, error);
              } autoRetry:AFN_REQUEST_RETRY_COUNT];
}

- (AFHTTPRequestOperation *)POST:(NSString *)APIString
                      parameters:(NSDictionary *)parameters
       constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))block
                      completion:(void (^)(id, NSError *))completion
{
    return [self POST:APIString parameters:parameters constructingBodyWithBlock:block
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  if (completion) completion(responseObject, nil);
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  if (completion) completion(operation.responseObject, error);
              } autoRetry:AFN_REQUEST_RETRY_COUNT];
}

- (AFHTTPRequestOperation *)PUT:(NSString *)APIString
                     parameters:(NSDictionary *)parameters
                     completion:(void (^)(id, NSError *))completion
{
    return [self PUT:APIString parameters:parameters
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 if (completion) completion(responseObject, nil);
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 if (completion) completion(operation.responseObject, error);
             } autoRetry:AFN_REQUEST_RETRY_COUNT];
}

- (AFHTTPRequestOperation *)PATCH:(NSString *)APIString
                       parameters:(NSDictionary *)parameters
                       completion:(void (^)(id, NSError *))completion
{
    return [self PATCH:APIString parameters:parameters
               success:^(AFHTTPRequestOperation *operation, id responseObject) {
                   if (completion) completion(responseObject, nil);
               }
               failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                   if (completion) completion(operation.responseObject, error);
               } autoRetry:AFN_REQUEST_RETRY_COUNT];
}

- (AFHTTPRequestOperation *)DELETE:(NSString *)APIString
                        parameters:(NSDictionary *)parameters
                        completion:(void (^)(id, NSError *))completion
{
    return [self DELETE:APIString parameters:parameters
                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    if (completion) completion(responseObject, nil);
                }
                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    if (completion) completion(operation.responseObject, error);
                } autoRetry:AFN_REQUEST_RETRY_COUNT];
}

@end
