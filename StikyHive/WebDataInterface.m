//
//  WebDataInterface.m
//  StikyHive
//
//  Created by Koh Quee Boon on 13/4/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import "WebDataInterface.h"
#import "ViewControllerUtil.h"
#import "Skill.h"

@interface WebDataInterface()

@property (nonatomic, strong) NSString *callBackName;

@end

@implementation WebDataInterface


const float DATA_REQUEST_TIMEOUT = 30.0f;


//////////////////////  Echo ////////////////////////////////////////////////////

+ (void)getCountry:(NSInteger)status completion:(void (^)(NSObject *, NSError *))completion {
    NSNumber *statusNum = [NSNumber numberWithInteger:status];
    [self requestData:DATA_URL_GET_POSTS_COUNTRY withParameters:@{@"status":statusNum} completion:completion];
}

+ (void)getCategory:(NSInteger)status completion:(void (^)(NSObject *, NSError *))completion {
    NSNumber *statusNumb = [NSNumber numberWithInteger:status];     
    [self requestData:DATA_URL_GET_POSTS_CATEGORY withParameters:@{@"status":statusNumb} completion:completion];
}

+ (void)signupWithUsername:(NSString *)username password:(NSString *)password completion:(void (^)(NSObject *, NSError *))completion
{
    NSDictionary *params = @{POST_PARAMETER_EMAIL:username,
                             POST_PARAMETER_PASSWORD:password};
    [self requestData:DATA_URL_USER_SIGNUP withParameters:params completion:completion];
}

+ (void)loginWithEmail:(NSString *)email password:(NSString *)password completion:(void (^)(NSObject *, NSError *))completion
{
    NSDictionary *params = @{POST_PARAMETER_EMAIL:email,
                             POST_PARAMETER_PASSWORD:password};
    
    [self requestData:DATA_URL_USER_LOGIN withParameters:params completion:completion];
}

+ (void)verifyUserEmail:(NSString *)email password:(NSString *)password hashcode:(NSString *)code completion:(void (^)(NSObject *, NSError *))completion
{
    NSDictionary *params = @{POST_PARAMETER_EMAIL:email,
                             POST_PARAMETER_PASSWORD:password,
                             POST_PARAMETER_HASHCODE:code};
    
    [self requestData:DATA_URL_USER_VERIFY withParameters:params completion:completion];
}

+ (void)saveStikyBeeInfo:(NSString *)email password:(NSString *)password firstname:(NSString *)firstname lastname:(NSString *)lastname dob:(NSString *)dob address:(NSString *)address country:(NSString *)countryISO postalcode:(NSString *)postalcode skillname1:(NSString *)skillname1 skillid1:(NSString *)skillid1 skilltype1:(NSString *)skilltype1 talentname1:(NSString *)talentname1 talentid1:(NSString *)talentid1 talenttype1:(NSString *)talenttype1
              completion:(void (^)(NSObject *, NSError *))completion
{
    NSDictionary *params = @{POST_PARAMETER_EMAIL:email,
                             POST_PARAMETER_PASSWORD:password,
                             POST_PARAMETER_FIRSTNAME:firstname,
                             POST_PARAMETER_LASTNAME:lastname,
                             POST_PARAMETER_DOB:dob,
                             POST_PARAMETER_ADDRESS:address,
                             POST_PARAMETER_COUNTRY:countryISO,
                             POST_PARAMETER_POSTAL_CODE:postalcode,
                             POST_PARAMETER_SKILLNAME:skillname1,
                             POST_PARAMETER_SKILLID:skillid1,
                             POST_PARAMETER_SKILLTYPE:skilltype1,
                             POST_PARAMETER_TALENTNAME:talentname1,
                             POST_PARAMETER_TALENTID:talentid1,
                             POST_PARAMETER_TALENTTYPE:talenttype1};
    
    [self requestData:DATA_URL_USER_SAVEPROFILE withParameters:params completion:completion];
}

+ (void)getImageLocation:(NSString *)stkid completion:(void (^)(NSObject *, NSError *))completion
{
    NSDictionary *params = @{POST_PARAMETER_STKID:stkid};
    [self requestData:DATA_URL_GET_IMAGE_LOCATION withParameters:params completion:completion];
}

+ (void)loginWithFB:(NSString *)email name:(NSString *)name profilePicture:(NSString *)profilePicture type:(NSString *)type completion:(void (^)(NSObject *, NSError *))completion
{
    
    NSDictionary *params = @{POST_PARAMETER_EMAIL:email,
                             POST_PARAMETER_NAME:name,
                             POST_PARAMETER_PROFILEPICTURE:profilePicture,
                             POST_PARAMETER_MEDIA_TYPE:type};
    
    [self requestData:DATA_URL_USER_FB_LOGIN withParameters:params completion:completion];
    
}

+ (void)forgotPassword:(NSString *)email completion:(void (^)(NSObject *, NSError *))completion {
    NSDictionary *params = @{POST_PARAMETER_EMAIL:email};
    [self requestData:DATA_URL_USER_FORGOT_PASSWORD withParameters:params completion:completion];
}


+ (void)getSellAll:(NSInteger)limit catId:(NSInteger)catId stkid:(NSString *)stkid actionMaker:(NSString *)actionMaker completion:(void (^)(NSObject *, NSError *))completion {
    
    NSDictionary *params = @{POST_PARAMETER_LIMIT:[NSNumber numberWithInteger:limit],
                             POST_PARAMETER_CATEGORY_ID:[NSNumber numberWithInteger:catId],
                             POST_PARAMETER_STKID:stkid,
                             POST_PARAMETER_STKID:actionMaker};
    [self requestData:DATA_URL_GET_SELL_MARKET withParameters:params completion:completion];
    
}

+ (void)getSellAllMy:(NSInteger)limit catId:(NSInteger)catId stkid:(NSString *)stkid flagMy:(BOOL)flagMy actionMaker:(NSString *)actionMaker completion:(void (^)(NSObject *, NSError *))completion
{
    NSDictionary *params = @{POST_PARAMETER_LIMIT:[NSNumber numberWithInteger:limit],
                             POST_PARAMETER_CATEGORY_ID:[NSNumber numberWithInteger:catId],
                             POST_PARAMETER_STKID:stkid,
                             POST_PARAMETER_FLAG_MY:[NSNumber numberWithBool:flagMy],
                             POST_PARAMETER_STKID:actionMaker};
    [self requestData:DATA_URL_GET_SELL_MARKET withParameters:params completion:completion];
}

+ (void)getBuyerMarket:(NSString *)skillId limit:(NSInteger)limit completion:(void (^)(NSObject *, NSError *))completion {
    
    NSDictionary *params = @{POST_PARAMETER_SKILL_ID:skillId,
                             POST_PARAMETER_LIMIT:[NSNumber numberWithInteger:limit]};
    
    [self requestData:DATA_URL_GET_BUYER_MARKET withParameters:params completion:completion];
}


+ (void)getBuyerMarketByStkid:(NSString *)stkid limit:(NSInteger)limit completion:(void (^)(NSObject *, NSError *))completion
{
    NSDictionary *params = @{POST_PARAMETER_STKID:stkid,
                             POST_PARAMETER_LIMIT:[NSNumber numberWithInteger:limit]};
    
    [self requestData:DATA_URL_GET_BUYER_MARKET withParameters:params completion:completion];
}


+ (NSString *)getFullUrlPath:(NSString *)fileLoc
{
    NSString *fullPath = [NSString stringWithFormat:@"%@/%@", DATA_HOST, fileLoc];
    return [fullPath stringByReplacingOccurrencesOfString:IOS_STORAGE_PATH withString:DATA_HOST];
}


+ (void)getSkillById:(NSString *)skillId stkid:(NSString *)stkid completion:(void (^)(NSObject *, NSError *))completion
{
    NSDictionary *params = @{POST_PARAMETER_SKILL_ID:skillId,
                             POST_PARAMETER_STKID:stkid};
    [self requestData:DATA_URL_GET_SKILL_BY_ID withParameters:params completion:completion];
}

+ (void)getCommReviewBySkillId:(NSString *)skillId completion:(void (^)(NSObject *, NSError *))completion
{
    NSDictionary *params = @{POST_PARAMETER_SKILL_ID:skillId};
    [self requestData:DATA_URL_GET_COMM_BY_SKILL_ID withParameters:params completion:completion];
}

+ (void)postSellerComments:(NSString *)skillId reviewer:(NSString *)reviewer review:(NSString *)review type:(NSInteger)type rating:(NSInteger)rating completion:(void (^)(NSObject *, NSError *))completion
{
    NSDictionary *params = @{POST_PARAMETER_SKILL_ID:skillId,
                             POST_PARAMETER_REVIEWR:reviewer,
                             POST_PARAMETER_REVIEW:review,
                             POST_PARAMETER_TYPE:[NSNumber numberWithInteger:type],
                             POST_PARAMETER_RATE:[NSNumber numberWithInteger:rating]};
    
    [self requestData:DATA_URL_POST_COMMENT withParameters:params completion:completion];
    
}


+ (void)getBuyerMarketById:(NSInteger)buyerId completion:(void (^)(NSObject *, NSError *))completion
{
    NSDictionary *params = @{POST_PARAMETER_BUYER_ID:[NSNumber numberWithInteger:buyerId]};
    [self requestData:DATA_URL_GET_BUYER_MARKET_BY_ID withParameters:params completion:completion];
}


+ (void)getStikyBeeInfo:(NSString *)stikyid completion:(void (^)(NSObject *, NSError *))completion
{
    NSDictionary *params = @{POST_PARAMETER_STKID:stikyid};
    [self requestData:DATA_URL_GET_STIKY_BEE_INFO withParameters:params completion:completion];
}


+ (void)insertSavedDocument:(NSString *)stkid name:(NSString *)name location:(NSString *)location completion:(void (^)(NSObject *, NSError *))completion
{
    NSDictionary *params = @{POST_PARAMETER_STKID:stkid,
                             POST_PARAMETER_NAME:name,
                             POST_PARAMETER_LOCATION:location};
    [self requestData:DATA_URL_INSERT_SAVED_DOCU withParameters:params completion:completion];
    
}

