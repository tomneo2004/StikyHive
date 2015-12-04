//
//  WebDataInterface.h
//  StikyHive
//
//  Created by Koh Quee Boon on 13/4/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define CONTENT_BOUNDARY @"---------------------------14737809831466499882746641449"

 //#define WEBSITE_STORAGE_PATH            @"../../.."
#define IOS_STORAGE_PATH                @".."

//#define DATA_HOST                       @"http://202.150.214.50"
#define DATA_HOST                       @"http://beta.stikyhive.com:81"
#define DATA_IMAGE_HOST                 @"http://beta.stikyhive.com:81/"

//#define DATA_URL                        DATA_HOST@"/datasvc/index.php/"

#define DATA_URL_INITIAL_DATA           DATA_URL@"Home/getInitialData"

//#define DATA_URL_USER_VERIFY            DATA_URL@"UserAccount/verifyAccount"

//#define DATA_URL_USER_LOGIN             DATA_URL@"UserAccount/login"
#define REQUEST_RESULT_LOGIN_STATUS     @"status"
#define REQUEST_RESULT_LOGIN_DESC       @"description"
#define REQUEST_RESULT_LOGIN_USER_ID    @"stkid"
#define POST_PARAMETER_DEVICE_TOKEN     @"deviceToken"

//#define DATA_URL_USER_SIGNUP            DATA_URL@"UserAccount/createAccount"

#define POST_PARAMETER_USERNAME         @"username"
#define POST_PARAMETER_PASSWORD_1       @"password_1"
#define POST_PARAMETER_PASSWORD_2       @"password_2"
#define STATUS_ACCOUNT_CREATED          0
#define STATUS_ACCOUNT_UPDATE_SUCCESS   0
#define STATUS_USERNAME_INVALID_FORMAT  1
#define STATUS_PASSWORDS_TOO_SHORT      2
#define STATUS_PASSWORDS_NOT_MATCH      3
#define STATUS_USERNAME_ALREADY_EXIST   4
#define STATUS_ERROR_CREATING_ACCOUNT   5

//#define POST_PARAMETER_STKID            @"stkid"

#define DATA_URL_GET_ACCOUNT_INFO_BY_ID DATA_URL@"UserAccount/getUserInfo"

#define DATA_URL_USER_UPDATE            DATA_URL@"UserAccount/updateAccount"
#define DATA_URL_USER_UPDATE_STATUS     DATA_URL@"UserAccount/updateStatus"
//#define POST_PARAMETER_FIRSTNAME        @"firstname"
//#define POST_PARAMETER_LASTNAME         @"lastname"
//#define POST_PARAMETER_DOB              @"dob"
#define POST_PARAMETER_ADDRESS_1        @"address1"
#define POST_PARAMETER_ADDRESS_2        @"address2"
//#define POST_PARAMETER_POSTAL_CODE      @"postalCode"
#define POST_PARAMETER_USER_COUNTRY     @"countryISO"
#define POST_PARAMETER_USER_DESC        @"description"
#define POST_PARAMETER_PROFILE_PICTURE  @"profilePicture"
#define POST_PARAMETER_STATUS           @"status"

//#define POST_PARAMETER_SKILL_SKILL_NAME  @"skill_name"


#define POST_PARAMETER_GET_USER_STKID    @"stkid"
#define POST_PARAMETER_GET_USER_USERNAME @"username"
#define REQUEST_RESULT_GET_USER_ACCOUNT  @"stikybee"

//#define REQUEST_RESULT_PROF_SKILL       @"professional_skill"
//#define REQUEST_RESULT_RAW_TALENT       @"raw_talent"

