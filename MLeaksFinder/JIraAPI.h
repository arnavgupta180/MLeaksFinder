//
//  JIraAPI.h
//  createJiraTicket
//
//  Created by tokopedia on 22/02/20.
//  Copyright © 2020 tokopedia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JIraAPI : NSObject
+(void)CreateNewIssue:(NSString *)summary;
-(void)createJiraTicket:(NSString *)summary :(NSString *)squadName;
-(void)searchJiraTicket:(NSString *)summary completionHandler:(void (^)(bool isIssue))completionHandler;
-(void)fetchCodeOwners:(NSString *)summary completionHandler: (void (^)(NSArray * array))completionHandler;
@end

NS_ASSUME_NONNULL_END
