
//  ViewController.swift

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Create and show the shopping list.
        let first = ExampleShoppingList()
        print("The first list, the one that is going to be saved in an archive, is:")
        first.printMe()

        // Save it to an archive file in the app's documents directory on the iPhone.
        let res = Archiver.save(first, "shoppinglistarchive.dat")
        print("Result of save is \(res)")

        // Load it back into a new object.
        if let two = Archiver.load("shoppinglistarchive.dat") as? ShoppingList {
            print("Succesfully loaded the shopping list")
            two.printMe()
            }
        else {
            print("Warning: Unable to load shoppinglist")
            }

        // TIP: To inspect the saved archive, run this app on a real device, go in Xcode to Window/Devices, highlight the iDevice,
        // highlight the 'KeyedArchiving' line, click the little cog on the bottom of the list, choose 'Download container...' from
        // the popup menu and save the container to your desktop. Then, on your desktop, rightclick the container and choose
        // 'Show package contents'. With a binary file viewer like 0xED you can inspect the files that the app saved into the
        // Documents directory of the container. This also works for saved images, textfiles, etc...
        }
}

