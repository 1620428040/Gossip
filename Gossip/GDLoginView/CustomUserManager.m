#import "CustomUserManager.h"

//未被管理的数据类的实现
@class CustomUserMDG;
@interface CustomUser ()
@property (strong,nonatomic)CustomUserMDG *save;
@end

@implementation CustomUser

@synthesize icon;
@synthesize account;
@synthesize password;
@synthesize isSavePassword;
@synthesize isAutoLogin;

@synthesize save;

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:UIImagePNGRepresentation(icon) forKey:@"icon"];
    [aCoder encodeObject:account forKey:@"account"];
    [aCoder encodeObject:password forKey:@"password"];
    [aCoder encodeObject:[NSNumber numberWithBool:isSavePassword] forKey:@"isSavePassword"];
    [aCoder encodeObject:[NSNumber numberWithBool:isAutoLogin] forKey:@"isAutoLogin"];
    
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    icon=[UIImage imageWithData:[aDecoder decodeObjectForKey:@"icon"]];
    account=[aDecoder decodeObjectForKey:@"account"];
    password=[aDecoder decodeObjectForKey:@"password"];
    isSavePassword=[[aDecoder decodeObjectForKey:@"isSavePassword"] boolValue];
    isAutoLogin=[[aDecoder decodeObjectForKey:@"isAutoLogin"] boolValue];
    
    return self;
}
@end

//被管理对象的声明
@interface CustomUserMDG : NSManagedObject

@property (strong,nonatomic)NSData *icon;
@property (strong,nonatomic)NSString *account;
@property (strong,nonatomic)NSString *password;
@property (assign,nonatomic)NSNumber *isSavePassword;
@property (assign,nonatomic)NSNumber *isAutoLogin;

@property (strong,nonatomic)NSNumber *index;

@end
//被管理对象的实现
@implementation CustomUserMDG

@dynamic icon;
@dynamic account;
@dynamic password;
@dynamic isSavePassword;
@dynamic isAutoLogin;

@dynamic index;

@end

//管理类的实现
@interface CustomUserManager()

//调用coredata的控制器
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property NSInteger num;

- (void)saveContext;//与数据库同步
- (NSURL *)applicationDocumentsDirectory;//获取路径

@end

CustomUserManager *shareCustomUserManager;

@implementation CustomUserManager

//调用coredata的控制器的实现
@synthesize managedObjectContext;//上下文对象管理器
@synthesize managedObjectModel;//被管理对象模型
@synthesize persistentStoreCoordinator;//持久化存储协调器

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CustomUserModel" withExtension:@"momd"];
    managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"CustomUser.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    return persistentStoreCoordinator;
}
- (NSManagedObjectContext *)managedObjectContext {
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    managedObjectContext = [[NSManagedObjectContext alloc] init];
    [managedObjectContext setPersistentStoreCoordinator:coordinator];
    return managedObjectContext;
}
- (void)saveContext {
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

//管理方法的实现
@synthesize list,num;

//以下是自定义的方法，修改时注意
#pragma mark 自定义方法——实现
//以上是自定义的方法

+(id)share
{
    if (shareCustomUserManager==nil) {
        shareCustomUserManager=[[self alloc]init];
    }
    return shareCustomUserManager;
}
-(id)init
{
    if ([super init]) {
        num=0;
        managedObjectContext=[self managedObjectContext];
        list=[self getall];
    }
    return self;
}

//读取数据库数据
-(NSMutableArray*)getall
{
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    NSEntityDescription *entityDescription=[NSEntityDescription entityForName:@"CustomUser" inManagedObjectContext:managedObjectContext];
    [request setEntity:entityDescription];
    NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES];
    [request setSortDescriptors:@[sort]];
    NSError *error;
    list=[self translateDataTypeInArray:[managedObjectContext executeFetchRequest:request error:&error]];
    if (error!=nil) {
        NSLog(@"====%@====",error);
    }
    return list;
}
-(NSMutableArray*)translateDataTypeInArray:(NSArray*)input
{
    NSMutableArray *output=[NSMutableArray array];
    for (CustomUserMDG *current in input) {
        CustomUser *new=[[CustomUser alloc]init];
        new.icon=[UIImage imageWithData:current.icon ];
        new.account=current.account ;
        new.password=current.password ;
        new.isSavePassword=[current.isSavePassword  boolValue];
        new.isAutoLogin=[current.isAutoLogin  boolValue];
        
        new.save=current;
        if ([current.index integerValue]>num) {
            num=[current.index integerValue];
        }
        [output addObject:new];
    }
    return output;
}
//将LIST中的数据同步到数据库，如果数据不全，有可能丢失数据
-(void)updata
{
    [self deleteall];
    num=0;
    for (CustomUser *cur in list) {
        [self addObject:cur];
    }
}
//修改单个的数据
-(void)addObject:(CustomUser *)obj
{
    if (![self checkObjectClass:obj]) {
        return;
    }
    [self.list addObject:obj];
    CustomUserMDG *new=[NSEntityDescription insertNewObjectForEntityForName:@"CustomUser" inManagedObjectContext:managedObjectContext];
    new.icon=UIImagePNGRepresentation(obj.icon);
    new.account=obj.account;
    new.password=obj.password;
    new.isSavePassword=[NSNumber numberWithBool:obj.isSavePassword];
    new.isAutoLogin=[NSNumber numberWithBool:obj.isAutoLogin];
    
    new.index=[NSNumber numberWithInteger:num];
    num++;
    obj.save=new;
    //[managedObjectContext save:nil];
}
-(void)changeObject:(CustomUser*)obj
{
    if (![self checkObjectClass:obj]) {
        return;
    }
    obj.save.icon=UIImagePNGRepresentation(obj.icon);
    obj.save.account=obj.account;
    obj.save.password=obj.password;
    obj.save.isSavePassword=[NSNumber numberWithBool:obj.isSavePassword];
    obj.save.isAutoLogin=[NSNumber numberWithBool:obj.isAutoLogin];
    
    //[managedObjectContext save:nil];
}
-(void)deleteObject:(CustomUser *)obj
{
    if (![self checkObjectClass:obj]) {
        return;
    }
    [managedObjectContext deleteObject:obj.save];
    //[managedObjectContext save:nil];
    [self.list removeObject:obj];
}

