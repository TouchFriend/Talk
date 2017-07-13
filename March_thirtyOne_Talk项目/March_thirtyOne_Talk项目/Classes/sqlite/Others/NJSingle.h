#define singleH(name) + (instancetype)shared##name;
//非ARC模式下
#if __has_feature(objc_arc)
#define singleM(name) static id _instance;\
+ (instancetype)allocWithZone:(struct _NSZone *)zone\
{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
if(_instance == nil)\
{\
_instance = [super allocWithZone:zone];\
}\
});\
return _instance;\
}\
- (id)copy\
{\
return _instance;\
}\
- (id)mutableCopy\
{\
return _instance;\
}\
+ (instancetype)shared##name\
{\
return [[self alloc]init];\
}
//非MRC
#else
#define singleM(name) static id _instance;\
+ (instancetype)allocWithZone:(struct _NSZone *)zone\
{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
if(_instance == nil)\
{\
_instance = [super allocWithZone:zone];\
}\
});\
return _instance;\
}\
- (id)copy\
{\
return _instance;\
}\
- (id)mutableCopy\
{\
return _instance;\
}\
+ (instancetype)shared##name\
{\
return [[self alloc]init];\
}\
- (oneway void)release\
{\
\
}\
- (instancetype)retain\
{\
    return _instance;\
}\
- (NSUInteger)retainCount\
{\
    return MAXFLOAT;\
}
#endif