+ (void)getSavedDocument:(NSString *)stkid completion:(void (^)(NSObject *, NSError *))completion
{
    NSDictionary *params = @{POST_PARAMETER_STKID:stkid};
    [self requestData:DATA_URL_GET_SAVED_DOCUMENT withParameters:params completion:completion];
}


+ (void)getUrgentRequest:(NSInteger)limit stkid:(NSString *)stkid completion:(void (^)(NSObject *, NSError *))completion
{
    NSDictionary *params = @{POST_PARAMETER_LIMIT:[NSNumber numberWithInteger:limit],
                             POST_PARAMETER_STKID:stkid};
    [self requestData:DATA_URL_GET_URGENT_REQUEST withParameters:params completion:completion];
}

+ (void)getRate:(NSInteger)limit completion:(void (^)(NSObject *, NSError *))completion
{
    NSDictionary *parmas = @{POST_PARAMETER_LIMIT:[NSNumber numberWithInteger:limit]};
    [self requestData:DATA_URL_GET_RATE withParameters:parmas completion:completion];
}


+ (void)getMyLocation:(NSString *)stkid completion:(void (^)(NSObject *, NSError *))completion
{
    NSDictionary *params = @{POST_PARAMETER_STKID:stkid};
    [self requestData:DATA_URL_GET_MY_LOCATION withParameters:params completion:completion];
}

+ (void)searchNearByCp:(NSString *)stkid skillname:(NSString *)skillname completion:(void (^)(NSObject *, NSError *))completion
{
    NSDictionary *params = @{POST_PARAMETER_STKID:stkid,
                             POST_PARAMETER_NAMESKILL:skillname};
    
    [self requestData:DATA_URL_SEARCH_NEAR_BY_CP withParameters:params completion:completion];
}


+ (void)insertUrgentRequest:(NSString *)stkid title:(NSString *)title desc:(NSString *)desc completion:(void (^)(NSObject *, NSError *))completion
{
    NSDictionary *params = @{POST_PARAMETER_STKID:stkid,
                             POST_PARAMETER_TITLE:title,
                             POST_PARAMETER_DESC:desc};
    
    [self requestData:DATA_URL_INSERT_URGENT_REQUEST withParameters:params completion:completion];
}


+ (void)deleteDocuments:(NSArray *)idArray completion:(void (^)(NSObject *, NSError *))completion
{
    for (int i = 0; i < idArray.count; i++)
    {
        NSString *idString = idArray[i];
        NSInteger idInt = [idString integerValue];
        
        NSDictionary *params = @{POST_PARAMETER_DOCUMENT_ID:[NSNumber numberWithInteger:idInt]};
        
        [self requestData:DATA_URL_DELETE_DOCUMENT withParameters:params completion:completion];
    }
}


+ (void)selectSubInfo:(NSString *)stkid completion:(void (^)(NSObject *, NSError *))completion
{
    NSDictionary *params = @{POST_PARAMETER_STKID:stkid};
    
    [self requestData:DATA_URL_SELECT_SUBINFO withParameters:params completion:completion];
    
}


+ (void)selectContacts:(NSString *)stkid completion:(void (^)(NSObject *, NSError *))completion
{
    NSDictionary *params = @{POST_PARAMETER_STKID:stkid};
    [self requestData:DATA_URL_SELECT_CONTACT withParameters:params completion:completion];
}


+ (void)selectSoldInfo:(NSString *)stkid completion:(void (^)(NSObject *, NSError *))completion
{
    NSDictionary *params = @{POST_PARAMETER_STKID:stkid};
    [self requestData:DATA_URL_SELECT_SOLD_INFO withParameters:params completion:completion];
}

+ (void)selectBoughtInfo:(NSString *)stkid completion:(void (^)(NSObject *, NSError *))completion
{
    NSDictionary *params = @{POST_PARAMETER_STKID:stkid};
    [self requestData:DATA_URL_SELECT_BOUGHT_INFO withParameters:params completion:completion];
}


//+ (void)createUpdateSubPlan:(NSString *)stkid skillId:(NSInteger)skillId name:(NSString *)name description:(NSString *)description catId:(NSInteger)catId type:(NSInteger)type summary:(NSString *)summary price:(float)price rateId:(NSInteger)rateId subId1:(NSInteger)subId1 subMonth:(NSInteger)subMonth subPrice:(float)subPrice subTotal:(float)subTotal subType:(NSInteger)subType status1:(NSInteger)status1 subId3:(NSInteger)subId3 photoMonth:(NSInteger)photoMonth photoPrice:(float)photoPrice photoTotal:(float)photoTocal photoType:(NSInteger)photoType status3:(NSInteger)status3 subId4:(NSInteger)subId4 videoMonth:(NSInteger)videoMonth videoPrice:(float)videoPrice videoTotal:(float)videoTotal videoType:(NSInteger)videoType status4:(NSInteger)status4 subId2:(NSInteger)subId2 extraMonth:(NSInteger)extraMonth extraPrice:(float)extraPrice extendTotal:(float)extendTotal extraTotal:(float)extraTotal status2:(NSInteger)status2 completion:(void (^)(NSObject *, NSError *))completion
//{
//    NSDictionary *params = @{POST_PARAMETER_STKID:stkid,
//                             POST_PARAMETER_SKILL_ID:[NSNumber numberWithInteger:skillId],
//                             POST_PARAMETER_NAME:name,
//                             POST_PARAMETER_DESCRIPTION:description,
//                             POST_PARAMETER_CATEGORY_ID:[NSNumber numberWithInteger:catId],
//                             POST_PARAMETER_TYPE:[NSNumber numberWithInteger:type],
//                             POST_PARAMETER_SUMMARY:summary,
//                             POST_PARAMETER_PRICE:[NSNumber numberWithFloat:price],
//                             POST_PARAMETER_RATEID:[NSNumber numberWithInteger:rateId],
//                             POST_PARAMETER_SUBID1:[NSNumber numberWithInteger:subId1],
//                             POST_PARAMETER_SUBMONTH:[NSNumber numberWithInteger:subMonth],
//                             POST_PARAMETER_SUBPRICE:[NSNumber numberWithFloat:subPrice],
//                             POST_PARAMETER_SUBTOTAL:[NSNumber numberWithFloat:subTotal],
//                             POST_PARAMETER_SUBTYPE:[NSNumber numberWithInteger:subType],
//                             POST_PARAMETER_STATUS1:[NSNumber numberWithInteger:status1],
//                             POST_PARAMETER_SUBID3:[NSNumber numberWithInteger:subId3],
//                             POST_PARAMETER_PHOTO_MONTH:[NSNumber numberWithInteger:photoMonth],
//                             POST_PARAMETER_PHOTO_PRICE:[NSNumber numberWithFloat:photoPrice],
//                             POST_PARAMETER_PHOTO_TOTAL:[NSNumber numberWithFloat:photoTocal],
//                             POST_PARAMETER_PHOTO_TYPE:[NSNumber numberWithInteger:photoType],
//                             POST_PARAMETER_STATUS3:[NSNumber numberWithInteger:status3],
//                             POST_PARAMETER_SUBID4:[NSNumber numberWithInteger:subId4],
//                             POST_PARAMETER_VIDEO_MONTH:[NSNumber numberWithInteger:videoMonth],
//                             POST_PARAMETER_VIDEO_PRICE:[NSNumber numberWithFloat:videoPrice],
//                             POST_PARAMETER_VIDEO_TOTAL:[NSNumber numberWithFloat:videoTotal],
//                             POST_PARAMETER_VIDEO_TYPE:[NSNumber numberWithInteger:videoType],
//                             POST_PARAMETER_STATUS4:[NSNumber numberWithInteger:status4],
//                             POST_PARAMETER_SUBID2:[NSNumber numberWithInteger:subId2],
//                             POST_PARAMETER_EXTRA_MONTH:[NSNumber numberWithInteger:extraMonth],
//                             POST_PARAMETER_EXTRA_PRICE:[NSNumber numberWithFloat:extraPrice],
//                             POST_PARAMETER_EXTEND_TOTAL:[NSNumber numberWithFloat:extendTotal],
//                             POST_PARAMETER_EXTRA_TOTAL:[NSNumber numberWithFloat:extendTotal],
//                             POST_PARAMETER_STATUS2:[NSNumber numberWithInteger:status2]};
//    
//                             
//    [self requestData:DATA_URL_CREATE_UPDATE_SUB_PLAN withParameters:params completion:completion];
//    
//}

