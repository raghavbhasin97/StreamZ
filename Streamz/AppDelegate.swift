import UIKit
import GoogleCast

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    fileprivate func setupAppearance() {
        UITabBar.appearance().barTintColor = .background
        UITabBar.appearance().tintColor = .red
        UITabBar.appearance().unselectedItemTintColor = .white
        UINavigationBar.appearance().barTintColor = .background
        UINavigationBar.appearance().tintColor = .white
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupChromeCast()
        setupAppearance()
        loadHome()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    fileprivate func loadHome() {
        let controller = MasterController()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = controller
        window?.makeKeyAndVisible()
    }
    
    fileprivate func setupChromeCast() {
        let appId = Bundle.main.infoDictionary?["Chrome Cast Id"] as? String ?? ""
        let discoveryCriteria = GCKDiscoveryCriteria(applicationID: appId)
        let castOptions = GCKCastOptions(discoveryCriteria: discoveryCriteria)
        GCKCastContext.setSharedInstanceWith(castOptions)
        GCKLogger.sharedInstance().delegate = self
    }
}


extension AppDelegate: GCKLoggerDelegate {
    
    func logMessage(_ message: String, at level: GCKLoggerLevel, fromFunction function: String, location: String) {
        print("Message from Chromecast = \(message)")
    }
}
