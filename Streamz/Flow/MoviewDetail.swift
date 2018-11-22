import UIKit

class MovieDetail: UIViewController {

    let headerCellID = "HeaderDetailCell"
    let cellID = "DetailCell"
    var movie: [String: Any]? {
        didSet {
            if let movie = movie {
                let backURL = "https://image.tmdb.org/t/p/w500" + (movie["backdrop_path"] as? String ?? "")
                backdropImage.loadImage(backURL)
            }
        }
    }
    private var gradient: CAGradientLayer!
    let headeMult: CGFloat = 0.40
    
    lazy var movieView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.register(DetailHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerCellID)
        collection.register(MovieDetailCell.self, forCellWithReuseIdentifier: cellID)
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = .background
        collection.showsVerticalScrollIndicator = false
        collection.backgroundColor = .clear
        return collection
    }()
    
    let backdropImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.alpha = 0.45
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var shareButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareMovie))
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    fileprivate func setupBackdrop() {
        view.addSubview(backdropImage)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: backdropImage)
        let height: CGFloat = view.frame.height * 0.3
        let top: CGFloat = navigationController?.navigationBar.frame.height ?? 0.0
        view.addConstraintsWithFormat(format: "V:|-\(top)-[v0(\(height))]", views: backdropImage)
        addFade()
    }
    
    fileprivate func setupMovieView() {
        view.addSubview(movieView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: movieView)
        view.addConstraintsWithFormat(format: "V:|[v0]|", views: movieView)
    }
    
    func setup() {
        view.backgroundColor = .background
        setupBackdrop()
        setupMovieView()
        navigationItem.rightBarButtonItem = shareButton
    }

    func addFade() {
        gradient = CAGradientLayer()
        gradient.frame = backdropImage.bounds
        gradient.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
        gradient.locations = [0.85, 1]
        backdropImage.layer.mask = gradient
    }
    
    @objc fileprivate func shareMovie() {
        if let imdb_id = movie?["imdb_id"] as? String {
            let text = "I thought you would like to see this movie."
            let shareController = UIActivityViewController(activityItems: [text, URL(string: "https://www.imdb.com/title/\(imdb_id)") as Any ], applicationActivities: [])
            present(shareController, animated: true, completion: nil)
        }
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradient.frame = backdropImage.bounds
    }
}

extension MovieDetail: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! MovieDetailCell
        cell.movie = movie
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height * headeMult)
    }

    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerCellID, for: indexPath) as! DetailHeaderCell
        headerView.setupCell(size: CGSize(width: view.frame.width, height: view.frame.height * headeMult))
        headerView.movie = movie
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height * 0.80)
    }
}

extension MovieDetail: CategoryMovieSelectDelegate {
    func didSelectMovie(movieId: String) {
        let controller = MoviewDetail()
        library.isUserInteractionEnabled = false
        fetchMovie(id: movieId) {[unowned self] (fetched_movie) in
            controller.movie = fetched_movie
            self.library.isUserInteractionEnabled = true
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
}