#define DATA_URL_CREATE_JOB_HISTORY             DATA_URL@"JobHistory/create"
#define DATA_URL_UPDATE_JOB_HISTORY             DATA_URL@"JobHistory/update"
#define DATA_URL_JOB_HISTORY_OF_ID              DATA_URL@"JobHistory/getJobHistoryOfID"
#define DATA_URL_JOB_HISTORIES_FOR_USER         DATA_URL@"JobHistory/getJobHistoriesForUser"
#define POST_PARAMETER_JOB_HISTORY_ID           @"id"
#define POST_PARAMETER_JOB_HISTORY_STIKY_ID     @"stkid"
#define POST_PARAMETER_JOB_HISTORY_COMPANY_NAME @"companyName"
#define POST_PARAMETER_JOB_HISTORY_COUNTRY      @"countryISO"
#define POST_PARAMETER_JOB_HISTORY_JOB_TITLE    @"jobtitle"
#define POST_PARAMETER_JOB_HISTORY_ADD_INFO     @"otherInfo"
#define POST_PARAMETER_JOB_HISTORY_FROM_DATE    @"fromDate"
#define POST_PARAMETER_JOB_HISTORY_TO_DATE      @"toDate"


#define DATA_URL_CREATE_EDUCATION               DATA_URL@"Education/create"
#define DATA_URL_UPDATE_EDUCATION               DATA_URL@"Education/update"
#define DATA_URL_EDUCATION_OF_ID                DATA_URL@"Education/getEducationOfID"
#define DATA_URL_EDUCATIONS_FOR_USER            DATA_URL@"Education/getEducationsForUser"
#define POST_PARAMETER_EDUCATION_ID             @"id"
#define POST_PARAMETER_EDUCATION_STIKY_ID       @"stkid"
#define POST_PARAMETER_EDUCATION_INSTITUTE      @"institute"
#define POST_PARAMETER_EDUCATION_QUALIFICATION  @"qualification"
#define POST_PARAMETER_EDUCATION_COUNTRY        @"countryISO"
#define POST_PARAMETER_EDUCATION_ADD_INFO       @"otherInfo"
#define POST_PARAMETER_EDUCATION_FROM_DATE      @"fromDate"
#define POST_PARAMETER_EDUCATION_TO_DATE        @"toDate"


#define DATA_URL_CREATE_VIDEO           DATA_URL@"Video/createVideo"
#define DATA_URL_REMOVE_VIDEO           DATA_URL@"Video/removeVideosWithLinkID"
#define DATA_URL_CREATE_PHOTO           DATA_URL@"Photo/createPhoto"
#define DATA_URL_REMOVE_PHOTO           DATA_URL@"Photo/removePhotosWithLinkID"


#define DATA_URL_SKILL_CREATE           DATA_URL@"Skill/createSkill"
#define DATA_URL_SKILL_UPDATE           DATA_URL@"Skill/updateSkill"
#define DATA_URL_SKILL_FOR_USER         DATA_URL@"Skill/getSkillsForUser"
#define DATA_URL_SKILL_WITH_ID          DATA_URL@"Skill/getSkillOfID"
#define DATA_URL_SKILL_OF_CAT_ID        DATA_URL@"Skill/getSkillsOfCatID"
#define DATA_URL_SKILL_GET_ALL          DATA_URL@"Skill/getAllSkills"
#define DATA_URL_SKILL_FIRST_N          DATA_URL@"Skill/getFirstNthSkills"
#define DATA_URL_SKILL_MATCHING         DATA_URL@"Skill/getSkillsMatching"


#define DATA_URL_CREATE_BUYER_POST      DATA_URL@"Buyer/createPost"
#define DATA_URL_BUYER_POST_WITH_ID     DATA_URL@"Buyer/getPostWithID"
#define DATA_URL_BUYER_POST_GET_ALL     DATA_URL@"Buyer/getAllPosts"
#define DATA_URL_BUYER_POST_FIRST_N     DATA_URL@"Buyer/getFirstNthPosts"

#define POST_PARAMETER_BUYER_POST_ID    @"id"
#define POST_PARAMETER_BUYER_STKID      @"stkid"
#define POST_PARAMETER_BUYER_TYPE       @"type"
#define POST_PARAMETER_BUYER_CAT        @"catId"
#define POST_PARAMETER_BUYER_NAME       @"name"
#define POST_PARAMETER_BUYER_DESC       @"description"

