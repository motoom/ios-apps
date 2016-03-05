
//  A configuration is a group of vessels, each with a certain capacity and contents, and a unique hash value.
// https://www.hackingwithswift.com/example-code/system/how-to-copy-objects-in-swift-using-copy

import Foundation

class VesselConfiguration: NSObject, NSCopying {
    var vessels: [Vessel] = []
    override var hashValue: Int {
        get { return 1<<0 | 2<<4 | 3<<8 | 4<<12 | 5<<16 } // alleen de contents hoeven gehashed te worden, de capacities varieren niet tijdens oplossen v e puzzle
        }
    override init() {
        }
	func copyWithZone(zone: NSZone) -> AnyObject {
		let copy = VesselConfiguration()
		return copy
        }

    }


class Person: NSObject, NSCopying {
	var firstName: String
	var lastName: String
	var age: Int

	init(firstName: String, lastName: String, age: Int) {
		self.firstName = firstName
		self.lastName = lastName
		self.age = age
	}

	func copyWithZone(zone: NSZone) -> AnyObject {
		let copy = Person(firstName: firstName, lastName: lastName, age: age)
		return copy
	}
}

func test() {
    let paul = Person(firstName: "Paul", lastName: "Hudson", age: 35)
    let sophie = paul.copy() as! Person

    sophie.firstName = "Sophie"
    sophie.age = 5

    print("\(paul.firstName) \(paul.lastName) is \(paul.age)")
    print("\(sophie.firstName) \(sophie.lastName) is \(sophie.age)")
    }

