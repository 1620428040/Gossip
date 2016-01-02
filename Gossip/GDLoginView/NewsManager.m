#import "NewsManager.h"

//未被管理的数据类的实现
@class NewsMDG;
@interface News ()
@property (strong,nonatomic)NewsMDG *save;
@end

@implementation News

@synthesize title;
@synthesize author;
@synthesize date;
@synthesize skim;
@synthesize believable;
@synthesize doubt;
@synthesize describe;
@synthesize content;

@synthesize save;

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:title forKey:@"title"];
    [aCoder encodeObject:author forKey:@"author"];
    [aCoder encodeObject:date forKey:@"date"];
    [aCoder encodeObject:[NSNumber numberWithInteger:skim] forKey:@"skim"];
    [aCoder encodeObject:[NSNumber numberWithInteger:believable] forKey:@"believable"];
    [aCoder encodeObject:[NSNumber numberWithInteger:doubt] forKey:@"doubt"];
    [aCoder encodeObject:describe forKey:@"describe"];
    [aCoder encodeObject:content forKey:@"content"];
    
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    title=[aDecoder decodeObjectForKey:@"title"];
    author=[aDecoder decodeObjectForKey:@"author"];
    date=[aDecoder decodeObjectForKey:@"date"];
    skim=[[aDecoder decodeObjectForKey:@"skim"] integerValue];
    believable=[[aDecoder decodeObjectForKey:@"believable"] integerValue];
    doubt=[[aDecoder decodeObjectForKey:@"doubt"] integerValue];
    describe=[aDecoder decodeObjectForKey:@"describe"];
    content=[aDecoder decodeObjectForKey:@"content"];
    
    return self;
}
@end

//被管理对象的声明
@interface NewsMDG : NSManagedObject

@property (strong,nonatomic)NSString *title;
@property (strong,nonatomic)NSString *author;
@property (strong,nonatomic)NSDate *date;
@property (assign,nonatomic)NSNumber *skim;
@property (assign,nonatomic)NSNumber *believable;
@property (assign,nonatomic)NSNumber *doubt;
@property (strong,nonatomic)NSString *describe;
@property (strong,nonatomic)NSString *content;

@property (strong,nonatomic)NSNumber *index;

@end
//被管理对象的实现
@implementation NewsMDG

@dynamic title;
@dynamic author;
@dynamic date;
@dynamic skim;
@dynamic believable;
@dynamic doubt;
@dynamic describe;
@dynamic content;

@dynamic index;

@end

//管理类的实现
@interface NewsManager()

//调用coredata的控制器
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property NSInteger num;

- (void)saveContext;//与数据库同步
- (NSURL *)applicationDocumentsDirectory;//获取路径

@end

NewsManager *shareNewsManager;

@implementation NewsManager

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
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"NewsModel" withExtension:@"momd"];
    managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"News.sqlite"];
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
    if (shareNewsManager==nil) {
        shareNewsManager=[[self alloc]init];
    }
    return shareNewsManager;
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
    NSEntityDescription *entityDescription=[NSEntityDescription entityForName:@"News" inManagedObjectContext:managedObjectContext];
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
    for (NewsMDG *current in input) {
        News *new=[[News alloc]init];
        new.title=current.title ;
        new.author=current.author ;
        new.date=current.date ;
        new.skim=[current.skim  integerValue];
        new.believable=[current.believable  integerValue];
        new.doubt=[current.doubt  integerValue];
        new.describe=current.describe ;
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
    for (News *cur in list) {
        [self addObject:cur];
    }
}
//修改单个的数据
-(void)addObject:(News *)obj
{
    if (![self checkObjectClass:obj]) {
        return;
    }
    [self.list addObject:obj];
    NewsMDG *new=[NSEntityDescription insertNewObjectForEntityForName:@"News" inManagedObjectContext:managedObjectContext];
    new.title=obj.title;
    new.author=obj.author;
    new.date=obj.date;
    new.skim=[NSNumber numberWithInteger:obj.skim];
    new.believable=[NSNumber numberWithInteger:obj.believable];
    new.doubt=[NSNumber numberWithInteger:obj.doubt];
    new.describe=obj.describe;
    new.content=obj.content;
    
    new.index=[NSNumber numberWithInteger:num];
    num++;
    obj.save=new;
    //[managedObjectContext save:nil];
}
-(void)changeObject:(News*)obj
{
    if (![self checkObjectClass:obj]) {
        return;
    }
    obj.save.title=obj.title;
    obj.save.author=obj.author;
    obj.save.date=obj.date;
    obj.save.skim=[NSNumber numberWithInteger:obj.skim];
    obj.save.believable=[NSNumber numberWithInteger:obj.believable];
    obj.save.doubt=[NSNumber numberWithInteger:obj.doubt];
    obj.save.describe=obj.describe;
    obj.save.content=obj.content;
    
    //[managedObjectContext save:nil];
}
-(void)deleteObject:(News *)obj
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
    for (News *current in list) {
        NSLog(@"title=%@  author=%@  date=%@  skim=%ld  believable=%ld  doubt=%ld  describe=%@  content=%@  ",current.title,current.author,current.date,current.skim,current.believable,current.doubt,current.describe,current.content);
    }
}
-(void)addWithtitle:(NSString *)title author:(NSString *)author date:(NSDate *)date skim:(NSInteger )skim believable:(NSInteger )believable doubt:(NSInteger )doubt describe:(NSString *)describe content:(NSString *)content ;
{
    News *new=[[News alloc]init];
    new.title=title;
    new.author=author;
    new.date=date;
    new.skim=skim;
    new.believable=believable;
    new.doubt=doubt;
    new.describe=describe;
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
    NSEntityDescription *entityDescription=[NSEntityDescription entityForName:@"News" inManagedObjectContext:managedObjectContext];
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
    NSEntityDescription *entityDescription=[NSEntityDescription entityForName:@"News" inManagedObjectContext:managedObjectContext];
    [request setEntity:entityDescription];
    
    [request setPredicate:predicate];
    [request setSortDescriptors:sort];
    
    return [self translateDataTypeInArray:[managedObjectContext executeFetchRequest:request error:nil]];
}

-(NSDictionary*)dictionaryWithObject:(News*)obj
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
    [keys addObject:@"skim"];
    [values addObject:[NSNumber numberWithInteger:obj.skim]];
    [keys addObject:@"believable"];
    [values addObject:[NSNumber numberWithInteger:obj.believable]];
    [keys addObject:@"doubt"];
    [values addObject:[NSNumber numberWithInteger:obj.doubt]];
    [keys addObject:@"describe"];
    [values addObject:obj.describe];
    [keys addObject:@"content"];
    [values addObject:obj.content];
    
    return [NSDictionary dictionaryWithObjects:values forKeys:keys];
}
-(News*)objectWithDictionary:(NSDictionary*)dict
{
    News *new=[News new];
    new.title=[dict valueForKey:@"title"];
    new.author=[dict valueForKey:@"author"];
    new.date=[dict valueForKey:@"date"];
    new.skim=[[dict valueForKey:@"skim"] integerValue];
    new.believable=[[dict valueForKey:@"believable"] integerValue];
    new.doubt=[[dict valueForKey:@"doubt"] integerValue];
    new.describe=[dict valueForKey:@"describe"];
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
    for (News *cur in array) {
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
    if ([obj class]==[[News new]class]) {
        return YES;
    }
    NSLog(@"对象格式错误，跳过！");
    return NO;
}
@end
