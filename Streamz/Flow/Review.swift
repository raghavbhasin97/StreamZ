import UIKit

class Review: BaseViewController {

    let cellId = "ReviewCell"
    let emptyCellId = "EmptyReviewCell"
    var reviews: [[String: Any]]? {
        didSet {
            if let reviews = reviews {
                reviewList = reviews
                reviewsTable.reloadData()
            }
        }
    }
    
    lazy var reviewsTable: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.separatorInset = .zero
        table.register(ReviewCell.self, forCellReuseIdentifier: cellId)
        table.register(EmptyReviewCell.self, forCellReuseIdentifier: emptyCellId)
        table.backgroundColor = .background
        table.showsVerticalScrollIndicator = false
        table.tableFooterView = UIView()
        return table
    }()
    
    var reviewList:[[String: Any]] = []
    
    let titleView: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    override func setup() {
        view.backgroundColor = .background
        navigationItem.titleView = titleView
        
        view.addSubview(reviewsTable)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: reviewsTable)
        view.addConstraintsWithFormat(format: "V:|[v0]|", views: reviewsTable)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        tabBarController?.tabBar.isHidden = false
    }
}

extension Review: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return max(1, reviewList.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if reviewList.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: emptyCellId, for: indexPath)
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ReviewCell
        cell.review = reviewList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return reviewList.count == 0 ? tableView.frame.height : UITableView.automaticDimension
    }
}
