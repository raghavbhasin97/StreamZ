import UIKit

class GenreController: BaseViewController {

    var category: String? {
        didSet {
            if let category = category {
                moviesList = allMovies[category]?.movies ?? []
                titleView.text = category
                library.reloadData()
            }
        }
    }
    
    let cellID = "GenereCell"
    let titleView: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    lazy var library: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.register(MovieCell.self, forCellWithReuseIdentifier: cellID)
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = .background
        collection.showsVerticalScrollIndicator = false
        collection.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        collection.isPrefetchingEnabled = true
        return collection
    }()
    
    override func setup() {
        view.backgroundColor = .background
        navigationItem.titleView = titleView
        view.addSubview(library)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: library)
        view.addConstraintsWithFormat(format: "V:|[v0]|", views: library)
    }
    
    var moviesList: [[String: Any]] = []
    
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


extension GenreController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moviesList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! MovieCell
        cell.movie = moviesList[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (view.frame.width - 35)/4
        return CGSize(width: width, height: 165)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movieId = moviesList[indexPath.item]["id"] as! Int
        let controller = MovieDetail()
        library.isUserInteractionEnabled = false
        fetchMovie(id: String(movieId)) {[unowned self] (fetched_movie) in
            controller.movie = fetched_movie
            self.library.isUserInteractionEnabled = true
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
