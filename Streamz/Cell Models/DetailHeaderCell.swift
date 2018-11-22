import UIKit

class DetailHeaderCell: BaseCollectionViewCell {
    var movie: [String: Any]? {
        didSet {
            if let movie = movie {
                setupMovie(movie: movie)
            }
        }
    }
    
    let poster: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        return image
    }()
    
    var ratingW: NSLayoutConstraint?
    let name: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let details: UILabel = {
        let label = UILabel()
        label.textColor = .lightWhite
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let ratingLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.textColor = .white
        label.backgroundColor = .rating
        label.clipsToBounds = true
        label.layer.cornerRadius = 2.0
        label.font = .boldSystemFont(ofSize: 12)
        label.textAlignment = .center
        return label
    }()
    
    fileprivate func setupPoster(_ width: CGFloat, _ height: CGFloat) {
        addSubview(poster)
        addConstraintsWithFormat(format: "H:|-20-[v0(\(width))]", views: poster)
        addConstraintsWithFormat(format: "V:[v0(\(height))]|", views: poster)
    }
    
    fileprivate func setupName() {
        addSubview(name)
        name.leftAnchor.constraint(equalTo: poster.rightAnchor, constant: 10).isActive = true
        name.topAnchor.constraint(equalTo: poster.topAnchor, constant: 20).isActive = true
        name.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
    }
    
    fileprivate func setupDetails() {
        addSubview(details)
        details.leftAnchor.constraint(equalTo: poster.rightAnchor, constant: 10).isActive = true
        details.bottomAnchor.constraint(equalTo: poster.bottomAnchor, constant: -6).isActive = true
    }
    
    fileprivate func setupRatings() {
        addSubview(ratingLabel)
        addConstraintsWithFormat(format: "H:[v0]-20-|", views: ratingLabel)
        ratingLabel.bottomAnchor.constraint(equalTo: details.bottomAnchor).isActive = true
        ratingW = ratingLabel.widthAnchor.constraint(equalToConstant: 25)
        ratingW?.isActive = true
        details.rightAnchor.constraint(equalTo: ratingLabel.leftAnchor, constant: -8).isActive = true
    }
    
    func setupCell(size: CGSize) {
        let width: CGFloat = size.width  * 0.26
        let height: CGFloat = size.height * 0.50
        setupPoster(width, height)
        setupName()
        setupDetails()
        setupRatings()
    }
    
    override func setup() {
        backgroundColor = .clear
    }
    
    fileprivate func setupMovie(movie: [String: Any]) {
        let backURL = "https://image.tmdb.org/t/p/w500" + (movie["poster_path"] as? String ?? "")
        poster.loadImage(backURL)
        name.text = movie["title"] as? String
        let date = (movie["release_date"] as? String ?? "").split(separator: "-")[0]
        var genres = ""
        if let genresList = movie["genres"] as? [[String: Any]] {
            var idx = 0
            for genre in genresList {
                if let genreName = genre["name"] as? String {
                    genres += genreName
                    if idx < genresList.count - 1 && idx < 3{
                        genres += ", "
                    }
                    idx += 1
                    if idx >= 4 { break }
                }
            }
            
            let time =  movie["runtime"] as? Int ?? 100
            let attributed = NSMutableAttributedString(attributedString: NSAttributedString(string: "(\(date)) • " + time.toTime(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12)]))
            
            attributed.append(NSAttributedString(attributedString: NSAttributedString(string: "\n")))
            attributed.append(NSAttributedString(string: genres, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 11)]))
            details.attributedText = attributed
        }
        
        if let adult = movie["adult"] as? Bool {
            if adult {
                ratingLabel.text = "R"
                ratingW?.constant = 25
                
            } else {
                ratingLabel.text = "PG-13"
                ratingW?.constant = 53
            }
            
        }
        
    }
}