+ (void)createUpdateSubPlan:(NSString *)stkid skillId:(NSInteger)skillId name:(NSString *)name description:(NSString *)description catId:(NSInteger)catId type:(NSInteger)type summary:(NSString *)summary price:(NSDecimalNumber *)price rateId:(NSInteger)rateId subId1:(NSInteger)subId1 subMonth:(NSInteger)subMonth subPrice:(NSDecimalNumber *)subPrice subTotal:(NSDecimalNumber *)subTotal subType:(NSInteger)subType status1:(NSInteger)status1 subId3:(NSInteger)subId3 photoMonth:(NSInteger)photoMonth photoPrice:(NSDecimalNumber *)photoPrice photoTotal:(NSDecimalNumber *)photoTotal photoType:(NSInteger)photoType status3:(NSInteger)status3 subId4:(NSInteger)subId4 videoMonth:(NSInteger)videoMonth videoPrice:(NSDecimalNumber *)videoPrice videoTotal:(NSDecimalNumber *)videoTotal videoType:(NSInteger)videoType status4:(NSInteger)status4 subId5:(NSInteger)subId5 extendMonth:(NSInteger)extendMonth extendPrice:(NSDecimalNumber *)extendPrice extendTotal:(NSDecimalNumber *)extendTotal extendType:(NSInteger)extendType status5:(NSInteger)status5 subId2:(NSInteger)subId2 extraMonth:(NSInteger)extraMonth extraPrice:(NSDecimalNumber *)extraPrice extraTotal:(NSDecimalNumber *)extraTotal extraType:(NSInteger)extraType status2:(NSInteger)status2 completion:(void (^)(NSObject *, NSError *))completion
{
    
    NSDictionary *params = @{POST_PARAMETER_STKID:stkid,
                             POST_PARAMETER_SKILL_ID:[NSNumber numberWithInteger:skillId],
                             POST_PARAMETER_NAME:name,
                             POST_PARAMETER_DESCRIPTION:description,
                             POST_PARAMETER_CATEGORY_ID:[NSNumber numberWithInteger:catId],
                             POST_PARAMETER_TYPE:[NSNumber numberWithInteger:type],
                             POST_PARAMETER_SUMMARY:summary,
                             POST_PARAMETER_PRICE:price,
                             POST_PARAMETER_RATEID:[NSNumber numberWithInteger:rateId],
                             POST_PARAMETER_SUBID1:[NSNumber numberWithInteger:subId1],
                             POST_PARAMETER_SUBMONTH:[NSNumber numberWithInteger:subMonth],
                             POST_PARAMETER_SUBPRICE:subPrice,
                             POST_PARAMETER_SUBTOTAL:subTotal,
                             POST_PARAMETER_SUBTYPE:[NSNumber numberWithInteger:subType],
                             POST_PARAMETER_STATUS1:[NSNumber numberWithInteger:status1],
                             POST_PARAMETER_SUBID3:[NSNumber numberWithInteger:subId3],
                             POST_PARAMETER_PHOTO_MONTH:[NSNumber numberWithInteger:photoMonth],
                             POST_PARAMETER_PHOTO_PRICE:photoPrice,
                             POST_PARAMETER_PHOTO_TOTAL:photoTotal,
                             POST_PARAMETER_PHOTO_TYPE:[NSNumber numberWithInteger:photoType],
                             POST_PARAMETER_STATUS3:[NSNumber numberWithInteger:status3],
                             POST_PARAMETER_SUBID4:[NSNumber numberWithInteger:subId4],
                             POST_PARAMETER_VIDEO_MONTH:[NSNumber numberWithInteger:videoMonth],
                             POST_PARAMETER_VIDEO_PRICE:videoPrice,
                             POST_PARAMETER_VIDEO_TOTAL:videoTotal,
                             POST_PARAMETER_VIDEO_TYPE:[NSNumber numberWithInteger:videoType],
                             POST_PARAMETER_STATUS4:[NSNumber numberWithInteger:status4],
                             POST_PARAMETER_SUBID5:[NSNumber numberWithInteger:subId5],
                             POST_PARAMETER_EXTEND_MONTH:[NSNumber numberWithInteger:extendMonth],
                             POST_PARAMETER_EXTEND_PRICE:extendPrice,
                             POST_PARAMETER_EXTEND_TOTAL:extendTotal,
                             POST_PARAMETER_EXTEND_TYPE:[NSNumber numberWithInteger:extendType],
                             POST_PARAMETER_STATUS5:[NSNumber numberWithInteger:status5],
                             POST_PARAMETER_SUBID2:[NSNumber numberWithInteger:subId2],
                             POST_PARAMETER_EXTRA_MONTH:[NSNumber numberWithInteger:extraMonth],
                             POST_PARAMETER_EXTRA_PRICE:extraPrice,
                             POST_PARAMETER_EXTEND_TOTAL:extendTotal,
                             POST_PARAMETER_EXTRA_TYPE:[NSNumber numberWithInteger:extraType],
                             POST_PARAMETER_STATUS2:[NSNumber numberWithInteger:status2]};
    
    
    [self requestData:DATA_URL_CREATE_UPDATE_SUB_PLAN withParameters:params completion:completion];
    
    
    
    
}

+ (void)getSubscriptionPlan:(NSInteger)status completion:(void (^)(NSObject *, NSError *))completion
{
    NSDictionary *params = @{POST_PARAMETER_STATUS:[NSNumber numberWithInteger:status]};
    [self requestData:DATA_URL_GET_SUBSCRIPTION_PLAN withParameters:params completion:completion];
}


+ (void)editComment:(NSInteger)commentId rating:(NSInteger)rating review:(NSString *)review stkid:(NSString *)stkid completion:(void (^)(NSObject *, NSError *))completion
{
    NSDictionary *params = @{POST_PARAMETER_COMMENT_ID:[NSNumber numberWithInteger:commentId],
                             POST_PARAMETER_RATE:[NSNumber numberWithInteger:rating],
                             POST_PARAMETER_REVIEW:review,
                             POST_PARAMETER_STKID:stkid};
    
    [self requestData:DATA_URL_EDIT_COMMENT withParameters:params completion:completion];
}


+ (void)updateProfile:(NSString *)stkid fname:(NSString *)fname lname:(NSString *)lname description:(NSString *)description dob:(NSString *)dob address:(NSString *)address countryISO:(NSString *)countryISO postalcode:(NSString *)postalcode completion:(void (^)(NSObject *, NSError *))completion
{
    NSDictionary *params = @{POST_PARAMETER_STKID:stkid,
                             POST_PARAMETER_F_NAME:fname,
                             POST_PARAMETER_L_NALE:lname,
                             POST_PARAMETER_DESCRIPTION:description,
                             POST_PARAMETER_DOB:dob,
                             POST_PARAMETER_ADDRESS:address,
                             POST_PARAMETER_COUNTRY:countryISO,
                             POST_PARAMETER_POSTAL_CODE:postalcode};
    
    [self requestData:DATA_URL_UPDATE_PROFILE withParameters:params completion:completion];
                             
}

+ (void)updateSubSkillStatus:(NSInteger)skillId duration:(NSInteger)duration completion:(void (^)(NSObject *, NSError *))completion
{
    NSDictionary *params = @{POST_PARAMETER_SKILL_ID:[NSNumber numberWithInteger:skillId],
                             POST_PARAMETER_DURATION:[NSNumber numberWithInteger:duration]};
    [self requestData:DATA_URL_UPDATE_SUBSKILL_STATUS withParameters:params completion:completion];
}


+ (void)deleteSell:(NSInteger)skillId completion:(void (^)(NSObject *, NSError *))completion
{
    NSDictionary *params = @{POST_PARAMETER_SKILL_ID:[NSNumber numberWithInteger:skillId]};
    [self requestData:DATA_URL_DELETE_SELL withParameters:params completion:completion];
}

+ (void)saveReview:(NSString *)reviewId skillId:(NSString *)skillId viewCount:(NSString *)viewCount likeCount:(NSString *)likeCount owner:(NSString *)owner actionMaker:(NSString *)actionMaker completion:(void (^)(NSObject *, NSError *))completion
{
    NSDictionary *params = @{POST_PARAMETER_REVIEW_ID:reviewId,
                             POST_PARAMETER_SKILL_ID:skillId,
                             POST_PARAMETER_VIEW_COUNT:viewCount,
                             POST_PARAMETER_LIKE_COUNT:likeCount,
                             POST_PARAMETER_OWNER:owner,
                             POST_PARAMETER_ACTION_MAKER:actionMaker};
    [self requestData:DATA_URL_SAVE_REVIEW withParameters:params completion:completion];
}

+ (void)deleteBuyerPost:(NSInteger)buyerId stkid:(NSString *)stkid limit:(NSInteger)limit completion:(void (^)(NSObject *, NSError *))completion
{
    NSDictionary *params = @{POST_PARAMETER_BUYERID:[NSNumber numberWithInteger:buyerId],
                             POST_PARAMETER_STKID:stkid,
                             POST_PARAMETER_LIMIT:[NSNumber numberWithInteger:limit]};
    [self requestData:DATA_URL_DELETE_BUYER_POST withParameters:params completion:completion];
}


+ (void)saveBuyerMarket:(NSString *)stkid type:(NSInteger)type name:(NSString *)name description:(NSString *)description respons:(NSString *)respons active:(NSInteger)active catId:(NSInteger)catId jobType:(NSInteger)jobType personType:(NSInteger)personType availability:(NSInteger)availability startTime:(NSString *)startTime endTime:(NSString *)endTime price:(NSDecimalNumber *)price rateId:(NSInteger)rateId completion:(void (^)(NSObject *, NSError *))completion
{
    NSDictionary *params = @{POST_PARAMETER_STKID:stkid,
                             POST_PARAMETER_TYPE:[NSNumber numberWithInteger:type],
                             POST_PARAMETER_NAME:name,
                             POST_PARAMETER_DESCRIPTION:description,
                             POST_PARAMETER_RESPONS:respons,
                             POST_PARAMETER_ACTIVE:[NSNumber numberWithInteger:active],
                             POST_PARAMETER_CATEGORY_ID:[NSNumber numberWithInteger:catId],
                             POST_PARAMETER_JOB_TYPE:[NSNumber numberWithInteger:jobType],
                             POST_PARAMETER_PERSON_TYPE:[NSNumber numberWithInteger:personType],
                             POST_PARAMETER_AVAILABILITY:[NSNumber numberWithInteger:availability],
                             POST_PARAMETER_START_TIME:startTime,
                             POST_PARAMETER_END_TIME:endTime,
                             POST_PARAMETER_PRICE:price,
                             POST_PARAMETER_RATEID:[NSNumber numberWithInteger:rateId]};
    
    
    [self requestData:DATA_URL_SAVE_BUYER_MARKET withParameters:params completion:completion];
}


+ (void)insertContact:(NSString *)stkid contactId:(NSString *)contactId completion:(void (^)(NSObject *, NSError *))completion
{
    NSDictionary *params = @{POST_PARAMETER_STKID:stkid,
                             POST_PARAMETER_CONTACT_ID:contactId};
    [self requestData:DATA_URL_INSERT_CONTACT withParameters:params completion:completion];
    
}

