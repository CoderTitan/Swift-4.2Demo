import UIKit



enum NetState: CaseIterable {
    case wifi
    case hotWifi
    case mobile
    case none
}

print(NetState.allCases)
print("case个数: " + "\(NetState.allCases.count)")

for item in NetState.allCases {
    print(item)
}

print("------------FoodKind----------------")

enum FoodKind: CaseIterable {
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


print("------------CarKind----------------")

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

print("------------werror和warning----------------")
fileprivate func getWarning() {
    for i in 0...9 {
        if i < 5 {
//            #warning("这是一个警告")
        }
    }
}

fileprivate func getError() {
    for i in 0...9 {
        if i < 5 {
//            #error("这是一个错误")
        }
    }
}

print("-------------条件一致性---------------")

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

let titan = Titan()
let name: String = titan.name
let city: String = titan.city
let age: Int = titan.age
let jun: String = titan.jun

print(jun)
print("name = \(name), city = \(city), age = \(age)")


@dynamicMemberLookup
protocol Subscripting { }

extension Subscripting {
    subscript(dynamicMember member: String) -> String {
        return "This is coming from the subscript"
    }
}

extension String: Subscripting { }
let str = "Hello, Swift"
print(str.username)


print("--------------本地集合元素移除-----------------")

var pythons = ["John", "Michael", "Graham", "Terry", "Eric", "Terry"]
pythons.removeAll { $0.hasPrefix("Terry") }
print(pythons)

var python2 = ["John", "Michael", "Graham", "Terry", "Eric", "Terry"]
python2 = python2.filter { !$0.hasPrefix("Terry") }
print(python2)


print("--------随机数字的生成和洗牌-----------")
let ranInt = Int.random(in: 0..<5)
let ranFloat = Float.random(in: 0..<5)
let ranDouble = Double.random(in: 0..<5)
let ranCGFloat = CGFloat.random(in: 0..<5)
let ranBOOL = Bool.random()

let ranInt2 = Int.random(in: 0...2)
print(ranInt2)

print(Int.random(in: 0...4, using: &Random.default))

//shuffle()和shuffled()
var albums = ["Red", "1989", "Reputation"]
albums.shuffle()
print(albums)
print(albums.shuffled())

if let random = albums.randomElement() {
    print("randomElement: \(random)")
}


print("--------更简单，更安全的哈希-----------")

struct iPad: Hashable {
    var serialNumber: String
    var capacity: Int
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(serialNumber)
    }
}


let first = iPad(serialNumber: "12345", capacity: 256)
let second = iPad(serialNumber: "54321", capacity: 512)

var hasher = Hasher()
hasher.combine(first)
hasher.combine(second)
let hash = hasher.finalize()

print(hash)


print("--------检查序列元素是否符合条件-----------")

//判断数组的所有元素是否全部大于85
let scores = [86, 88, 95, 92]
let passed = scores.allSatisfy({ $0 > 85 })
print(passed)


print("--------布尔切换-----------")

var isSwift = true
isSwift.toggle()
print(isSwift)


print("--------数组的last函数-----------")

let a = [20, 30, 10, 40, 20, 30, 10, 40, 20]
print(a.first(where: { $0 > 25 }))
print(a.index(where: { $0 > 25 }))
print(a.index(of: 10))
//Swift4.1
print((a.reversed().index(where: { $0 > 25 })?.base).map({ a.index(before: $0) }))

//Swift 4.2
print(a.last(where: { $0 > 25 }))
print(a.lastIndex(where: { $0 > 25 }))









