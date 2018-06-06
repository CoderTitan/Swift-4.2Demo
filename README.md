
# Swift 4.2的新特性更新


![Xcode 10](http://p7hfnfk6u.bkt.clouddn.com/Snip20180605_2.png)

<!--more-->

- 原文博客地址[Swift 4.2 新特性更新](https://www.titanjun.top/2018/06/06/Swift%204.2%20%E6%96%B0%E7%89%B9%E6%80%A7%E6%9B%B4%E6%96%B0/)
- `Swift 4.2`是`Swift 4.0`发布以来的第二次小更新, 继上次`Xcode 9.3`和`Swift 4.1`发布以来也有俩月有余
- 上个版本[Swift 4.1 的新特性](https://www.titanjun.top/2018/04/24/Swift%204.1%20%E7%9A%84%E6%96%B0%E7%89%B9%E6%80%A7/)中介绍了条件一致性和哈希索引等相关更新
- 随着`Xcode Bate 10`的发布, `Swift 4.2`也发布了测试版, 相信也带来了很多优化和改进
- 下面运行环境都是在`Xcode Bate 10`环境中进行的



### `CaseInterable`协议
- [SE-0194](https://github.com/apple/swift-evolution/blob/master/proposals/0194-derived-collection-of-enum-cases.md)介绍了在`Swift 4.2`中新增的一个新的`CaseIterable`协议
- 定义的枚举遵循`CaseIterable`协议后, 编译时`Swift` 会自动合成一个`allCases`属性，是包含枚举的所有`case`项的数组

```swift
enum NetState: CaseIterable {
    case wifi
    case hotWifi
    case mobile
    case none
}
```

> 之后我们在其他地方调用改枚举时就可以获取到`allCase`属性, 如下

```swift
print(NetState.allCases)
print("case个数: " + "\(NetState.allCases.count)")

for item in NetState.allCases {
    print(item)
}

// 输出结果:
[__lldb_expr_9.NetState.wifi, __lldb_expr_9.NetState.hotWifi, __lldb_expr_9.NetState.mobile, __lldb_expr_9.NetState.none]

case个数: 4

wifi
hotWifi
mobile
none
```

<div class="note warning"><p>这个`allCases`的自动合成仅替换没有参数的`case`值, 但是如果需要你需要所有`case`值, 可以重写`allCases`属性自己添加</p></div>

```swift
enum FoodKind: CaseIterable {
    //此处, 必须重写allCases属性, 否则报错
    static var allCases: [FoodKind] {
        return [.apple, .pear, .orange(look: false)]
    }
    
    case apple
    case pear
    case orange(look: Bool)
}

for item in FoodKind.allCases {
    print(item)
}

/*
 * 输出结果:
 apple
 pear
 orange(look: false)
*/
```

<div class="note warning"><p>如果有枚举项标记为`unavailable`，则默认无法合成`allCases`，只能依靠自己来手动合成</p></div>

```swift
enum CarKind: CaseIterable {
    //当有unavailable修饰的case值, 也必须重写allCase属性
    static var allCases: [CarKind] {
        return [.bwm, .ford]
    }
    
    case bwm
    case ford
    
    @available(*, unavailable)
    case toyota
}

for item in CarKind.allCases {
    print(item)
}

/*
 输出结果:
 bwm
 ford
 */
```

### `#warning`和`#error`编译指令
- [SE-0196](https://github.com/apple/swift-evolution/blob/master/proposals/0196-diagnostic-directives.md)介绍新的编译指令来强制`Xcode`在`build`时生成警告或错误信息
- 这两个指令是`#warning`和`#error`，前者会强制`Xcode`在生成你的代码时发出一个警告，后者会发出一个编译错误这样你的代码就完全不能编译
- `#warning`主要用于提醒你或者别人一些工作还没有完成，`Xcode`模板常使用`#warning`标记一些你需要替换成自己代码的方法存根(`method stubs`)。
- `#error`主要用于如果你发送一个库，需要其他开发者提供一些数据。比如，一个网络 `API`的认证密码，你需要用户输入它们自己的密码，就使用`#error`在继续之前强制他们更改这行代码

![image](http://p7hfnfk6u.bkt.clouddn.com/Snip20180605_3.png)

<div class="note warning"><p>`#warning`和`#error`可以和已存的`#if`编译指令共同使用，并且只有在条件为`true`时才会激活。例如：</p></div>

```swift
#if os(macOS)
#error("MyLibrary is not supported on macOS.")
#endif
```

### 动态成员查找
- [SE-0195](https://github.com/apple/swift-evolution/blob/master/proposals/0195-dynamic-member-lookup.md)介绍了一个方法，让`Swift`更接近类似`Python`的脚本语言, 让`Swift`可以以属性访问的方式调用下标操作
- 这让我们可以像`Python`一样来访问字典值，不过是以类型安全的方式, 其核心在于:
  - `@dynamicMemberLookup`: 可以让`Swift`以一种下标方法去进行属性访问
  - `subscript(dynamicMember:)`：可以通过所请求属性的字符串名得到，并且可以返回你想要的任何值
- 我们可以创建一个`Titan`结构，并且从一个字典读取它的值

```swift
struct Titan {
    subscript(dynamicMember member: String) -> String {
        let properties = ["name": "Titanjun", "city": "Hang"]
        return properties[member, default: "0"] //默认值
    }
}
```

- 可以看到上述代码按字符串接收成员名字，并返回一个字符串。
- 从内部看它只是在一个字典中查找这个成员名字并返回它的值
- 即使取不到对应的值, 也会以默认值的形式返回, 上述结构的代码可以这么写

```swift
let titan = Titan()

print(titan.name)
print(titan.city)
print(titan.age)

// 输出:
Titanjun
Hang
0
```

<div class="note default"><p>处理多种不同的类型</p></div>

- 上述`subscript(dynamicMember:)` 方法必须返回一串字符，这体现了`Swift`的类型安全性
- 如果你想要多种不同的类型, 就执行不同的`subscript(dynamicMember:)`方法

```swift
@dynamicMemberLookup
struct Titan {
    subscript(dynamicMember member: String) -> String {
        let properties = ["name": "Titanjun", "city": "Hang"]
        return properties[member, default: "0"] //默认值
    }
    
    subscript(dynamicMember member: String) -> Int {
        let properties = ["age": 20, "source": 99]
        return properties[member, default: 0] //默认值
    }
}

```

<div class="note warning"><p>需要注意的是: 这里取值的时候, 必须注明所取得值的类型
</p></div>

```swift
let titan = Titan()
let name: String = titan.name
let city: String = titan.city
let age: Int = titan.age
let jun: String = titan.jun

print(jun)
print("name = \(name), city = \(city), age = \(age)")

//输出:
0
name = Titanjuun, city = Hang, age = 20
```

### 增强的条件一致性
条件一致性在[Swift 4.1](https://www.titanjun.top/2018/04/24/Swift%204.1%20%E7%9A%84%E6%96%B0%E7%89%B9%E6%80%A7/)中引入，一个类型的所有元素如果符合`Hashable`协议，则类型自动符合`Hashable`协议

```swift
//定义Purchaseable协议
protocol Purchaseable {
    func buy()
}

//定义一个符合该协议的结构体
struct Book: Purchaseable {
    func buy() {
        print("You bought a book")
    }
}

//数组遵循该协议, 并且每一个元素也遵循该协议
extension Array: Purchaseable where Element: Purchaseable {
    func buy() {
        for item in self {
            item.buy()
        }
    }
}
```

<div class="note danger"><p>下面我们在Swift 4.1中运行如下代码, 会发现崩溃
</p></div>

```seift
let items: Any = [Book(), Book(), Book()]
 
if let books = items as? Purchaseable {
    books.buy()
}
```

- 如果你收到一种类型的数据，想要检查它是否可以被转化为一个条件一致性协议, 这种在`Swift 4.1`中是不支持的, 但是在`Swift 4.2`中却可以很好的解决
- 另外, 对`Hashable`一致性自动合并的支持在`Swift 4.2`被大幅提高，来自`Swift` 标准库的几个内置类型，包括`optionals`, `arrays`, `dictionaries`和 `ranges`, 现在当他们的元素符合`Hashable`时会自动符合`Hashable` 协议


### 本地集合元素移除
[SE-0197](https://github.com/apple/swift-evolution/blob/master/proposals/0197-remove-where.md)介绍一个新的`removeAll(where:)`方法, 高效地执行根据条件删除操作

```swift
var pythons = ["John", "Michael", "Graham", "Terry", "Eric", "Terry"]
pythons.removeAll { $0.hasPrefix("Terry") }
print(pythons)

//输出: ["John", "Michael", "Graham", "Eric"]
```

<div class="note warning"><p>对比`filter`过滤方法
</p></div>

```swift
var python2 = ["John", "Michael", "Graham", "Terry", "Eric", "Terry"]
python2 = python2.filter { !$0.hasPrefix("Terry") }
print(python2)
```

这并不是非常有效地使用内存，它指定了你不想要的东西，而不是你想要的东西


### 随机数字的生成和洗牌
- [SE-0202](https://github.com/apple/swift-evolution/blob/master/proposals/0202-random-unification.md)中`Swift`引入了新的随机数`API`
- 可以通过调用`random()`随机数方法来生成一个随机数, 只需提供一个随机数范围即可

```swift
let ranInt = Int.random(in: 0..<5)
let ranFloat = Float.random(in: 0..<5)
let ranDouble = Double.random(in: 0..<5)
let ranCGFloat = CGFloat.random(in: 0..<5)
let ranBOOL = Bool.random()
```

<div class="note warning"><p>对数组进行重新洗牌
</p></div>

`SE-0202`还支持使用新方法`shuffle()`和`shuffled()`方法对数组元素进行重新随机排序

```swift
var albums = ["Red", "1989", "Reputation"]

// 没有返回值
albums.shuffle()

// 有返回值, 重新返回一个数组
let shuffled = albums.shuffled()
```

<div class="note warning"><p>获取数组中的一个随机元素
</p></div>

`randomElement()`: 数组的一个新方法, 如果数组部位空, 则返回数组中的一个随机元素, 否则返回`nil`

```swift
if let random = albums.randomElement() {
    print("The random album is \(random).")
}
```

### 更简单，更安全的哈希
- [SE-0206](https://github.com/apple/swift-evolution/blob/master/proposals/0206-hashable-enhancements.md)介绍了在`Swift 4.1`中简化了我们使自定义类型符合`Hashable`协议的方式
- `Swift 4.2`引入了一个新的`Hasher`结构，它提供了一个随机播种的通用散列函数

```swift
struct iPad: Hashable {
    var serialNumber: String
    var capacity: Int

    func hash(into hasher: inout Hasher) {
        hasher.combine(serialNumber)
    }
}
```

- 可以通过`combine()`重复调用将更多属性添加到散列，并且添加属性的顺序会影响完成的散列值。
- 还可以将其`Hasher`用作独立散列发生器：只要提供您想散列的任何值，然后调用`finalize()`以生成最终值

```swift
let first = iPad(serialNumber: "12345", capacity: 256)
let second = iPad(serialNumber: "54321", capacity: 512)

var hasher = Hasher()
hasher.combine(first)
hasher.combine(second)
let hash = hasher.finalize()
```

- `Hasher`每次散列对象时都会使用随机种子，这意味着任何对象的散列值在您的应用运行之间有效地保证是不同的
- 这又意味着您添加到集合或字典中的元素很可能在您每次运行应用程序时都有不同的顺序


### 检查序列元素是否符合条件
[SE-0207](https://github.com/apple/swift-evolution/blob/master/proposals/0207-containsOnly.md)提供了`allSatisfy()`一种检查序列中的所有元素是否满足条件的新方法

```swift
//判断数组的所有元素是否全部大于85
let scores = [86, 88, 95, 92]
//返回一个BOOL
let passed = scores.allSatisfy({ $0 > 85 })
print(passed)

//输出: true
```


### 布尔切换
[SE-0199](https://github.com/apple/swift-evolution/blob/master/proposals/0199-bool-toggle.md)引入了一种新的`toggle()`方法, 可以将布尔值取反, 实现代码如下:

```swift
extension Bool {
   mutating func toggle() {
      self = !self
   }
}
```

<div class="note success"><p>测试代码
</p></div>

```
var isSwift = true
//toggle函数没有返回值
isSwift.toggle()
print(isSwift)
```

### 
- [SE-0204](https://github.com/apple/swift-evolution/blob/master/proposals/0204-add-last-methods.md)介绍了数组中的获取满足条件的数组中的最后一个元素或者索引值
- 在`Swift 4.1`中我们只能取得`first`值, 却无法获取数组中的最后一个值(或者要用大量代码实现)
- 在`Swift 4.2`中提供了`last(where:)`和`lastIndex(where:)`方法来获取数组中满足条件的最后的元素和索引值

```swift
//获取满足条件的数组中的第一个值
let a = [20, 30, 10, 40, 20, 30, 10, 40, 20]
print(a.first(where: { $0 > 25 }))  
print(a.index(where: { $0 > 25 }))
print(a.index(of: 10))

//输出:
30
1
2
```

<div class="note success"><p>`Swift 4.2`中新增的`last`函数
</p></div>

```swift
//在Swift4.1中
print((a.reversed().index(where: { $0 > 25 })?.base).map({ a.index(before: $0) }))
//输出: 7

//Swift 4.2
//获取满足条件的元素
print(a.last(where: { $0 > 25 }))   //40
//获取满足条件的元素的索引
print(a.lastIndex(where: { $0 > 25 }))   //7
```



### 展望Swift 5.0
- 苹果形容`Swift 4.2`为”为了实现Swift 5中ABI稳定性的中继点”, 想必`Swift 4.1`和`Swift 4.2`的发布也是为了`Swift 5.0`做一个铺垫
- 最后还是期待`Swift 5.0`能够带来更加稳定的`API`



#### 附录参考
- [What’s new in Swift 4.2?](https://www.hackingwithswift.com/articles/77/whats-new-in-swift-4-2)
- [Swift 4.2 Release Process](https://swift.org/blog/4-2-release-process/)
- [Swift evolution](https://github.com/apple/swift-evolution/tree/master/proposals)