//#define POST_PARAMETER_BUYER_ID         @"buyer_id"
#define REQUEST_RESULT_BUYER_ID         @"id"
#define REQUEST_RESULT_BUYER_STKID      @"stkid"
#define REQUEST_RESULT_BUYER_TITLE      @"title"
#define REQUEST_RESULT_BUYER_OVERVIEW   @"overview"
                   
#define DATA_URL_CONTACT_LIST           DATA_URL@"Contact/getContactListForUser"

#define DATA_URL_UPLOAD_CP_PHOTO        DATA_URL@"FileManager/uploadCPPhoto"
#define DATA_URL_UPLOAD_PROFILE_PIC     DATA_URL@"FileManager/uploadProfilePic"
#define DATA_URL_UPLOAD_SKILL_VIDEO     DATA_URL@"FileManager/uploadSkillVideo"
#define DATA_URL_UPLOAD_SKILL_PHOTO     DATA_URL@"FileManager/uploadSkillPhoto"
#define DATA_URL_UPLOAD_BUYER_PHOTO     DATA_URL@"FileManager/uploadBuyerPhoto"
#define DATA_URL_UPLOAD_DOCUMENT        DATA_URL@"FileManager/uploadDocument"
#define POST_PARAMETER_FILENAME         @"filename"

#define DATA_URL_USER_DOCUMENTS         DATA_URL@"Document/getDocsForUser"
#define DATA_URL_DOCUMENT_WITH_ID       DATA_URL@"Document/getDocWithID"

#define DATA_URL_PUSH_NOTIFICATION      DATA_URL@"StikyChat/sendNotification"
#define POST_PARAMETER_MESSAGE          @"message"
#define POST_PARAMETER_RECIPIENT        @"recipient"
#define POST_PARAMETER_SENDER           @"sender"

#define POST_PARAMETER_LIST_LIMIT       @"limit"

#define REQUEST_RESULT_SKILL_CATEGORY_CAT_ID    @"id"
#define REQUEST_RESULT_SKILL_CATEGORY_CAT_NAME  @"name"
#define REQUEST_RESULT_SKILL_ID         @"id"
#define REQUEST_RESULT_SKILL_CAT_ID     @"catId"
#define REQUEST_RESULT_SKILL_USER_ID    @"stkid"
#define REQUEST_RESULT_SKILL_NAME       @"name"
#define REQUEST_RESULT_SKILL_DESC       @"description"
#define REQUEST_RESULT_SKILL_STATUS     @"status"
#define REQUEST_RESULT_SKILL_EXPIRY_DATE @"expiryDate"

#define REQUEST_RESULT_BUYER_LIST @"buyer"

#define DATA_URL_CP_CREATE_CP_POST       DATA_URL@"CrossPollinate/createCPPost"
#define DATA_URL_CP_SEARCH_NEARBY_SKILLS DATA_URL@"CrossPollinate/searchNearbySkills"
#define DATA_URL_CP_GET_POSTS_FROM_USER   DATA_URL@"CrossPollinate/getPostsFromUser"
#define DATA_URL_CP_GET_POSTS_NEAR_COORD  DATA_URL@"CrossPollinate/getPostsNearCoord"

#define DATA_URL_DEVICE_UPDATE_COORD DATA_URL@"Device/updateDeviceCoord"

#define DATA_URL_NOTIFICATION_PENDING_MESSAGE DATA_URL@"Notification/processPendingNotificationForRecipient"


