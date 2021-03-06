//自动生成的，通过coredata存储数据的数据管理类

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
//未被管理的数据对象
@interface CustomUser : NSObject<NSCoding>

@property (strong,nonatomic)UIImage *icon;
@property (strong,nonatomic)NSString *account;
@property (strong,nonatomic)NSString *password;
@property (assign,nonatomic)BOOL isSavePassword;
@property (assign,nonatomic)BOOL isAutoLogin;

@end

//管理类的声明
@interface CustomUserManager : NSObject

//对数据类进行管理的方法的声明
@property (strong,nonatomic)NSMutableArray *list;//存储的对象列表

//以下是自定义的方法，修改时注意
#pragma mark 自定义方法——声明
@property (strong,nonatomic)CustomUser *currentUser;//存储当前登录的用户

//以上是自定义的方法

+(id)share;//获取管理的类
-(NSMutableArray*)getall;//读取数据库中的数据
-(void)updata;//将list中的数据保存在数据库中（原有的数据会删除）

//增加对象
-(void)addWithicon:(UIImage *)icon account:(NSString *)account password:(NSString *)password isSavePassword:(BOOL )isSavePassword isAutoLogin:(BOOL )isAutoLogin ;//添加对象
-(void)addObject:(CustomUser *)obj;
-(void)addArray:(NSArray *)array;

//删除对象
-(void)deleteArray:(NSArray*)array;
-(void)deleteObject:(CustomUser *)obj;
-(void)deleteall;

-(void)changeObject:(CustomUser*)obj;//更改对象中的数据后保存
//例如：obj=[[... getall]firstObject];
//obj.name=@"xasca";obj.age=123;
//[... changeObject:obj];就可以保存对象了

-(void)printall;//打印所有数据

-(NSArray*)findObjectIn:(NSString*)where for:(NSString*)string;//搜索
-(NSArray*)findbyPredicate:(NSPredicate*)predicate;//根据自定义的谓词搜索
//NSPredicate *predicate=[NSPredicate predicateWithFormat:@"name=%@",name];
-(NSArray *)requestWithPredicate:(NSPredicate *)predicate sort:(NSArray*)sort;//自定义的请求

-(NSDictionary*)dictionaryWithObject:(CustomUser*)obj;
-(CustomUser*)objectWithDictionary:(NSDictionary*)dict;
-(NSArray*)dictionaryArrayWithAllObject;
-(NSArray*)dictionaryArrayWithArray:(NSArray*)array;
-(BOOL)saveDictionaryArray:(NSArray*)array;

-(BOOL)checkObjectClass:(id)obj;//检测对象是否是正确的类

@end