+ (void)saveEducation:(NSString *)stkid institute:(NSString *)institute countryISO:(NSString *)countryISO qualification:(NSString *)qualification fromDate:(NSString *)fromDate toDate:(NSString *)toDate otherInfo:(NSString *)otherInfo completion:(void (^)(NSObject *, NSError *))completion
{
    NSDictionary *params = @{POST_PARAMETER_STKID:stkid,
                             POST_PARAMETER_INSTITUTE:institute,
                             POST_PARAMETER_COUNTRY:countryISO,
                             POST_PARAMETER_QUALIFICATION:qualification,
                             POST_PARAMETER_FROM_DATE:fromDate,
                             POST_PARAMETER_TO_DATE:toDate,
                             POST_PARAMETER_OTHER_INFO:otherInfo};
    [self requestData:DATA_URL_SAVE_EDUCATION withParameters:params completion:completion];
}

+ (void)updateEducation:(NSInteger)eduid stkid:(NSString *)stkid institute:(NSString *)institute countryISO:(NSString *)countryISO qualification:(NSString *)qualification fromDate:(NSString *)fromDate toDate:(NSString *)toDate otherInfo:(NSString *)otherInfo completion:(void (^)(NSObject *, NSError *))completion
{
    NSDictionary *params = @{POST_PARAMETER_ID:[NSNumber numberWithInteger:eduid],
                             POST_PARAMETER_STKID:stkid,
                             POST_PARAMETER_INSTITUTE:institute,
                             POST_PARAMETER_COUNTRY:countryISO,
                             POST_PARAMETER_QUALIFICATION:qualification,
                             POST_PARAMETER_FROM_DATE:fromDate,
                             POST_PARAMETER_TO_DATE:toDate,
                             POST_PARAMETER_OTHER_INFO:otherInfo};
    [self requestData:DATA_URL_UPDATE_EDUCATION withParameters:params completion:completion];

}

+ (void)deleteEducation:(NSInteger)eduid completion:(void (^)(NSObject *, NSError *))completion
{
    NSDictionary *params = @{POST_PARAMETER_ID:[NSNumber numberWithInteger:eduid]};
    [self requestData:DATA_URL_DELETE_EDUCATION withParameters:params completion:completion];
}

+ (void)saveJobHistory:(NSString *)stkid companyName:(NSString *)companyName countryISO:(NSString *)countryISO jobtitle:(NSString *)jobtitle fromDate:(NSString *)fromDate toDate:(NSString *)toDate otherInfo:(NSString *)otherInfo completion:(void (^)(NSObject *, NSError *))completion;
{
    NSDictionary *params = @{POST_PARAMETER_STKID:stkid,
                             POST_PARAMETER_COMPANY_NAME:companyName,
                             POST_PARAMETER_COUNTRY:countryISO,
                             POST_PARAMETER_JOB_TITILE:jobtitle,
                             POST_PARAMETER_FROM_DATE:fromDate,
                             POST_PARAMETER_TO_DATE:toDate,
                             POST_PARAMETER_OTHER_INFO:otherInfo};
    [self requestData:DATA_URL_SAVE_JOB_HISTORY withParameters:params completion:completion];
                             
}

+ (void)updateJobHistory:(NSInteger)jobid stkid:(NSString *)stkid companyName:(NSString *)companyName countryISO:(NSString *)countryISO jobtitle:(NSString *)jobtitle fromDate:(NSString *)fromDate toDate:(NSString *)toDate otherInfo:(NSString *)otherInfo completion:(void (^)(NSObject *, NSError *))completion;
{
    NSDictionary *params = @{POST_PARAMETER_ID:[NSNumber numberWithInteger:jobid],
                             POST_PARAMETER_STKID:stkid,
                             POST_PARAMETER_COMPANY_NAME:companyName,
                             POST_PARAMETER_COUNTRY:countryISO,
                             POST_PARAMETER_JOB_TITILE:jobtitle,
                             POST_PARAMETER_FROM_DATE:fromDate,
                             POST_PARAMETER_TO_DATE:toDate,
                             POST_PARAMETER_OTHER_INFO:otherInfo};
    [self requestData:DATA_URL_UPDATE_JOB_HISTORY withParameters:params completion:completion];
}

+ (void)deleteJob:(NSInteger)jobid completion:(void (^)(NSObject *, NSError *))completion;
{
    NSDictionary *params = @{POST_PARAMETER_ID:[NSNumber numberWithInteger:jobid]};
    [self requestData:DATA_URL_DELETE_JOB withParameters:params completion:completion];
}


+ (void)updateToken:(NSString *)stkid token:(NSString *)token completion:(void (^)(NSObject *, NSError *))completion
{
    NSDictionary *params = @{POST_PARAMETER_STKID:stkid,
                             POST_PARAMETER_TOKEN:token};
    [self requestData:DATA_URL_UPDATE_TOKEN withParameters:params completion:completion];
}

+ (void)selectToken:(NSString *)stkid completion:(void (^)(NSObject *, NSError *))completion
{
    NSDictionary *params = @{POST_PARAMETER_STKID:stkid};
    [self requestData:DATA_URL_SELECT_TOKEN withParameters:params completion:completion];
}


+ (void)checkLastMessage:(NSString *)fromStikyBee completion:(void (^)(NSObject *, NSError *))completion
{
    NSDictionary *params = @{POST_PARAMETER_FROM_STIKY_BEE:fromStikyBee};
    [self requestData:DATA_URL_CHECK_LAST_MESSAGE withParameters:params completion:completion];
}


+ (void)selectChatMsgs:(NSString *)fromStikyBee toStikyBee:(NSString *)toStikyBee limit:(NSInteger)limit completion:(void (^)(NSObject *, NSError *))completion
{
    
    NSDictionary *params = @{POST_PARAMETER_FROM_STIKY_BEE:fromStikyBee,
                             POST_PARAMETER_TO_STIKY_BEE:toStikyBee,
                             POST_PARAMETER_LIMIT:[NSNumber numberWithInteger:limit]};
    [self requestData:DATA_URL_SELECT_CHAT_MSGS withParameters:params completion:completion];
    
}

+ (void)selectToken:(NSString *)senderId recipientId:(NSString *)recipientId completion:(void (^)(NSObject *, NSError *))completion
{
    NSDictionary *params = @{POST_PARAMETER_SENDER_ID:senderId,
                             POST_PARAMETER_RECIPIENT_ID:recipientId};
    [self requestData:DATA_URL_SELECT_TOKEN withParameters:params completion:completion];
}


+ (void)sendMessage:(NSString*)fileName msg:(NSString *)msg offerId:(NSInteger)offerId offerStatus:(NSInteger)offerStatus price:(NSString *)price rate:(NSString *)rate name:(NSString *)name message:(NSString *)message recipientStkid:(NSString *)recipientStikid chatRecipient:(NSString *)chatRecipient chatRecipientUrl:(NSString *)chatRecipientUrl senderToken:(NSString *)senderToken recipientToken:(NSString *)recipientToken completion:(void (^)(NSObject *, NSError *))completion
{
    NSDictionary *params = @{GOOGLE_PARAM_FILE_NAME:fileName,
                             GOOGLE_PARAM_MSG:msg,
                             GOOGLE_PARAM_OFFER_ID:[NSNumber numberWithInteger:offerId],
                             GOOGLE_PARAM_OFFER_STATUS:[NSNumber numberWithInteger:offerStatus],
                             GOOGLE_PARAM_PRICE:price,
                             GOOGLE_PARAM_RATE:rate,
                             GOOGLE_PARAM_NAME:name,
                             GOOGLE_PARAM_MESSAGE:message,
                             GOOGLE_PARAM_RECIPIENT_STKID:recipientStikid,
                             GOOGLE_PARAM_CHAT_RECIPIENT:chatRecipient,
                             GOOGLE_PARAM_CHAT_RECIPIENTURL:chatRecipientUrl,
                             GOOGLE_PARAM_SENDER_TOKEN:senderToken,
                             GOOGLE_PARAM_RECIPIENT_TOKEN:recipientToken};
//    [self requestData:GOOGLE_SERVICE_URL withParameters:params completion:completion];
    
    NSLog(@"google url ---- %@",GOOGLE_SERVICE_URL);
    NSLog(@"google reques param --- %@",params);
    [self requestGoogleData:GOOGLE_SERVICE_URL withParameters:params completion:completion];
}


+ (void)insertChatMsg:(NSString *)fromStikyBee toStikyBee:(NSString *)toStikyBee message:(NSString *)message createDate:(NSString *)createDate completion:(void (^)(NSObject *, NSError *))completion;
{
    NSDictionary *params = @{POST_PARAMETER_FROM_STIKY_BEE:fromStikyBee,
                             POST_PARAMETER_TO_STIKY_BEE:toStikyBee,
                             POST_PARAMETER_MESSAGE:message,
                             POST_PARAMETER_CREATE_DATE:createDate};
    
    [self requestData:DATA_URL_INSERT_CHAT_MSG withParameters:params completion:completion];
}

+ (void)checkLastMsg:(NSString *)fromStikyBee toStikyBee:(NSString *)toStikyBee message:(NSString *)message createDate:(NSString *)createDate completion:(void (^)(NSObject *, NSError *))completion
{
    NSDictionary *params = @{POST_PARAMETER_FROM_STIKY_BEE:fromStikyBee,
                             POST_PARAMETER_TO_STIKY_BEE:toStikyBee,
                             POST_PARAMETER_MESSAGE:message,
                             POST_PARAMETER_CREATE_DATE:createDate};
    
    [self requestData:DATA_URL_CHECK_LAST_MSG withParameters:params completion:completion];

}



+ (void)getSellAllMakeOffer:(NSInteger)limit catId:(NSInteger)catId stkid:(NSString *)stkid completion:(void (^)(NSObject *, NSError *))completion{
    
    NSDictionary *params = @{POST_PARAMETER_LIMIT:[NSNumber numberWithInteger:limit],
                             POST_PARAMETER_CATEGORY_ID:[NSNumber numberWithInteger:catId],
                             POST_PARAMETER_STKID:stkid};
    [self requestData:DATA_URL_GET_SELL_MARKET withParameters:params completion:completion];
    
}