/////////////////// Echo /////////////////////
#define POST_PARAMETER_STATUS           @"status"
#define DATA_URL                        DATA_HOST@"/androidstikyhive/index.php/api/users/"
#define DATA_URL_GET_POSTS_COUNTRY      DATA_URL@"getCountry/format/json"
#define DATA_URL_GET_POSTS_CATEGORY     DATA_URL@"getSkillCategory/format/json"
#define DATA_URL_USER_SIGNUP            DATA_URL@"createAccount/format/json"
#define DATA_URL_USER_LOGIN             DATA_URL@"login/format/json"
#define DATA_URL_USER_VERIFY            DATA_URL@"updateStikyBeeStatus/format/json"
#define DATA_URL_USER_SAVEPROFILE       DATA_URL@"saveStikyBee/format/json"
#define DATA_URL_GET_IMAGE_LOCATION     DATA_URL@"getProfileLocation/format/json"
#define DATA_URL_USER_FB_LOGIN          DATA_URL@"socialMedia/format/json"
#define DATA_URL_USER_FORGOT_PASSWORD   DATA_URL@"forgotPassword/format/json"
#define DATA_URL_GET_SELL_MARKET        DATA_URL@"getSellAll/format/json"
#define DATA_URL_GET_BUYER_MARKET       DATA_URL@"getBuyerMarket/format/json"
#define DATA_URL_GET_SKILL_BY_ID        DATA_URL@"getSkillById/format/json"
#define DATA_URL_GET_COMM_BY_SKILL_ID   DATA_URL@"selectCommReviewBySkillId/format/json"
#define DATA_URL_POST_COMMENT           DATA_URL@"insertComment/format/json"
#define DATA_URL_GET_BUYER_MARKET_BY_ID DATA_URL@"getBuyerMarketById/format/json"
//#define DATA_URL_GET_SELL_ALL           DATA_URL@"getSellAll/format/json"
#define DATA_URL_GET_STIKY_BEE_INFO     DATA_URL@"getStikyBeeInfo/format/json"
#define DATA_URL_INSERT_SAVED_DOCU      DATA_URL@"insertSavedDocuemnt/format/json"
#define DATA_URL_GET_SAVED_DOCUMENT     DATA_URL@"getSavedDocument/format/json"
#define DATA_URL_GET_URGENT_REQUEST     DATA_URL@"getUrgentRequest/format/json"
#define DATA_URL_GET_RATE               DATA_URL@"getRate/format/json"
#define DATA_URL_GET_MY_LOCATION        DATA_URL@"getMyLocation/format/json"
#define DATA_URL_SEARCH_NEAR_BY_CP      DATA_URL@"searchNearByCP/format/json"
#define DATA_URL_INSERT_URGENT_REQUEST  DATA_URL@"insertUrgentRequest/format/json"
#define DATA_URL_DELETE_DOCUMENT        DATA_URL@"deleteDocument/format/json"
#define DATA_URL_SELECT_SUBINFO         DATA_URL@"selectSubInfo/format/json"
#define DATA_URL_SELECT_CONTACT         DATA_URL@"selectContacts/format/json"


#define POST_PARAMETER_EMAIL            @"email"
#define POST_PARAMETER_PASSWORD         @"password"
#define POST_PARAMETER_FIRSTNAME        @"firstname"
#define POST_PARAMETER_LASTNAME         @"lastname"
#define POST_PARAMETER_DOB              @"dob"
#define POST_PARAMETER_ADDRESS          @"address"
#define POST_PARAMETER_POSTAL_CODE      @"postalcode"
#define POST_PARAMETER_COUNTRY          @"countryISO"
#define POST_PARAMETER_SKILLNAME        @"skillname1"
#define POST_PARAMETER_SKILLID          @"skillid1"
#define POST_PARAMETER_SKILLTYPE        @"skilltype1"
#define POST_PARAMETER_TALENTNAME       @"talentname1"
#define POST_PARAMETER_TALENTID         @"talentid1"
#define POST_PARAMETER_TALENTTYPE       @"talenttype1"
#define POST_PARAMETER_STKID            @"stkid"
#define POST_PARAMETER_NAME             @"name"
#define POST_PARAMETER_PROFILEPICTURE   @"profilePicture"
#define POST_PARAMETER_MEDIA_TYPE       @"type"
#define POST_PARAMETER_LIMIT            @"limit"
#define POST_PARAMETER_CATEGORY_ID      @"catId"
#define POST_PARAMETER_SKILL_ID         @"skillId"
#define POST_PARAMETER_REVIEWR          @"reviewer"
#define POST_PARAMETER_REVIEW           @"review"
#define POST_PARAMETER_TYPE             @"type"
#define POST_PARAMETER_RATE             @"rating"
#define POST_PARAMETER_BUYER_ID         @"id"
#define POST_PARAMETER_LOCATION         @"location"
#define POST_PARAMETER_NAMESKILL        @"skillName"
#define POST_PARAMETER_TITLE            @"title"
#define POST_PARAMETER_DESC             @"desc"
#define POST_PARAMETER_DOCUMENT_ID      @"id"


