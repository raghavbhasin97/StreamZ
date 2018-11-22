import UIKit


class HomeHeader: BaseCollectionViewCell {
    
    let cellID = "HeaderUpcomingCell"
    var delegate: CategoryMovieSelectDelegate?
    let line: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.alpha = 0.45
        return view
    }()
    var moviesList: [[String: Any]]? {
        didSet {
            movies.reloadData()
            let attributed = NSMutableAttributedString(attributedString: NSAttributedString(string: " • ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 10)]))
            attributed.append(NSAttributedString(string: String(moviesList?.count ?? 0), attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)]))
            countLabel.attributedText = attributed
        }
    }
    
    let countLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()
    
    let numLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.font = .systemFont(ofSize: 13)
        label.text = "1"
        return label
    }()
    
    lazy var movies: UICollectionView = {
        let flow = UICollectionViewFlowLayout()
        flow.scrollDirection = .horizontal
        let collection = UICollectionView(frame: .zero, collectionViewLayout: flow)
        collection.register(UpcomingCell.self, forCellWithReuseIdentifier: cellID)
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = .background
        collection.showsHorizontalScrollIndicator = false
        collection.isPagingEnabled = true
        collection.isPrefetchingEnabled = true
        return collection
    }()
    
    fileprivate func setupSeperator() {
        addSubview(line)
        addConstraintsWithFormat(format: "H:|[v0]|", views: line)
        line.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        line.heightAnchor.constraint(equalToConstant: 0.40).isActive = true
    }
    
    fileprivate func setupMoviesView() {
        addSubview(movies)
        addConstraintsWithFormat(format: "H:|[v0]|", views: movies)
        addConstraintsWithFormat(format: "V:|[v0]|", views: movies)
    }
    
    fileprivate func setupCountLabel() {
        addSubview(countLabel)
        addConstraintsWithFormat(format: "V:[v0]-5-|", views: countLabel)
    }
    
    fileprivate func setupNumLabel() {
        addSubview(numLabel)
        addConstraintsWithFormat(format: "V:[v0]-5-|", views: numLabel)
    }
    
    override func setup() {
        backgroundColor = .background
        setupMoviesView()
        setupSeperator()
        setupCountLabel()
        setupNumLabel()
        addConstraintsWithFormat(format: "H:[v0][v1]-10-|", views: numLabel, countLabel)
    }
}


extension HomeHeader: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moviesList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! UpcomingCell
        cell.movie = moviesList?[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return frame.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = Int(targetContentOffset.pointee.x/frame.width)
        numLabel.text = String(index + 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let id = moviesList?[indexPath.item]["id"] as! Int
        delegate?.didSelectMovie(movieId: String(id))
    }
}