+ (void)insertOffer:(NSString *)skillId price:(NSString *)price rate:(NSString *)rate status:(NSInteger)status fromStikyBee:(NSString *)fromStikyBee toStikyBee:(NSString *)toStikyBee message:(NSString *)message createDate:(NSString *)createDate completion:(void (^)(NSObject *, NSError *))completion
{
    NSDictionary *params = @{POST_PARAMETER_SKILL_ID:skillId,
                             POST_PARAMETER_PRICE:price,
                             GOOGLE_PARAM_RATE:rate,
                             POST_PARAMETER_STATUS:[NSNumber numberWithInteger:status],
                             POST_PARAMETER_FROM_STIKY_BEE:fromStikyBee,
                             POST_PARAMETER_TO_STIKY_BEE:toStikyBee,
                             POST_PARAMETER_MESSAGE:message,
                             POST_PARAMETER_CREATE_DATE:createDate};
    
    NSLog(@"params --- %@",params);
    
    [self requestData:DATA_URL_INSERT_OFFER withParameters:params completion:completion];
}















+ (void)fileRequestUpload:(UIImage *)profileImage stikyid:(NSString *)stikyid cpid:(NSInteger)cpid
{
    //change compression value to 0.0 from 1.0 so image might be under 1mb
    NSData *imageData =UIImageJPEGRepresentation(profileImage, 0.0);
    
    NSString *urlString = [NSString stringWithFormat:@"http://beta.stikyhive.com:81/androidstikyhive/filerequestupload.php?stkid=%@&cpId=%ld",stikyid,(long)cpid];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    // NSString *boundary = [NSString stringWithString:@"---------------------------14737809831466499882746641449"];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"uploaded_file\"; filename=\1\r\n"]] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    // [body appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
}

static NSOperationQueue *queue;
+ (void)uploadAudio:(NSData *)audioData stikyId:(NSString *)stikyId toStikyId:(NSString *)toStikyId completeHandler:(void (^)(NSString *data, NSError *error))handler{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    NSLog(@"send date time %@", dateString);
    
    NSString *urlString = [NSString stringWithFormat:@"http://beta.stikyhive.com:81/androidstikyhive/voicetransfer.php?fromStikyBee=%@&toStikyBee=%@&message=voice&dateTime=%@&url=http://beta.stikyhive.com:81",stikyId, toStikyId, dateString];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    // NSString *boundary = [NSString stringWithString:@"---------------------------14737809831466499882746641449"];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"uploaded_file\"; filename=\1\r\n"]] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    // [body appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:audioData];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    
    if(queue == nil){
        
        queue = [[NSOperationQueue alloc] init];
    }
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        if(handler != nil){
            
            handler([[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding], connectionError);
        }
    } ];
}

+ (void)sendPhoto:(UIImage *)image fromStikyBee:(NSString *)fromStikyBee toStikyBee:(NSString *)toStikyBee completeHandler:(void (^)(NSString *data, NSError *error))handler
{
    NSData *imageData =UIImageJPEGRepresentation(image, 0.0);
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    NSLog(@"send date time %@", dateString);
    
    NSString *urlString = [NSString stringWithFormat:@"http://beta.stikyhive.com:81/androidstikyhive/filetransfer.php?fromStikyBee=%@&toStikyBee=%@&message=photo&extension=png&type=image&dateTime=%@&url=http://beta.stikyhive.com:81",fromStikyBee, toStikyBee, dateString];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    // NSString *boundary = [NSString stringWithString:@"---------------------------14737809831466499882746641449"];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"uploaded_file\"; filename=\1\r\n"]] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    // [body appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    
    if(queue == nil){
        
        queue = [[NSOperationQueue alloc] init];
    }
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        if(handler != nil){
            
            handler([[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding], connectionError);
        }
    } ];
    
}




+ (void)profileImageUpload:(UIImage *)profileImage stikyid:(NSString *)stikyid
{
    NSData *imageData =UIImageJPEGRepresentation(profileImage, 0.0);
    
    NSString *urlString = [NSString stringWithFormat:@"http://beta.stikyhive.com:81/androidstikyhive/fileupload.php?id=%@",stikyid];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    // NSString *boundary = [NSString stringWithString:@"---------------------------14737809831466499882746641449"];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"uploaded_file\"; filename=\1\r\n"]] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    // [body appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];

}

+ (void)skillImageUpload:(UIImage *)image stikyid:(NSString *)stikyid skillId:(NSInteger)skillId type:(NSInteger)type editFlage:(BOOL)editFlage photoId:(NSInteger)photoId caption:(NSString *)caption
{
    
        NSString *encodeCaption = [caption stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
        NSData *imageData =UIImageJPEGRepresentation(image, 1.0);

        NSString *urlString = [NSString stringWithFormat:@"http://beta.stikyhive.com:81/androidstikyhive/photoupload.php?stkid=%@&skillId=%ld&type=%ld&editFlag=%d&photoId=%ld&caption=%@",stikyid,(long)skillId,(long)type,editFlage,(long)photoId,encodeCaption];
    
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:urlString]];
        [request setHTTPMethod:@"POST"];
    
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
        NSMutableData *body = [NSMutableData data];
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"uploaded_file\"; filename=\1\r\n"]] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//         [body appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:imageData]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [request setHTTPBody:body];
    
    
        [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        
    
    
}


+ (void)skillImageUploadTest:(UIImage *)image stikyid:(NSString *)stikyid type:(NSInteger)type editFlage:(BOOL)editFlage photoId:(NSInteger)photoId caption:(NSString *)caption
{
    NSString *encodeCaption = [caption stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSData *imageData =UIImageJPEGRepresentation(image, 1.0);
    
    NSString *urlString = [NSString stringWithFormat:@"http://beta.stikyhive.com:81/androidstikyhive/photoupload.php?stkid=%@&type=%ld&editFlag=%d&photoId=%ld&caption=%@",stikyid,(long)type,editFlage,(long)photoId,encodeCaption];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"uploaded_file\"; filename=\1\r\n"]] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    //         [body appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
 
    
}




//+ (void)saveStikyBee:(NSString *)email password:(NSString *)password firstname:(NSString *)firstname lastname:(NSString *)lastname dob:(NSString *)dob address:(NSString *)address country:(NSString *)countryISO postalcode:(NSString *)postalcode skillname:(NSString *)skillname1 skillid1:(NSInteger)skillid1 skilltype1:(NSInteger)skilltype1 talentname:(NSString *)talentname1 talentid:(NSInteger)talentid1 talenttype:(NSInteger)talenttype1 completion:(void (^)(NSObject *, NSError *))completion
//{
//    NSDictionary *params = @{POST_PARAMETER_EMAIL:email,
//                             POST_PARAMETER_PASSWORD:password,
//                             POST_PARAMETER_FILENAME:firstname,
//                             POST_PARAMETER_LASTNAME:lastname,
//                             POST_PARAMETER_DOB:dob,
//                             POST_PARAMETER_ADDRESS:address,
//                             POST_PARAMETER_COUNTRY:countryISO,
//                             POST_PARAMETER_POSTAL_CODE:postalcode,
//                             POST_PARAMETER_SKILLNAME:skillname1,
//                             POST_PARAMETER_SKILLID:[NSNumber numberWithInteger:skillid1],
//                             POST_PARAMETER_SKILLTYPE:[NSNumber numberWithInteger:skilltype1],
//                             POST_PARAMETER_TALENTNAME:talentname1,
//                             POST_PARAMETER_TALENTID:[NSNumber numberWithInteger:talentid1],
//                             POST_PARAMETER_TALENTTYPE:[NSNumber numberWithInteger:talenttype1]};
//    
//    
//    [self requestData:DATA_URL_USER_SAVEPROFILE withParameters:params completion:completion];
//
//}

////////////////////////// End ///////////////////// -------------------------------------------------

+ (void)getInitialDataWithcompletion:(void (^)(NSObject *, NSError *))completion
{
    [self requestData:DATA_URL_INITIAL_DATA withParameters:nil completion:completion];
}

//+ (void)signupWithUsername:(NSString *)username password1:(NSString *)password1 password2:(NSString *)password2
//               deviceToken:(NSString *)dToken completion:(void (^)(NSObject *, NSError *))completion
//{
//    NSDictionary *params = @{POST_PARAMETER_USERNAME:username,
//                             POST_PARAMETER_PASSWORD_1:password1,
//                             POST_PARAMETER_PASSWORD_2:password2,
//                             POST_PARAMETER_DEVICE_TOKEN:dToken};
//    [self requestData:DATA_URL_USER_SIGNUP withParameters:params completion:completion];
//}

//+ (void)verifyUsername:(NSString *)username hashcode:(NSString *)code completion:(void (^)(NSObject *, NSError *))completion
//{
//    NSDictionary *params = @{POST_PARAMETER_USERNAME:username,
//                             POST_PARAMETER_HASHCODE:code};
//    [self requestData:DATA_URL_USER_VERIFY withParameters:params completion:completion];
//}

//+ (void)loginWithUsername:(NSString *)username password:(NSString *)password
//              deviceToken:(NSString *)dToken completion:(void (^)(NSObject *, NSError *))completion
//{
//    NSDictionary *params = @{POST_PARAMETER_USERNAME:username,
//                             POST_PARAMETER_PASSWORD:password,
//                             POST_PARAMETER_DEVICE_TOKEN:dToken};
//    
//    [self requestData:DATA_URL_USER_LOGIN withParameters:params completion:completion];
//}

+ (void)createDocumentForUser:(NSString *)userID name:(NSString *)name
                       docLoc:(NSString *)docLoc docData:(NSData *) docData
                   completion:(void (^)(NSObject *, NSError *))completion
{
    
}

+ (void)getDocumentWithID:(NSInteger)docID completion:(void (^)(NSObject *, NSError *))completion
{
    NSNumber *docNum = [NSNumber numberWithInteger:docID];
    [self requestData:DATA_URL_DOCUMENT_WITH_ID withParameters:@{@"id":docNum} completion:completion];
}

+ (void)getAllDocumentsForUser:(NSString *)userID completion:(void (^)(NSObject *, NSError *))completion
{
    NSDictionary *params = @{POST_PARAMETER_STKID:userID};
    [self requestData:DATA_URL_USER_DOCUMENTS withParameters:params completion:completion];
}


