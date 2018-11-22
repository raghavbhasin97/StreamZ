
import UIKit

@objc protocol CategoryMovieSelectDelegate {
    func didSelectMovie(movieId: String)
    @objc optional func didSelectOption(category: String)
}


class CategoryCell: BaseCollectionViewCell {
    let cellID = "MovieCell"
    var delegate: CategoryMovieSelectDelegate?
    var item: Category? {
        didSet {
            if let item = item {
                categoryLabel.text = item.category
                moviesList = item.movies
                movies.reloadData()
            }
        }
    }
    
    var moviesList: [[String: Any]] = []
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    lazy var optionsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("•••", for: .normal)
        button.addTarget(self, action: #selector(optionSelected), for: .touchUpInside)
        return button
    }()
    
    lazy var movies: UICollectionView = {
        let flow = UICollectionViewFlowLayout()
        flow.scrollDirection = .horizontal
        let collection = UICollectionView(frame: .zero, collectionViewLayout: flow)
        collection.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        collection.register(MovieCell.self, forCellWithReuseIdentifier: cellID)
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = .background
        collection.showsHorizontalScrollIndicator = false
        collection.isPrefetchingEnabled = true
        return collection
    }()
    
    let line: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.alpha = 0.45
        return view
    }()
    
    fileprivate func setupSeperator() {
        addSubview(line)
        addConstraintsWithFormat(format: "H:|[v0]|", views: line)
        line.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        line.heightAnchor.constraint(equalToConstant: 0.40).isActive = true
    }
    
    fileprivate func setupOptions() {
        addSubview(optionsButton)
        addConstraintsWithFormat(format: "V:|-2-[v0]", views: optionsButton)
        addConstraintsWithFormat(format: "H:[v0]-10-|", views: optionsButton)
    }
    
    override func setup() {
        backgroundColor = .background
        addSubview(categoryLabel)
        addConstraintsWithFormat(format: "H:|-20-[v0]", views: categoryLabel)
        addSubview(movies)
        addConstraintsWithFormat(format: "H:|[v0]|", views: movies)
        addConstraintsWithFormat(format: "V:|-10-[v0]-2-[v1]-20-|", views: categoryLabel, movies)
        setupSeperator()
        setupOptions()
    }
    
    @objc fileprivate func optionSelected() {
        delegate?.didSelectOption?(category: item?.category ?? "")
    }
}

extension CategoryCell: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
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
        let width: CGFloat = (frame.width - 50)/4
        return CGSize(width: width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let id = moviesList[indexPath.item]["id"] as! Int
        delegate?.didSelectMovie(movieId: String(id))
    }
}
