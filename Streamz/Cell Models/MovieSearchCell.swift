import UIKit

class MovieSearchCell: UITableViewCell {

    var item: [String: Any]? {
        didSet {
            if let item = item {
                let url = "https://image.tmdb.org/t/p/w500" + (item["poster_path"] as? String ?? "")
                poster.loadImage(url)
                name.text = item["title"] as? String
                if let adult = item["adult"] as? Bool {
                    if adult {
                        ratingLabel.text = "R"
                        ratingW?.constant = 25
                        
                    } else {
                        ratingLabel.text = "PG-13"
                        ratingW?.constant = 53
                    }
                    
                }
                if let id = item["id"] as? Int {
                    loadDetails(id: String(id))
                }
            }
        }
    }
    var ratingW: NSLayoutConstraint?
    let poster: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 4.0
        return image
    }()
    
    let name: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 15)
        label.numberOfLines = 1
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
    
    let details: UILabel = {
        let label = UILabel()
        label.textColor = .lightWhite
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(false, animated: animated)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupPoster() {
        let width: CGFloat = frame.width * 0.20
        addSubview(poster)
        addConstraintsWithFormat(format: "H:|-20-[v0(\(width))]", views: poster)
        addConstraintsWithFormat(format: "V:|-12.5-[v0]-12.5-|", views: poster)
    }
    
    fileprivate func setupName() {
        addSubview(name)
        name.widthAnchor.constraint(equalToConstant: 150).isActive = true
        name.topAnchor.constraint(equalTo: poster.topAnchor, constant: 10).isActive = true
        name.leftAnchor.constraint(equalTo: poster.rightAnchor, constant: 20).isActive = true
    }
    
    fileprivate func setupRatings() {
        addSubview(ratingLabel)
        addConstraintsWithFormat(format: "H:[v0]-10-|", views: ratingLabel)
        ratingLabel.bottomAnchor.constraint(equalTo: name.bottomAnchor).isActive = true
        ratingW = ratingLabel.widthAnchor.constraint(equalToConstant: 25)
        ratingW?.isActive = true
    }
    
    fileprivate func setupDetails() {
        addSubview(details)
        details.leftAnchor.constraint(equalTo: poster.rightAnchor, constant: 10).isActive = true
        details.topAnchor.constraint(equalTo: poster.centerYAnchor).isActive = true
        details.widthAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    func setup() {
        backgroundColor = .background
        setupPoster()
        setupName()
        setupRatings()
        setupDetails()
    }

    
    fileprivate func loadDetails(id: String) {
        fetchMovie(id: id) {[unowned self] (movie) in
            let date = (movie["release_date"] as? String ?? "").split(separator: "-")[0]
            if let genresList = movie["genres"] as? [[String: Any]] {
                let genre = genresList.first
                let time =  movie["runtime"] as? Int ?? 100
                let attributed = NSMutableAttributedString(attributedString: NSAttributedString(string: "(\(date)) • " + time.toTime(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12)]))
                
                attributed.append(NSAttributedString(attributedString: NSAttributedString(string: "\n")))
                attributed.append(NSAttributedString(string: genre?["name"] as? String ?? "", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 11)]))
                self.details.attributedText = attributed
            }
        }
    }
}