/////////////////////////////// Echo ///////////////////////////////////////////////////////////

+ (void)updateImageProfile:(NSString *)stikyid completion:(void (^)(NSObject *, NSError *))completion {
    
}

////////////////////

+ (void)updateProfileForUser:(NSString *)userID password:(NSString *)password
                   firstname:(NSString *)firstname lastname:(NSString *)lastname
                   dobString:(NSString *)dobString desc:(NSString *)desc
                    address1:(NSString *)address1 address2:(NSString *)address2
                  postalCode:(NSString *)postalCode country:(NSString *)country
                    photoLoc:(NSString *)photoLoc photoData:(NSData *) photoData
                  completion:(void (^)(NSObject *, NSError *))completion
{
    NSMutableDictionary *params = @{POST_PARAMETER_STKID:userID,
                                    POST_PARAMETER_PASSWORD:password,
                                    POST_PARAMETER_FIRSTNAME:firstname,
                                    POST_PARAMETER_LASTNAME:lastname,
                                    POST_PARAMETER_DOB:dobString,
                                    POST_PARAMETER_USER_DESC:desc,
                                    POST_PARAMETER_ADDRESS_1:address1,
                                    POST_PARAMETER_ADDRESS_2:address2,
                                    POST_PARAMETER_POSTAL_CODE:postalCode,
                                    POST_PARAMETER_USER_COUNTRY:country}.mutableCopy;
    
    if (photoLoc && photoData)
    {
        [self uploadFile:photoLoc withData:photoData toURL:DATA_URL_UPLOAD_PROFILE_PIC
                 forUser:userID completion:^(NSObject *obj, NSError *err)
         {
             NSString *fileLoc = (NSString *)obj;
             [params setObject:fileLoc forKey:POST_PARAMETER_PROFILE_PICTURE];
             [self requestData:DATA_URL_USER_UPDATE withParameters:params completion:completion];
         }];
    }
    else
    {
        [self requestData:DATA_URL_USER_UPDATE withParameters:params completion:completion];
    }
}

+ (void)updateUserStatus:(NSString *)userID password:(NSString *)password status:(NSInteger)status
              completion:(void (^)(NSObject *, NSError *))completion
{
    NSDictionary *params = @{POST_PARAMETER_STKID:userID,
                             POST_PARAMETER_PASSWORD:password,
                             POST_PARAMETER_STATUS:[NSNumber numberWithInteger:status]};
    
    [self requestData:DATA_URL_USER_UPDATE_STATUS withParameters:params completion:completion];
}

+ (void)createEducationForUser:(NSString *)userID institute:(NSString *)institute
                       country:(NSString *)countryISO qualification:(NSString *)quali addInfo:(NSString *)info
                      fromDate:(NSString *)fromYYYYMMDD toDate:(NSString *)toYYYYMMDD
                    completion:(void (^)(NSObject *, NSError *))completion
{
    NSDictionary *params = @{POST_PARAMETER_EDUCATION_STIKY_ID:userID,
                             POST_PARAMETER_EDUCATION_INSTITUTE:institute,
                             POST_PARAMETER_EDUCATION_COUNTRY:countryISO,
                             POST_PARAMETER_EDUCATION_QUALIFICATION:quali,
                             POST_PARAMETER_EDUCATION_FROM_DATE:fromYYYYMMDD,
                             POST_PARAMETER_EDUCATION_ADD_INFO:info};
    
    if (toYYYYMMDD)
        params = @{POST_PARAMETER_EDUCATION_STIKY_ID:userID,
                   POST_PARAMETER_EDUCATION_INSTITUTE:institute,
                   POST_PARAMETER_EDUCATION_COUNTRY:countryISO,
                   POST_PARAMETER_EDUCATION_QUALIFICATION:quali,
                   POST_PARAMETER_EDUCATION_FROM_DATE:fromYYYYMMDD,
                   POST_PARAMETER_EDUCATION_TO_DATE:toYYYYMMDD,
                   POST_PARAMETER_EDUCATION_ADD_INFO:info};

    [self requestData:DATA_URL_CREATE_EDUCATION withParameters:params completion:completion];
}

+ (void)updateEducation:(NSInteger)eduID institute:(NSString *)institute
                country:(NSString *)countryISO qualification:(NSString *)quali addInfo:(NSString *)info
               fromDate:(NSString *)fromYYYYMMDD toDate:(NSString *)toYYYYMMDD
             completion:(void (^)(NSObject *, NSError *))completion
{
    NSDictionary *params = @{POST_PARAMETER_EDUCATION_ID:[NSNumber numberWithInteger:eduID],
                             POST_PARAMETER_EDUCATION_INSTITUTE:institute,
                             POST_PARAMETER_EDUCATION_COUNTRY:countryISO,
                             POST_PARAMETER_EDUCATION_QUALIFICATION:quali,
                             POST_PARAMETER_EDUCATION_FROM_DATE:fromYYYYMMDD,
                             POST_PARAMETER_EDUCATION_ADD_INFO:info};

    if (toYYYYMMDD)
        params = @{POST_PARAMETER_EDUCATION_ID:[NSNumber numberWithInteger:eduID],
                   POST_PARAMETER_EDUCATION_INSTITUTE:institute,
                   POST_PARAMETER_EDUCATION_COUNTRY:countryISO,
                   POST_PARAMETER_EDUCATION_QUALIFICATION:quali,
                   POST_PARAMETER_EDUCATION_FROM_DATE:fromYYYYMMDD,
                   POST_PARAMETER_EDUCATION_TO_DATE:toYYYYMMDD,
                   POST_PARAMETER_EDUCATION_ADD_INFO:info};

    [self requestData:DATA_URL_UPDATE_EDUCATION withParameters:params completion:completion];
}

+ (void)getEducationForUser:(NSString *)stkid completion:(void (^)(NSObject *, NSError *))completion
{
    NSDictionary *params = @{POST_PARAMETER_EDUCATION_STIKY_ID:stkid};
    [self requestData:DATA_URL_EDUCATIONS_FOR_USER withParameters:params completion:completion];
}

+ (void)getEducationOfID:(NSInteger)eduID completion:(void (^)(NSObject *, NSError *))completion
{
    NSDictionary *params = @{POST_PARAMETER_EDUCATION_ID:[NSNumber numberWithInteger:eduID]};
    [self requestData:DATA_URL_EDUCATION_OF_ID withParameters:params completion:completion];
}

+ (void)createJobHistoryForUser:(NSString *)userID companyName:(NSString *)companyName
                        country:(NSString *)countryISO jobTitle:(NSString *)title addInfo:(NSString *)info
                       fromDate:(NSString *)fromYYYYMMDD toDate:(NSString *)toYYYYMMDD
                     completion:(void (^)(NSObject *, NSError *))completion
{
    NSDictionary *params = @{POST_PARAMETER_JOB_HISTORY_STIKY_ID:userID,
                             POST_PARAMETER_JOB_HISTORY_COMPANY_NAME:companyName,
                             POST_PARAMETER_JOB_HISTORY_COUNTRY:countryISO,
                             POST_PARAMETER_JOB_HISTORY_JOB_TITLE:title,
                             POST_PARAMETER_JOB_HISTORY_FROM_DATE:fromYYYYMMDD,
                             POST_PARAMETER_JOB_HISTORY_ADD_INFO:info};
    
    if (toYYYYMMDD)
        params = @{POST_PARAMETER_JOB_HISTORY_STIKY_ID:userID,
                   POST_PARAMETER_JOB_HISTORY_COMPANY_NAME:companyName,
                   POST_PARAMETER_JOB_HISTORY_COUNTRY:countryISO,
                   POST_PARAMETER_JOB_HISTORY_JOB_TITLE:title,
                   POST_PARAMETER_JOB_HISTORY_FROM_DATE:fromYYYYMMDD,
                   POST_PARAMETER_JOB_HISTORY_TO_DATE:toYYYYMMDD,
                   POST_PARAMETER_JOB_HISTORY_ADD_INFO:info};

    [self requestData:DATA_URL_CREATE_JOB_HISTORY withParameters:params completion:completion];
}

//+ (void)updateJobHistory:(NSInteger)jobID companyName:(NSString *)companyName
//                 country:(NSString *)countryISO jobTitle:(NSString *)title addInfo:(NSString *)info
//                fromDate:(NSString *)fromYYYYMMDD toDate:(NSString *)toYYYYMMDD
//              completion:(void (^)(NSObject *, NSError *))completion
//{
//    NSDictionary *params = @{POST_PARAMETER_JOB_HISTORY_ID:[NSNumber numberWithInteger:jobID],
//                             POST_PARAMETER_JOB_HISTORY_COMPANY_NAME:companyName,
//                             POST_PARAMETER_JOB_HISTORY_COUNTRY:countryISO,
//                             POST_PARAMETER_JOB_HISTORY_JOB_TITLE:title,
//                             POST_PARAMETER_JOB_HISTORY_FROM_DATE:fromYYYYMMDD,
//                             POST_PARAMETER_JOB_HISTORY_ADD_INFO:info};
//
//    if (toYYYYMMDD)
//        params = @{POST_PARAMETER_JOB_HISTORY_ID:[NSNumber numberWithInteger:jobID],
//                   POST_PARAMETER_JOB_HISTORY_COMPANY_NAME:companyName,
//                   POST_PARAMETER_JOB_HISTORY_COUNTRY:countryISO,
//                   POST_PARAMETER_JOB_HISTORY_JOB_TITLE:title,
//                   POST_PARAMETER_JOB_HISTORY_FROM_DATE:fromYYYYMMDD,
//                   POST_PARAMETER_JOB_HISTORY_TO_DATE:toYYYYMMDD,
//                   POST_PARAMETER_JOB_HISTORY_ADD_INFO:info};
//
//    [self requestData:DATA_URL_UPDATE_JOB_HISTORY withParameters:params completion:completion];
//}

