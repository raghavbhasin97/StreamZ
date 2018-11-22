import UIKit
import youtube_ios_player_helper

class MovieDetailCell: BaseCollectionViewCell {
    var movie: [String: Any]? {
        didSet {
            if let movie = movie {
                setupMovie(movie: movie)
            }
        }
    }
    
    let loader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView(style: .white)
        loader.translatesAutoresizingMaskIntoConstraints = false
        return loader
    }()
    
    var coverView: UIView = {
        let view = UIView()
        view.backgroundColor = .background
        view.alpha = 0.80
        return view
    }()
    
    var player = YTPlayerView()
    var moviesList: [[String: Any]] = []
    let cellID = "SimilarCell"
    let emptyCellID = "EmptySimilarCell"
    var delegate: CategoryMovieSelectDelegate?
    lazy var movies: UICollectionView = {
        let flow = UICollectionViewFlowLayout()
        flow.scrollDirection = .horizontal
        let collection = UICollectionView(frame: .zero, collectionViewLayout: flow)
        collection.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        collection.register(MovieCell.self, forCellWithReuseIdentifier: cellID)
        collection.register(EmptySimilarCell.self, forCellWithReuseIdentifier: emptyCellID)
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = .background
        collection.showsHorizontalScrollIndicator = false
        collection.isPrefetchingEnabled = true
        return collection
    }()

    fileprivate func setupPlay() {
        playButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(playButton)
        center_X(item: playButton)
        playButton.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
    }
    
    fileprivate func setupSummary() {
        addSubview(descriptionLabel)
        addConstraintsWithFormat(format: "H:|-20-[v0]-10-|", views: descriptionLabel)
        descriptionLabel.topAnchor.constraint(equalTo: playButton.bottomAnchor, constant: 12).isActive = true
    }
    
    fileprivate func setupSeperator() {
        addSubview(line)
        addConstraintsWithFormat(format: "H:|[v0]|", views: line)
        line.heightAnchor.constraint(equalToConstant: 0.40).isActive = true
        line.topAnchor.constraint(equalTo: informationLabel.bottomAnchor, constant: 10).isActive = true
    }
    
    fileprivate func setupInformation() {
        addSubview(informationLabel)
        addConstraintsWithFormat(format: "H:|-20-[v0]-10-|", views: informationLabel)
        informationLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10).isActive = true
    }
    
    fileprivate func setupSimilar() {
        addSubview(movies)
        addConstraintsWithFormat(format: "H:|[v0]|", views: movies)
        movies.topAnchor.constraint(equalTo: similarLabel.bottomAnchor, constant: 5).isActive = true
        movies.heightAnchor.constraint(equalToConstant: 170).isActive = true
    }
    
    fileprivate func setupSimilarLabel() {
        addSubview(similarLabel)
        addConstraintsWithFormat(format: "H:|-20-[v0]", views: similarLabel)
        similarLabel.topAnchor.constraint(equalTo: line.bottomAnchor, constant: 10).isActive = true
    }
    
    fileprivate func setupLoader() {
        addSubview(coverView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: coverView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: coverView)
        coverView.alpha = 0
        coverView.addSubview(loader)
        loader.topAnchor.constraint(equalTo: coverView.topAnchor, constant: 12).isActive = true
        loader.centerXAnchor.constraint(equalTo: coverView.centerXAnchor).isActive = true
        loader.startAnimating()
    }
    
    override func setup() {
        backgroundColor = .clear
        setupPlay()
        setupSummary()
        setupInformation()
        setupSeperator()
        setupSimilarLabel()
        setupSimilar()
        player.delegate = self
        setupLoader()
        addSubview(player)
        player.frame = CGRect(x: 0, y: 0, width: 1, height: 1)
    }
    
    let similarLabel: UILabel = {
        let label = UILabel()
        label.text = "You May Also Like"
        label.textColor = .white
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    lazy var playButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "play").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(playPressed), for: .touchUpInside)
        return button
    }()
    
    @objc func playPressed() {
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveLinear, animations: {[unowned self] in
            self.coverView.alpha = 0.80
        }, completion: nil)
        player.playVideo()
    }
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 13)
        label.numberOfLines = 0
        return label
    }()
    
    let informationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    let line: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.alpha = 0.45
        return view
    }()
    
    fileprivate func setupMovie(movie: [String: Any]) {
        let movieId = movie["id"] as! Int
        fetchSimilar(id: String(movieId)) {[unowned self] (moviesList) in
            self.moviesList = moviesList
            self.movies.reloadData()
        }
        fetchVideo(id: String(movieId)) {[unowned self] (youtubeId) in
            self.player.load(withVideoId: youtubeId)
        }
        descriptionLabel.text = movie["overview"] as? String
        let attributed = NSMutableAttributedString(attributedString: NSAttributedString(string: ""))
        if let rating = movie["vote_average"] as? Double {
            attributed.append(NSAttributedString(string: "Rating: ", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightWhite, NSAttributedString.Key.font: UIFont(name: "AppleSDGothicNeo-Regular", size: 14) as Any]))
            if rating == 0.0 {
                attributed.append(NSAttributedString(string: "Not Availible\n", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font: UIFont(name: "AppleSDGothicNeo-Regular", size: 11) as Any]))
            } else {
                attributed.append(NSAttributedString(string: String(rating), attributes: [NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font: UIFont(name: "AppleSDGothicNeo-Regular", size: 12) as Any]))
                attributed.append(NSAttributedString(string: " / 10.0\n", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font: UIFont(name: "AppleSDGothicNeo-Regular", size: 9.5) as Any]))
            }
            
        }
        
        if let popularity = movie["popularity"] as? Double {
            attributed.append(NSAttributedString(string: "Popularity: ", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightWhite, NSAttributedString.Key.font: UIFont(name: "AppleSDGothicNeo-Regular", size: 14) as Any]))
            if popularity == 0.0 {
                attributed.append(NSAttributedString(string: "Not Availible\n", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font: UIFont(name: "AppleSDGothicNeo-Regular", size: 11) as Any]))
            } else {
                attributed.append(NSAttributedString(string: String(popularity) + "\n", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font: UIFont(name: "AppleSDGothicNeo-Regular", size: 12) as Any]))
            }
            
        }
        informationLabel.attributedText = attributed
    }
}

extension MovieDetailCell: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return max(1,moviesList.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if moviesList.count == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: emptyCellID, for: indexPath)
            return cell
        }
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
        if moviesList.count == 0 {
            return collectionView.frame.size
        }
        let width: CGFloat = (frame.width - 50)/4
        return CGSize(width: width, height: collectionView.frame.height)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let id = moviesList[indexPath.item]["id"] as! Int
        delegate?.didSelectMovie(movieId: String(id))
    }
}

extension MovieDetailCell: YTPlayerViewDelegate {
    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        if state == .playing {
           coverView.alpha = 0
        }
    }
}
