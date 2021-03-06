
//  ShoppingList.swift

import Foundation


class ShoppingListItem: NSObject, NSCoding {

    var name = ""
    var quantity = 0

    init(_ name: String, _ quantity: Int) {
        self.name = name
        self.quantity = quantity
        }

    // MARK: Persistence

    struct Keys {
        static let name = "name"
        static let quantity = "quantity"
        }

    required init(coder unarchiver: NSCoder) {
        super.init()
        name = unarchiver.decodeObjectForKey(Keys.name) as! String
        quantity = unarchiver.decodeObjectForKey(Keys.quantity) as! Int
        }

    func encodeWithCoder(archiver: NSCoder) {
        archiver.encodeObject(name, forKey: Keys.name)
        archiver.encodeObject(quantity, forKey: Keys.quantity)
        }

    }

/*
struct Shopper {
    var name: String
    }
*/

class Shopper: NSObject, NSCoding {
    var name = ""

    init(_ name: String) {
        self.name = name
        }

    struct Keys {
        static let name = "name"
        }

    required init(coder unarchiver: NSCoder) {
        super.init()
        name = unarchiver.decodeObjectForKey(Keys.name) as! String
        }

    func encodeWithCoder(archiver: NSCoder) {
        archiver.encodeObject(name, forKey: Keys.name)
        }
    }

class ShoppingList: NSObject, NSCoding {

    var shop = ""
    var when = NSDate()
    var shopper: Shopper? // = Shopper(name: "Michiel")
    var items = [ShoppingListItem]()

    init(_ shop: String, _ when: NSDate) {
        self.shop = shop
        self.when = when
        }

    func addItem(item: ShoppingListItem) {
        items.append(item)
        }

    func printMe() {
        print("    ----")
        print("    I'm a shoppinglist for \(shop) with \(items.count) items, to be purchased on \(when) by \(shopper?.name):")
        for item in items {
            print ("        \(item.quantity)x \(item.name)")
            }
        let address = String(format: "%p", self)
        print("    I live in memory at address \(address)")
        print("    ----")
        print("")
        }

    // MARK: Persistence

    struct Keys {
        static let shop = "shop"
        static let when = "when"
        static let shopper = "shopper"
        static let items = "items"
        }

    required init(coder unarchiver: NSCoder) {
        super.init()
        shop = unarchiver.decodeObjectForKey("shop") as! String
        when = unarchiver.decodeObjectForKey(Keys.when) as! NSDate
        shopper = unarchiver.decodeObjectForKey(Keys.shopper) as? Shopper
        items = unarchiver.decodeObjectForKey(Keys.items) as! [ShoppingListItem]
        }

    func encodeWithCoder(archiver: NSCoder) {
        archiver.encodeObject(shop, forKey: "shop")
        archiver.encodeObject(when, forKey: Keys.when)
        // archiver.encodeObject(shopper!.name, forKey: Keys.shopper)
        archiver.encodeObject(shopper, forKey: Keys.shopper)
        archiver.encodeObject(items, forKey: Keys.items)
        }

    }


func ExampleShoppingList() -> ShoppingList
{
    let today = NSDate()
    let tomorrow = NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: 1, toDate: today, options: NSCalendarOptions.MatchStrictly)!

    let sl = ShoppingList("ALDI", tomorrow)
    sl.addItem(ShoppingListItem("Cauliflower", 1))
    sl.addItem(ShoppingListItem("Egg", 6))
    sl.addItem(ShoppingListItem("Curry paste", 1))
    sl.addItem(ShoppingListItem("Yoghurt", 2))
    return sl
}


func ShoppingListTest()
{
    let s = ExampleShoppingList()
    s.printMe()
}
