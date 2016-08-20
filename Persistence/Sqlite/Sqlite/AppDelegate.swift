
//  AppDelegate.swift

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var db = TelefoonDb.sharedInstance

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        db.open("telefoon.db")
        return true
        }

    func applicationWillTerminate(application: UIApplication) {
        db.close()
        }
}
