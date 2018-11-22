import UIKit

class MovieCell: BaseCollectionViewCell {
    var movie: [String: Any]? {
        didSet {
            if let movie = movie {
                let url = "https://image.tmdb.org/t/p/w500" + (movie["poster_path"] as? String ?? "")
                poster.loadImage(url)
                name.text = movie["title"] as? String
            }
        }
    }
    
    let poster: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    let name: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = 2
        return label
    }()
    
    override func setup() {
        backgroundColor = .background
        addSubview(poster)
        addConstraintsWithFormat(format: "H:|[v0]|", views: poster)
        addSubview(name)
        addConstraintsWithFormat(format: "H:|[v0]|", views: name)
        addConstraintsWithFormat(format: "V:|[v0]-5-[v1(30)]|", views: poster, name)
    }
}
