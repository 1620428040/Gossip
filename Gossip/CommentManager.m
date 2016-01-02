#import "CommentManager.h"

//未被管理的数据类的实现
@class CommentMDG;
@interface Comment ()
@property (strong,nonatomic)CommentMDG *save;
@end

@implementation Comment

@synthesize title;
@synthesize author;
@synthesize date;
@synthesize content;

@synthesize save;

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:title forKey:@"title"];
    [aCoder encodeObject:author forKey:@"author"];
    [aCoder encodeObject:date forKey:@"date"];
    [aCoder encodeObject:content forKey:@"content"];
    
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    title=[aDecoder decodeObjectForKey:@"title"];
    author=[aDecoder decodeObjectForKey:@"author"];
    date=[aDecoder decodeObjectForKey:@"date"];
    content=[aDecoder decodeObjectForKey:@"content"];
    
    return self;
}
@end

//被管理对象的声明
@interface CommentMDG : NSManagedObject

@property (strong,nonatomic)NSString *title;
@property (strong,nonatomic)NSString *author;
@property (strong,nonatomic)NSDate *date;
@property (strong,nonatomic)NSString *content;

@property (strong,nonatomic)NSNumber *index;

@end
//被管理对象的实现
@implementation CommentMDG

@dynamic title;
@dynamic author;
@dynamic date;
@dynamic content;

@dynamic index;

@end

//管理类的实现
@interface CommentManager()

//调用coredata的控制器
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property NSInteger num;

- (void)saveContext;//与数据库同步
- (NSURL *)applicationDocumentsDirectory;//获取路径

@end

CommentManager *shareCommentManager;

@implementation CommentManager

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
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CommentModel" withExtension:@"momd"];
    managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Comment.sqlite"];
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
    if (shareCommentManager==nil) {
        shareCommentManager=[[self alloc]init];
    }
    return shareCommentManager;
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
    NSEntityDescription *entityDescription=[NSEntityDescription entityForName:@"Comment" inManagedObjectContext:managedObjectContext];
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
    for (CommentMDG *current in input) {
        Comment *new=[[Comment alloc]init];
        new.title=current.title ;
        new.author=current.author ;
        new.date=current.date ;
        new.content=current.content ;
        
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
    for (Comment *cur in list) {
        [self addObject:cur];
    }
}
//修改单个的数据
-(void)addObject:(Comment *)obj
{
    if (![self checkObjectClass:obj]) {
        return;
    }
    [self.list addObject:obj];
    CommentMDG *new=[NSEntityDescription insertNewObjectForEntityForName:@"Comment" inManagedObjectContext:managedObjectContext];
    new.title=obj.title;
    new.author=obj.author;
    new.date=obj.date;
    new.content=obj.content;
    
    new.index=[NSNumber numberWithInteger:num];
    num++;
    obj.save=new;
    //[managedObjectContext save:nil];
}
-(void)changeObject:(Comment*)obj
{
    if (![self checkObjectClass:obj]) {
        return;
    }
    obj.save.title=obj.title;
    obj.save.author=obj.author;
    obj.save.date=obj.date;
    obj.save.content=obj.content;
    
    //[managedObjectContext save:nil];
}
-(void)deleteObject:(Comment *)obj
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
    for (Comment *current in list) {
        NSLog(@"title=%@  author=%@  date=%@  content=%@  ",current.title,current.author,current.date,current.content);
    }
}
-(void)addWithtitle:(NSString *)title author:(NSString *)author date:(NSDate *)date content:(NSString *)content ;
{
    Comment *new=[[Comment alloc]init];
    new.title=title;
    new.author=author;
    new.date=date;
    new.content=content;
    
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
    NSEntityDescription *entityDescription=[NSEntityDescription entityForName:@"Comment" inManagedObjectContext:managedObjectContext];
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
    NSEntityDescription *entityDescription=[NSEntityDescription entityForName:@"Comment" inManagedObjectContext:managedObjectContext];
    [request setEntity:entityDescription];
    
    [request setPredicate:predicate];
    [request setSortDescriptors:sort];
    
    return [self translateDataTypeInArray:[managedObjectContext executeFetchRequest:request error:nil]];
}

-(NSDictionary*)dictionaryWithObject:(Comment*)obj
{
    if (![self checkObjectClass:obj]) {
        return nil;
    }
    NSMutableArray *keys=[NSMutableArray array];
    NSMutableArray *values=[NSMutableArray array];
    [keys addObject:@"title"];
    [values addObject:obj.title];
    [keys addObject:@"author"];
    [values addObject:obj.author];
    [keys addObject:@"date"];
    [values addObject:obj.date];
    [keys addObject:@"content"];
    [values addObject:obj.content];
    
    return [NSDictionary dictionaryWithObjects:values forKeys:keys];
}
-(Comment*)objectWithDictionary:(NSDictionary*)dict
{
    Comment *new=[Comment new];
    new.title=[dict valueForKey:@"title"];
    new.author=[dict valueForKey:@"author"];
    new.date=[dict valueForKey:@"date"];
    new.content=[dict valueForKey:@"content"];
    
    return new;
}
-(NSArray*)dictionaryArrayWithAllObject
{
    return [self dictionaryArrayWithArray:list];
}
-(NSArray *)dictionaryArrayWithArray:(NSArray *)array
{
    NSMutableArray *json=[NSMutableArray array];
    for (Comment *cur in array) {
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
    if ([obj class]==[[Comment new]class]) {
        return YES;
    }
    NSLog(@"对象格式错误，跳过！");
    return NO;
}
@end
