import UIKit

class MasterController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    fileprivate func setup() {
        tabBar.backgroundColor = .black
        
        let home = Home()
        home.tabBarItem.image = #imageLiteral(resourceName: "home").withRenderingMode(.alwaysTemplate)
        home.tabBarItem.selectedImage = #imageLiteral(resourceName: "home-Selected").withRenderingMode(.alwaysTemplate)
        home.tabBarItem.title = "Home"
        
        let search = Search()
        search.tabBarItem.image = #imageLiteral(resourceName: "search").withRenderingMode(.alwaysTemplate)
        search.tabBarItem.selectedImage = #imageLiteral(resourceName: "search-Selected").withRenderingMode(.alwaysTemplate)
        search.tabBarItem.title = "Search"
        
        viewControllers = [
            UINavigationController(rootViewController: home),
            UINavigationController(rootViewController: search)]
    }

}