//其他操作
-(void)printall
{
    list=[self getall];
    for (CustomUser *current in list) {
        NSLog(@"icon=%@  account=%@  password=%@  isSavePassword=%d  isAutoLogin=%d  ",current.icon,current.account,current.password,current.isSavePassword,current.isAutoLogin);
    }
}
-(void)addWithicon:(UIImage *)icon account:(NSString *)account password:(NSString *)password isSavePassword:(BOOL )isSavePassword isAutoLogin:(BOOL )isAutoLogin ;
{
    CustomUser *new=[[CustomUser alloc]init];
    new.icon=icon;
    new.account=account;
    new.password=password;
    new.isSavePassword=isSavePassword;
    new.isAutoLogin=isAutoLogin;
    
    [self addObject:new];
}
-(void)addArray:(NSArray *)array
{
    NSUInteger number=array.count;//防止可变数组中的对象数量的改变导致的死循环
    for (int i=0; i<number; i++) {
        [self addObject:[array objectAtIndex:i]];
    }
}
-(void)deleteArray:(NSArray*)array
{
    NSUInteger number=array.count;//防止可变数组中的对象数量的改变导致的死循环
    for (NSInteger i=number-1; i>=0; i--) {//从列尾开始删除
        [self deleteObject:[array objectAtIndex:i]];
    }
}
-(void)deleteall
{
    [self deleteArray:[self getall]];
}

-(NSArray *)findbyPredicate:(NSPredicate *)predicate
{
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    NSEntityDescription *entityDescription=[NSEntityDescription entityForName:@"CustomUser" inManagedObjectContext:managedObjectContext];
    [request setEntity:entityDescription];
    
    [request setPredicate:predicate];
    
    return [self translateDataTypeInArray:[managedObjectContext executeFetchRequest:request error:nil]];
}
-(NSArray *)findObjectIn:(NSString *)where for:(NSString *)string
{
    return [self findbyPredicate:[NSPredicate predicateWithFormat:@"%K=%@",where,string]];
}

-(NSArray *)requestWithPredicate:(NSPredicate *)predicate sort:(NSArray*)sort
{
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    NSEntityDescription *entityDescription=[NSEntityDescription entityForName:@"CustomUser" inManagedObjectContext:managedObjectContext];
    [request setEntity:entityDescription];
    
    [request setPredicate:predicate];
    [request setSortDescriptors:sort];
    
    return [self translateDataTypeInArray:[managedObjectContext executeFetchRequest:request error:nil]];
}

-(NSDictionary*)dictionaryWithObject:(CustomUser*)obj
{
    if (![self checkObjectClass:obj]) {
        return nil;
    }
    NSMutableArray *keys=[NSMutableArray array];
    NSMutableArray *values=[NSMutableArray array];
    [keys addObject:@"icon"];
    [values addObject:UIImagePNGRepresentation(obj.icon)];
    [keys addObject:@"account"];
    [values addObject:obj.account];
    [keys addObject:@"password"];
    [values addObject:obj.password];
    [keys addObject:@"isSavePassword"];
    [values addObject:[NSNumber numberWithBool:obj.isSavePassword]];
    [keys addObject:@"isAutoLogin"];
    [values addObject:[NSNumber numberWithBool:obj.isAutoLogin]];
    
    return [NSDictionary dictionaryWithObjects:values forKeys:keys];
}
-(CustomUser*)objectWithDictionary:(NSDictionary*)dict
{
    CustomUser *new=[CustomUser new];
    new.icon=[UIImage imageWithData:[dict valueForKey:@"icon"]];
    new.account=[dict valueForKey:@"account"];
    new.password=[dict valueForKey:@"password"];
    new.isSavePassword=[[dict valueForKey:@"isSavePassword"] boolValue];
    new.isAutoLogin=[[dict valueForKey:@"isAutoLogin"] boolValue];
    
    return new;
}
-(NSArray*)dictionaryArrayWithAllObject
{
    return [self dictionaryArrayWithArray:list];
}
-(NSArray *)dictionaryArrayWithArray:(NSArray *)array
{
    NSMutableArray *json=[NSMutableArray array];
    for (CustomUser *cur in array) {
        [json addObject:[self dictionaryWithObject:cur]];
    }
    return json;
}
-(BOOL)saveDictionaryArray:(NSArray *)array
{
    for (NSDictionary *cur in array) {
        [self addObject:[self objectWithDictionary:cur]];
    }
    return YES;
}
-(BOOL)checkObjectClass:(id)obj
{
    if ([obj class]==[[CustomUser new]class]) {
        return YES;
    }
    NSLog(@"对象格式错误，跳过！");
    return NO;
}
@end