//#define DATA_URL_USER_VERIFY            DATA_URL@"varify"
#define POST_PARAMETER_HASHCODE         @"hashcode"
#define SENDGRID_API_USER               @"StikyHive"
#define SENDGRID_API_KEY                @"stikybee1234567"
#define SENDGRID_EMAIL_ADDRESS          @"stikybee@gmail.com"

@interface WebDataInterface : NSObject

///////// Echo ///////////////////////////////////////////////////////////////


+ (void)getCountry:(NSInteger)status completion:(void (^)(NSObject *, NSError *))completion;

+ (void)getCategory:(NSInteger)status completion:(void (^)(NSObject *, NSError *))completion;

+ (void)updateImageProfile:(NSString *)stikyid completion:(void (^)(NSObject *, NSError *))completion;

+ (void)signupWithUsername:(NSString *)username password:(NSString *)password completion:(void (^)(NSObject *, NSError *))completion;

+ (void)loginWithEmail:(NSString *)email password:(NSString *)password completion:(void (^)(NSObject *, NSError *))completion;

+ (void)verifyUserEmail:(NSString *)email password:(NSString *)password hashcode:(NSString *)code completion:(void (^)(NSObject *, NSError *))completion;

//+ (void)saveStikyBee:(NSString *)email password:(NSString *)password firstname:(NSString *)firstname lastname:(NSString *)lastname dob:(NSString *)dob address:(NSString *)address country:(NSString *)countryISO postalcode:(NSString *)postalcode skillname:(NSString *)skillname1 skillid:(NSInteger)skillid1 skilltype1:(NSInteger)skilltype1 talentname:(NSString *)talentname1 talentid:(NSInteger)talentid1 talenttype:(NSInteger)talenttype1 completion:(void (^)(NSObject *, NSError *))completion;

+ (void)saveStikyBeeInfo:(NSString *)email password:(NSString *)password firstname:(NSString *)firstname lastname:(NSString *)lastname dob:(NSString *)dob address:(NSString *)address country:(NSString *)countryISO postalcode:(NSString *)postalcode skillname1:(NSString *)skillname1 skillid1:(NSString *)skillid1 skilltype1:(NSString *)skilltype1 talentname1:(NSString *)talentname1 talentid1:(NSString *)talentid1 talenttype1:(NSString *)talenttype1 completion:(void (^)(NSObject *, NSError *))completion;

+ (void)getImageLocation:(NSString *)stkid completion:(void (^)(NSObject *, NSError *))completion;

+ (void)loginWithFB:(NSString *)email name:(NSString *)name profilePicture:(NSString *)profilePicture type:(NSString *)type completion:(void (^)(NSObject *, NSError *))completion;

+ (void)forgotPassword:(NSString *)email completion:(void (^)(NSObject *, NSError *))completion;


+ (void)getSellAll:(NSInteger)limit catId:(NSInteger)catId stkid:(NSString *)stkid actionMaker:(NSString *)actionMaker completion:(void (^)(NSObject *, NSError *))completion;

+ (void)getBuyerMarket:(NSString *)skillId limit:(NSInteger)limit completion:(void (^)(NSObject *, NSError *))completion;