+ (void)getJobHistoryForUser:(NSString *)stkid completion:(void (^)(NSObject *, NSError *))completion
{
    NSDictionary *params = @{POST_PARAMETER_JOB_HISTORY_STIKY_ID:stkid};
    [self requestData:DATA_URL_JOB_HISTORIES_FOR_USER withParameters:params completion:completion];
}

+ (void)getJobHistoryOfID:(NSInteger)jobID completion:(void (^)(NSObject *, NSError *))completion
{
    NSDictionary *params = @{POST_PARAMETER_JOB_HISTORY_ID:[NSNumber numberWithInteger:jobID]};
    [self requestData:DATA_URL_JOB_HISTORY_OF_ID withParameters:params completion:completion];
}

+ (void)createSkillForUser:(NSString *)userID skillType:(NSInteger)skillType catID:(NSInteger)catID
                 skillName:(NSString *)skillName skillDesc:(NSString *)skillDesc
                completion:(void (^)(NSObject *, NSError *))completion
{
    NSDictionary *params = @{POST_PARAMETER_STKID:userID,
                             @"type":[NSNumber numberWithInteger:skillType],
                             @"catId":[NSNumber numberWithInteger:catID],
                             @"name":skillName,
                             @"description":skillDesc};
    [self requestData:DATA_URL_SKILL_CREATE withParameters:params completion:completion];
}

+ (void)updateSkill:(NSInteger)skillID skillType:(NSInteger)skillType catID:(NSInteger)catID
          skillName:(NSString *)skillName skillDesc:(NSString *)skillDesc
         completion:(void (^)(NSObject *, NSError *))completion
{
    NSDictionary *params = @{@"id":[NSNumber numberWithInteger:skillID],
                             @"type":[NSNumber numberWithInteger:skillType],
                             @"catId":[NSNumber numberWithInteger:catID],
                             @"name":skillName,
                             @"description":skillDesc};
    [self requestData:DATA_URL_SKILL_UPDATE withParameters:params completion:completion];
}

+ (void)createVideoForSkill:(NSInteger)skillID videoFile:(NSString *)videoFile
                  videoData:(NSData *)videoData thumbFile:(NSString *)thumbFile
                  thumbData:(NSData *)thumbData ofUser:(NSString *)userID
                completion:(void (^)(NSObject *, NSError *))completion
{
    [self uploadFile:thumbFile withData:thumbData toURL:DATA_URL_UPLOAD_SKILL_VIDEO forUser:userID completion:^(NSObject *obj, NSError *err)
     {
         NSString *thumbLoc = (NSString *)obj;
         
         [self uploadFile:videoFile withData:videoData toURL:DATA_URL_UPLOAD_SKILL_VIDEO forUser:userID completion:^(NSObject *obj, NSError *err)
         {
              NSString *videoLoc = (NSString *)obj;
              NSNumber *skillNum = [NSNumber numberWithInteger:skillID];
              NSDictionary *params = @{@"linkId":skillNum,@"location":videoLoc,@"thumbnailLocation":thumbLoc,@"type":@1};
              [self requestData:DATA_URL_CREATE_VIDEO withParameters:params completion:completion];
         }];
     }];
}

+ (void)updateVideoForSkill:(NSInteger)skillID videoFile:(NSString *)videoFile videoData:(NSData *)videoData
                  thumbFile:(NSString *)thumbFile thumbData:(NSData *)thumbData ofUser:(NSString *)userID
                 completion:(void (^)(NSObject *, NSError *))completion
{
    NSNumber *skillNum = [NSNumber numberWithInteger:skillID];
    NSDictionary *params = @{@"linkId":skillNum};
    [self requestData:DATA_URL_REMOVE_VIDEO withParameters:params completion:^(NSObject *obj, NSError *err)
    {
        [self createVideoForSkill:skillID videoFile:videoFile videoData:videoData
                        thumbFile:thumbFile thumbData:thumbData ofUser:userID completion:completion];
    }];
}

+ (void)createPhotoForSkill:(NSInteger)skillID photoFile:(NSString *)photoFile photoData:(NSData *)photoData
                     ofUser:(NSString *)userID completion:(void (^)(NSObject *, NSError *))completion
{
    [self uploadFile:photoFile withData:photoData toURL:DATA_URL_UPLOAD_SKILL_PHOTO
             forUser:userID completion:^(NSObject *obj, NSError *err)
     {
         NSString *fileLoc = (NSString *)obj;
         NSNumber *skillNum = [NSNumber numberWithInteger:skillID];
         NSDictionary *params = @{@"linkId":skillNum,@"location":fileLoc,@"type":@1};
         [self requestData:DATA_URL_CREATE_PHOTO withParameters:params completion:completion];
     }];
}

+ (void)updatePhotoForSkill:(NSInteger)skillID photoFile:(NSString *)photoFile photoData:(NSData *)photoData ofUser:(NSString *)userID
                 completion:(void (^)(NSObject *, NSError *))completion
{
    NSNumber *skillNum = [NSNumber numberWithInteger:skillID];
    NSDictionary *params = @{@"linkId":skillNum};
    [self requestData:DATA_URL_REMOVE_PHOTO withParameters:params completion:^(NSObject *obj, NSError *err)
     {
         [self createPhotoForSkill:skillID photoFile:photoFile photoData:photoData ofUser:userID completion:completion];
     }];
}

+ (void)sendAudioMessage:(NSString *)text audioData:(NSData *)data
            toRecipient:(NSString *)recipientUsername fromSender:(NSString *)senderID
             completion:(void (^)(NSObject *, NSError *))completion
{
    if (data)
    {
        [self uploadFile:text withData:data toURL:DATA_URL_UPLOAD_DOCUMENT
                 forUser:senderID completion:^(NSObject *obj, NSError *err)
         {
             NSString *fileloc = (NSString *)obj;
             NSDictionary *params = @{POST_PARAMETER_RECIPIENT:recipientUsername, POST_PARAMETER_MESSAGE:fileloc,
                                      POST_PARAMETER_SENDER:senderID, @"messagetype":@3};
             [self requestData:DATA_URL_PUSH_NOTIFICATION withParameters:params completion:completion];
         }];
    }
}

+ (void)sendDocument:(NSInteger)docID toRecipient:(NSString *)recipientID
          fromSender:(NSString *)senderID completion:(void (^)(NSObject *, NSError *))completion
{
    NSDictionary *params = @{POST_PARAMETER_MESSAGE:[NSNumber numberWithInteger:docID],
                             POST_PARAMETER_RECIPIENT:recipientID,
                             POST_PARAMETER_SENDER:senderID, @"messagetype":@4};
    [self requestData:DATA_URL_PUSH_NOTIFICATION withParameters:params completion:completion];
}

// Send text message or photo message )depends on which parameter (text or photoData) is set.
+ (void)sendPushMessage:(NSString *)text photoData:(NSData *)photoData
            toRecipient:(NSString *)recipientUsername fromSender:(NSString *)senderID
             completion:(void (^)(NSObject *, NSError *))completion
{
    if (photoData)
    {
        [self uploadFile:text withData:photoData toURL:DATA_URL_UPLOAD_DOCUMENT
                 forUser:senderID completion:^(NSObject *obj, NSError *err)
         {
             NSString *fileloc = (NSString *)obj;
             NSDictionary *params = @{POST_PARAMETER_RECIPIENT:recipientUsername, POST_PARAMETER_MESSAGE:fileloc,
                                      POST_PARAMETER_SENDER:senderID, @"messagetype":@2};
             [self requestData:DATA_URL_PUSH_NOTIFICATION withParameters:params completion:completion];
         }];
    }
    else
    {
        NSDictionary *params = @{POST_PARAMETER_RECIPIENT:recipientUsername, POST_PARAMETER_MESSAGE:text,
                                 POST_PARAMETER_SENDER:senderID, @"messagetype":@1};
        [self requestData:DATA_URL_PUSH_NOTIFICATION withParameters:params completion:completion];
    }
}

+ (void)getPendingNotificationForUser:(NSString *)userID completion:(void (^)(NSObject *, NSError *))completion
{
    NSDictionary *params = @{POST_PARAMETER_RECIPIENT:userID};
    [self requestData:DATA_URL_NOTIFICATION_PENDING_MESSAGE withParameters:params completion:completion];
}

+ (void)getContactListForUsername:(NSString*)username completion:(void (^)(NSObject *, NSError *))completion
{
    NSDictionary *params = @{POST_PARAMETER_USERNAME:username};
    [self requestData:DATA_URL_CONTACT_LIST withParameters:params completion:completion];
}

+ (void)getInfoForUser:(NSString *)userID completion:(void (^)(NSObject *, NSError *))completion
{
    NSDictionary *params = @{POST_PARAMETER_STKID:userID};
    [self requestData:DATA_URL_GET_ACCOUNT_INFO_BY_ID withParameters:params completion:completion];
}

+ (void)getAllSkillsWithCompletion:(void (^)(NSObject *, NSError *))completion
{
    [self requestData:DATA_URL_SKILL_GET_ALL withParameters:nil completion:completion];
}

+ (void)getSkillWithID:(NSInteger)skillID completion:(void (^)(NSObject *, NSError *))completion
{
    NSDictionary *params = @{@"id":[NSNumber numberWithInteger:skillID]};
    [self requestData:DATA_URL_SKILL_WITH_ID withParameters:params completion:completion];
}

+ (void)getSkillOfCatID:(NSInteger)catID completion:(void (^)(NSObject *, NSError *))completion
{
    NSDictionary *params = @{@"catId":[NSNumber numberWithInteger:catID]};
    [self requestData:DATA_URL_SKILL_OF_CAT_ID withParameters:params completion:completion];
}

+ (void)searchSkill:(NSString *)searchText completion:(void (^)(NSObject *, NSError *))completion
{
    NSDictionary *params = @{@"name":searchText};
    [self requestData:DATA_URL_SKILL_MATCHING withParameters:params completion:completion];
}

