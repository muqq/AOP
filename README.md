### Practice
* 熟悉Objective-C`Runtime`以及AOP的實作

### 心得
之前雖然知道Objective-C是動態語言，但實際上幾乎沒有接觸到這塊，<br />
這次練習了如何在`Runtime`時替Class加方法以及替換方法，之後實做<br/>
AOP時，練習了如何處理當Object找不到對應方法時要怎麼做。<br />
在做練習時需要先了解`SEL`、`IMP`、`METHOD`、`NSMethodSignature`<br />
之後開始練習，最常用的方法是
```
class_addMethod(Class cls, SEL name, IMP imp, const char *types);
```
上面方法最後要注意的是要回傳一串字元陣列，至於要回傳什麼，<br />
可以參考https://goo.gl/n2NWmO ，再來下面有三個function
```
-(id)forwardingTargetForSelector:(SEL)aSelector
```
```
-(NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
```
```
-(void)forwardInvocation:(NSInvocation *)anInvocation
```
他們是當一個Object找不到對應的Selector會觸發的，在實作之前必需了解他們的機制。<br />
最後還有一個方便的東西`_objc_msgForward`，他是一個`IMP`，<br />
當把一個方法的實作改成它時，上面的`forwardingTargetForSelector:(SEL)aSelector`就一定會被觸發。
