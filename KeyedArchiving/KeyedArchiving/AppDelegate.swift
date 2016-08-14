
//  AppDelegate.swift

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    }


/* Remarks: 

    // First try with a simple array:
    let one = [ShoppingListItem("Egg", 6), ShoppingListItem("Milk", 1)]
    let res = Archiver.save(one, "items.dat")
    print(res, one)

    let two = Archiver.load("items.dat") as? [ShoppingListItem] ?? [ShoppingListItem]()
    print(two)

    :
    :

    These initializers aren't necessary:

    // Initialize a ShoppingList object from a dictionary
    init(dictionary: [String : AnyObject]) {
        self.name = dictionary[Keys.name] as! String
        self.quantity = dictionary[Keys.quantity] as! Int
        }

    // Initialize a ShoppingListItem object from a dictionary
    init(dictionary: [String : AnyObject]) {
        self.shop = dictionary[Keys.shop] as! String
        self.when = dictionary[Keys.when] as! NSDate
        self.items = dictionary[Keys.items] as! [ShoppingListItem]
        }

*/


/* TODOs

    let manager = NSFileManager.defaultManager()
    let url = manager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first as! NSURL
    return url.URLByAppendingPathComponent("objectsArray").path!

*/


/*
    Inspired by: https://www.hackingwithswift.com/example-code/system/how-to-save-and-load-objects-with-nskeyedarchiver-and-nskeyedunarchiver

    and: http://mhorga.org/2015/08/25/ios-persistence-with-nscoder-and-nskeyedarchiver.html
*/