+ (void)getSkillListWithLimit:(NSInteger)limit completion:(void (^)(NSObject *, NSError *))completion
{
    NSDictionary *params = @{POST_PARAMETER_LIST_LIMIT:[NSNumber numberWithInteger:limit]};
    [self requestData:DATA_URL_SKILL_FIRST_N withParameters:params completion:completion];
}

+ (void)getSkillListForUser:(NSString *)stkid completion:(void (^)(NSObject *, NSError *))completion
{
    NSDictionary *params = @{POST_PARAMETER_STKID:stkid};
    [self requestData:DATA_URL_SKILL_FOR_USER withParameters:params completion:completion];
}


+ (void)createBuyerPostFromUser:(NSString *)userID type:(NSInteger)type cat:(NSInteger)catID
                           name:(NSString *)name description:(NSString *)desc
                      photoFile:(NSString *)photoFile photoData:(NSData *)photoData
                     completion:(void (^)(NSObject *, NSError *))completion;
{
    NSDictionary *params = @{POST_PARAMETER_BUYER_STKID:userID,
                             POST_PARAMETER_BUYER_TYPE:[NSNumber numberWithInteger:type],
                             POST_PARAMETER_BUYER_CAT:[NSNumber numberWithInteger:catID],
                             POST_PARAMETER_BUYER_NAME:name,
                             POST_PARAMETER_BUYER_DESC:desc};
    
    [self requestData:DATA_URL_CREATE_BUYER_POST withParameters:params completion:^(NSObject *obj, NSError *err)
     {
         NSNumber *buyerPostNum = (NSNumber *)obj;

         if (photoFile && photoData)
         {
             [self uploadFile:photoFile withData:photoData toURL:DATA_URL_UPLOAD_BUYER_PHOTO
                      forUser:userID completion:^(NSObject *obj, NSError *err)
              {
                  NSString *fileLoc = (NSString *)obj;
                  NSDictionary *params = @{@"linkId":buyerPostNum, @"location":fileLoc, @"type":@2};
                  [self requestData:DATA_URL_CREATE_PHOTO withParameters:params completion:completion];
              }];
         }
     }];
    
}

+ (void)getAllBuyerPostsWithCompletion:(void (^)(NSObject *, NSError *))completion
{
    [self requestData:DATA_URL_BUYER_POST_GET_ALL withParameters:nil completion:completion];
}

+ (void)getBuyerPostsWithLimit:(NSInteger)limit completion:(void (^)(NSObject *, NSError *))completion
{
    NSDictionary *params = @{POST_PARAMETER_LIST_LIMIT:[NSNumber numberWithInteger:limit]};
    [self requestData:DATA_URL_BUYER_POST_FIRST_N withParameters:params completion:completion];
}

+ (void)getBuyerPostWithID:(NSInteger)postID completion:(void (^)(NSObject *, NSError *))completion
{
    NSDictionary *params = @{POST_PARAMETER_BUYER_POST_ID:[NSNumber numberWithInteger:postID]};
    [self requestData:DATA_URL_BUYER_POST_WITH_ID withParameters:params completion:completion];
}

+ (void)createCPPostForUser:(NSString *)userID title:(NSString *)title desc:(NSString *)desc
                 photoFile:(NSString *)photoFile photoData:(NSData *)photoData
                  atXCoord:(double)x andYCoord:(double)y
                completion:(void (^)(NSObject *, NSError *))completion
{
   
    if (photoFile && photoData)
    {
        [self uploadFile:photoFile withData:photoData toURL:DATA_URL_UPLOAD_CP_PHOTO
                 forUser:userID completion:^(NSObject *obj, NSError *err)
         {
             NSString *photoLoc = (NSString *)obj;
             NSDictionary *params = @{@"stkId":userID,
                                      @"title":title,
                                      @"description":desc,
                                      @"xCoord":[NSNumber numberWithDouble:x],
                                      @"yCoord":[NSNumber numberWithDouble:y],
                                      @"photoLocation":photoLoc};

             [self requestData:DATA_URL_CP_CREATE_CP_POST withParameters:params completion:completion];
         }];
    }
}

+ (void)updateDeviceXCoord:(double)x andYCoord:(double)y forUser:(NSString *)userID
                completion:(void (^)(NSObject *, NSError *))completion
{
    NSDictionary *params = @{@"stkid":userID,
                             @"xCoord":[NSNumber numberWithDouble:x],
                             @"yCoord":[NSNumber numberWithDouble:y]};
    
    [self requestData:DATA_URL_DEVICE_UPDATE_COORD withParameters:params completion:completion];
}

+ (void)searchCPSkills:(NSString *)searchText atXCoord:(double)x andYCoord:(double)y
            completion:(void (^)(NSObject *, NSError *))completion
{
    NSDictionary *params = @{@"name":searchText,
                             @"xCoord":[NSNumber numberWithDouble:x],
                             @"yCoord":[NSNumber numberWithDouble:y]};
    [self requestData:DATA_URL_CP_SEARCH_NEARBY_SKILLS withParameters:params completion:completion];
}

+ (void)getCPPostsAtXCoord:(double)x andYCoord:(double)y forUser:(NSString *)userID
                completion:(void (^)(NSObject *, NSError *))completion
{
    NSDictionary *params = @{@"stkid":userID,
                             @"xCoord":[NSNumber numberWithDouble:x],
                             @"yCoord":[NSNumber numberWithDouble:y]};
    [self requestData:DATA_URL_CP_GET_POSTS_FROM_USER withParameters:params completion:completion];
}

+ (void)getCPPostsAtXCoord:(double)x andYCoord:(double)y completion:(void (^)(NSObject *, NSError *))completion
{
    NSDictionary *params = @{@"xCoord":[NSNumber numberWithDouble:x],
                             @"yCoord":[NSNumber numberWithDouble:y]};
    [self requestData:DATA_URL_CP_GET_POSTS_FROM_USER withParameters:params completion:completion];
}

+ (void)getCPPostsAtXCoord:(double)x andYCoord:(double)y forUser:(NSString *)userID
                 withLimit:(NSInteger)limit completion:(void (^)(NSObject *, NSError *))completion
{
    NSDictionary *params = @{@"stkid":userID,
                             POST_PARAMETER_LIST_LIMIT:[NSNumber numberWithInteger:limit],
                             @"xCoord":[NSNumber numberWithDouble:x],
                             @"yCoord":[NSNumber numberWithDouble:y]};
    [self requestData:DATA_URL_CP_GET_POSTS_FROM_USER withParameters:params completion:completion];
}

+ (void)getCPPostsAtXCoord:(double)x andYCoord:(double)y withLimit:(NSInteger)limit
                completion:(void (^)(NSObject *, NSError *))completion
{
    NSDictionary *params = @{POST_PARAMETER_LIST_LIMIT:[NSNumber numberWithInteger:limit],
                             @"xCoord":[NSNumber numberWithDouble:x],
                             @"yCoord":[NSNumber numberWithDouble:y]};
    [self requestData:DATA_URL_CP_GET_POSTS_FROM_USER withParameters:params completion:completion];
}

+ (NSString *)getFullStoragePath:(NSString *)fileLoc
{
    NSString *fullPath = [NSString stringWithFormat:@"%@/%@", DATA_HOST, fileLoc];
    return [fullPath stringByReplacingOccurrencesOfString:IOS_STORAGE_PATH withString:DATA_HOST];
}

+ (void)requestData:(NSString *)url withParameters:(NSDictionary *)params
         completion:(void (^)(NSObject *, NSError *))completion
{
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setTimeoutInterval:DATA_REQUEST_TIMEOUT];
    
    if (params)
        [urlRequest setHTTPBody:[[self formatParameter:params] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (data.length > 0 && error == nil)
         {
             NSJSONReadingOptions jsonOption = NSJSONReadingAllowFragments;
             id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:jsonOption error:&error];
             completion(jsonObject,error);
         }
         else
         {
             completion(nil,error);
         }
     }];
}

// echo edit
+ (void)requestGoogleData:(NSString *)url withParameters:(NSDictionary *)params
         completion:(void (^)(NSObject *, NSError *))completion
{
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setValue:@"key=AIzaSyCvIIIK7xwfLD5in_ypUiGyQWTJYrIzXOk" forHTTPHeaderField:@"Authorization"];
    [urlRequest setTimeoutInterval:60];
        
    if (params)
        [urlRequest setHTTPBody:[[self formatParameter:params] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"body param --- %@",[self formatParameter:params]);
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (data.length > 0 && error == nil)
         {
             NSJSONReadingOptions jsonOption = NSJSONReadingAllowFragments;
             id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:jsonOption error:&error];
             completion(jsonObject,error);
         }
         else
         {
             completion(nil,error);
         }
     }];
}



+ (NSString *)formatParameter:(NSDictionary *)paramDict
{
    NSMutableString *body = [[NSMutableString alloc] initWithString:@""];
    for (NSString* key in [paramDict keyEnumerator])
    {
        NSString *value = [paramDict objectForKey:key];
        [body appendFormat:@"%@=%@&",key,value];
    }
    return body;
}

+ (void)uploadFile:(NSString *)filename withData:(NSData *)filedata toURL:(NSString *)urlString
           forUser:(NSString *)userID completion:(void (^)(NSObject *, NSError *))completion
{
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", CONTENT_BOUNDARY];
    NSData *body = [self obtainPostDataForFileName:filename withData:filedata ofUser:userID];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:30];
    [request setHTTPMethod:@"POST"];
    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:body];
    [request setValue:[NSString stringWithFormat:@"%ld", body.length] forHTTPHeaderField:@"Content-Length"];

    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
    {
        NSJSONReadingOptions jsonOption = NSJSONReadingAllowFragments;
        id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:jsonOption error:&error];
        
        completion(jsonObject,error);
    }];

}

+ (NSData *) obtainPostDataForFileName:(NSString *)filename withData:(NSData *)filedata ofUser:(NSString *)userID
{
    NSString * fileParam = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", POST_PARAMETER_FILENAME, filename];
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", CONTENT_BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"stkid"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", userID] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", CONTENT_BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[fileParam dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:filedata];
    [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", CONTENT_BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
    return body;
}

@end