+ (void)getBuyerMarketByStkid:(NSString *)stkid limit:(NSInteger)limit completion:(void (^)(NSObject *, NSError *))completion;


+ (NSString *)getFullUrlPath:(NSString *)fileLoc;

+ (void)getSkillById:(NSString *)skillId stkid:(NSString *)stkid completion:(void (^)(NSObject *, NSError *))completion;

+ (void)getCommReviewBySkillId:(NSString *)skillId completion:(void (^)(NSObject *, NSError *))completion;

+ (void)postSellerComments:(NSString *)skillId reviewer:(NSString *)reviewer review:(NSString *)review type:(NSInteger)type rating:(NSInteger)rating completion:(void (^)(NSObject *, NSError *))completion;

+ (void)getBuyerMarketById:(NSInteger)buyerId completion:(void (^)(NSObject *, NSError *))completion;

+ (void)getStikyBeeInfo:(NSString *)stikyid completion:(void (^)(NSObject *, NSError *))completion;

+ (void)insertSavedDocument:(NSString *)stkid name:(NSString *)name location:(NSString *)location completion:(void (^)(NSObject *, NSError *))completion;

+ (void)getSavedDocument:(NSString *)stkid completion:(void (^)(NSObject *, NSError *))completion;

+ (void)getUrgentRequest:(NSInteger)limit stkid:(NSString *)stkid completion:(void (^)(NSObject *, NSError *))completion;

+ (void)getRate:(NSInteger)limit completion:(void (^)(NSObject *, NSError *))completion;

+ (void)getMyLocation:(NSString *)stkid completion:(void (^)(NSObject *, NSError *))completion;

+ (void)searchNearByCp:(NSString *)stkid skillname:(NSString *)skillname completion:(void (^)(NSObject *, NSError *))completion;

+ (void)insertUrgentRequest:(NSString *)stkid title:(NSString *)title desc:(NSString *)desc completion:(void (^)(NSObject *, NSError *))completion;

+ (void)fileRequestUpload:(UIImage *)profileImage stikyid:(NSString *)stikyid cpid:(NSInteger)cpid;

+ (void)deleteDocuments:(NSArray *)idArray completion:(void (^)(NSObject *, NSError *))completion;

+ (void)selectSubInfo:(NSString *)stkid completion:(void (^)(NSObject *, NSError *))completion;

+ (void)selectContacts:(NSString *)stkid completion:(void (^)(NSObject *, NSError *))completion;






////////  ///////////// END -------------------------------------


+ (void)getInitialDataWithcompletion:(void (^)(NSObject *, NSError *))completion;

//+ (void)signupWithUsername:(NSString *)username password1:(NSString *)password1 password2:(NSString *)password2
//               deviceToken:(NSString *)dToken completion:(void (^)(NSObject *, NSError *))completion;

//+ (void)verifyUsername:(NSString *)username hashcode:(NSString *)code completion:(void (^)(NSObject *, NSError *))completion;

//+ (void)loginWithUsername:(NSString *)username password:(NSString *)password
//              deviceToken:(NSString *)dToken completion:(void (^)(NSObject *, NSError *))completion;

+ (void)updateProfileForUser:(NSString *)userID password:(NSString *)password
                   firstname:(NSString *)firstname lastname:(NSString *)lastname
                   dobString:(NSString *)dobString desc:(NSString *)desc
                    address1:(NSString *)address1 address2:(NSString *)address2
                  postalCode:(NSString *)postalCode country:(NSString *)country
                    photoLoc:(NSString *)photoLoc photoData:(NSData *) photoData
                  completion:(void (^)(NSObject *, NSError *))completion;

+ (void)updateUserStatus:(NSString *)userID password:(NSString *)password status:(NSInteger)status
              completion:(void (^)(NSObject *, NSError *))completion;

+ (void)createEducationForUser:(NSString *)userID institute:(NSString *)institute
                       country:(NSString *)countryISO qualification:(NSString *)quali addInfo:(NSString *)info
                      fromDate:(NSString *)fromYYYYMMDD toDate:(NSString *)toYYYYMMDD
                    completion:(void (^)(NSObject *, NSError *))completion;

