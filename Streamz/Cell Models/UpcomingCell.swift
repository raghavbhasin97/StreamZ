import UIKit

class UpcomingCell: BaseCollectionViewCell {
    var movie: [String: Any]? {
        didSet {
            if let movie = movie {
                let url = "https://image.tmdb.org/t/p/w500" + (movie["backdrop_path"] as? String ?? "")
                poster.loadImage(url)
                name.text = movie["title"] as? String
            }
        }
    }
    
    let backDrop: UIView = {
        let view = UIView()
        view.backgroundColor = .background
        view.alpha = 0.65
        return view
    }()
    
    let poster: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    let name: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 17)
        label.numberOfLines = 2
        return label
    }()
    
    fileprivate func setupPoster() {
        addSubview(poster)
        addConstraintsWithFormat(format: "H:|[v0]|", views: poster)
        addConstraintsWithFormat(format: "V:|[v0]|", views: poster)
    }
    
    fileprivate func setupName() {
        addSubview(name)
        addConstraintsWithFormat(format: "H:|-20-[v0]|", views: name)
        addConstraintsWithFormat(format: "V:[v0]-25-|", views: name)
    }
    
    fileprivate func setupBackdrop() {
        addSubview(backDrop)
        addConstraintsWithFormat(format: "H:|[v0]|", views: backDrop)
        addConstraintsWithFormat(format: "V:|[v0]|", views: backDrop)
    }
    
    override func setup() {
        backgroundColor = .background
        setupPoster()
        setupBackdrop()
        setupName()
    }
}