+ (void)updateEducation:(NSInteger)eduID institute:(NSString *)institute
                country:(NSString *)countryISO qualification:(NSString *)quali addInfo:(NSString *)info
               fromDate:(NSString *)fromYYYYMMDD toDate:(NSString *)toYYYYMMDD
             completion:(void (^)(NSObject *, NSError *))completion;

+ (void)getEducationForUser:(NSString *)stkid completion:(void (^)(NSObject *, NSError *))completion;

+ (void)getEducationOfID:(NSInteger)eduID completion:(void (^)(NSObject *, NSError *))completion;

+ (void)createJobHistoryForUser:(NSString *)userID companyName:(NSString *)companyName
                        country:(NSString *)countryISO jobTitle:(NSString *)title addInfo:(NSString *)info
                       fromDate:(NSString *)fromYYYYMMDD toDate:(NSString *)toYYYYMMDD
                     completion:(void (^)(NSObject *, NSError *))completion;

+ (void)updateJobHistory:(NSInteger)jobID companyName:(NSString *)companyName
                 country:(NSString *)countryISO jobTitle:(NSString *)title addInfo:(NSString *)info
                fromDate:(NSString *)fromYYYYMMDD toDate:(NSString *)toYYYYMMDD
              completion:(void (^)(NSObject *, NSError *))completion;

+ (void)getJobHistoryForUser:(NSString *)stkid completion:(void (^)(NSObject *, NSError *))completion;

+ (void)getJobHistoryOfID:(NSInteger)jobID completion:(void (^)(NSObject *, NSError *))completion;

+ (void)createSkillForUser:(NSString *)userID skillType:(NSInteger)skillType catID:(NSInteger)catID
                 skillName:(NSString *)skillName skillDesc:(NSString *)skillDesc
                completion:(void (^)(NSObject *, NSError *))completion;

+ (void)updateSkill:(NSInteger)skillID skillType:(NSInteger)skillType catID:(NSInteger)catID
          skillName:(NSString *)skillName skillDesc:(NSString *)skillDesc
         completion:(void (^)(NSObject *, NSError *))completion;

+ (void)createVideoForSkill:(NSInteger)skillID videoFile:(NSString *)videoFile videoData:(NSData *)videoData
                  thumbFile:(NSString *)thumbFile thumbData:(NSData *)thumbData ofUser:(NSString *)userID
                 completion:(void (^)(NSObject *, NSError *))completion;

+ (void)updateVideoForSkill:(NSInteger)skillID videoFile:(NSString *)videoFile videoData:(NSData *)videoData
                  thumbFile:(NSString *)thumbFile thumbData:(NSData *)thumbData ofUser:(NSString *)userID
                 completion:(void (^)(NSObject *, NSError *))completion;

+ (void)createPhotoForSkill:(NSInteger)skillID photoFile:(NSString *)photoFile photoData:(NSData *)photoData
                     ofUser:(NSString *)userID completion:(void (^)(NSObject *, NSError *))completion;

+ (void)updatePhotoForSkill:(NSInteger)skillID photoFile:(NSString *)photoFile photoData:(NSData *)photoData
                     ofUser:(NSString *)userID  completion:(void (^)(NSObject *, NSError *))completion;

+ (void)getDocumentWithID:(NSInteger)docID completion:(void (^)(NSObject *, NSError *))completion;

+ (void)getAllDocumentsForUser:(NSString *)userID completion:(void (^)(NSObject *, NSError *))completion;

+ (void)createDocumentForUser:(NSString *)userID name:(NSString *)name
                       docLoc:(NSString *)docLoc docData:(NSData *) docData
                   completion:(void (^)(NSObject *, NSError *))completion;

/*
 + (void)updateDocumentForUser:(NSString *)userID name:(NSString *)name
 docLoc:(NSString *)docLoc docData:(NSData *) docData
 completion:(void (^)(NSObject *, NSError *))completion;
 */

+ (void)sendDocument:(NSInteger)docID toRecipient:(NSString *)recipientID
          fromSender:(NSString *)senderID completion:(void (^)(NSObject *, NSError *))completion;

+ (void)sendAudioMessage:(NSString *)text audioData:(NSData *)data
             toRecipient:(NSString *)recipientUsername fromSender:(NSString *)senderID
              completion:(void (^)(NSObject *, NSError *))completion;

+ (void)sendPushMessage:(NSString *)text photoData:(NSData *)photoData
            toRecipient:(NSString *)recipientUsername fromSender:(NSString *)senderID
             completion:(void (^)(NSObject *, NSError *))completion;

+ (void)getPendingNotificationForUser:(NSString *)userID completion:(void (^)(NSObject *, NSError *))completion;

+ (void)getContactListForUsername:(NSString*)username completion:(void (^)(NSObject *, NSError *))completion;

+ (void)getInfoForUser:(NSString *)stkid completion:(void (^)(NSObject *, NSError *))completion;

+ (void)getAllSkillsWithCompletion:(void (^)(NSObject *, NSError *))completion;
+ (void)getSkillWithID:(NSInteger)skillID completion:(void (^)(NSObject *, NSError *))completion;
+ (void)getSkillOfCatID:(NSInteger)catID completion:(void (^)(NSObject *, NSError *))completion;
+ (void)searchSkill:(NSString *)searchText completion:(void (^)(NSObject *, NSError *))completion;
+ (void)getSkillListWithLimit:(NSInteger)limit completion:(void (^)(NSObject *, NSError *))completion;
+ (void)getSkillListForUser:(NSString *)stkid completion:(void (^)(NSObject *, NSError *))completion;

+ (void)createBuyerPostFromUser:(NSString *)userID type:(NSInteger)type cat:(NSInteger)catID
                           name:(NSString *)name description:(NSString *)desc
                      photoFile:(NSString *)photoFile photoData:(NSData *)photoData
                     completion:(void (^)(NSObject *, NSError *))completion;

+ (void)getAllBuyerPostsWithCompletion:(void (^)(NSObject *, NSError *))completion;
+ (void)getBuyerPostsWithLimit:(NSInteger)limit completion:(void (^)(NSObject *, NSError *))completion;
+ (void)getBuyerPostWithID:(NSInteger)postID completion:(void (^)(NSObject *, NSError *))completion;

+ (void)createCPPostForUser:(NSString *)userID title:(NSString *)title desc:(NSString *)desc
                  photoFile:(NSString *)photoFile photoData:(NSData *)photoData
                   atXCoord:(double)x andYCoord:(double)y
                 completion:(void (^)(NSObject *, NSError *))completion;

+ (void)updateDeviceXCoord:(double)x andYCoord:(double)y forUser:(NSString *)userID
                completion:(void (^)(NSObject *, NSError *))completion;

+ (void)searchCPSkills:(NSString *)searchText atXCoord:(double)x andYCoord:(double)y
           completion:(void (^)(NSObject *, NSError *))completion;

+ (void)getCPPostsAtXCoord:(double)x andYCoord:(double)y forUser:(NSString *)userID
               completion:(void (^)(NSObject *, NSError *))completion;

+ (void)getCPPostsAtXCoord:(double)x andYCoord:(double)y completion:(void (^)(NSObject *, NSError *))completion;

+ (void)getCPPostsAtXCoord:(double)x andYCoord:(double)y forUser:(NSString *)userID
                withLimit:(NSInteger)limit completion:(void (^)(NSObject *, NSError *))completion;

+ (void)getCPPostsAtXCoord:(double)x andYCoord:(double)y withLimit:(NSInteger)limit
               completion:(void (^)(NSObject *, NSError *))completion;

+ (NSString *)getFullStoragePath:(NSString *)fileLoc;

@end
