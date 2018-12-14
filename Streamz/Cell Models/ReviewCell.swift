import UIKit

class ReviewCell: UITableViewCell {

    var review: [String: Any]? {
        didSet {
            if let review = review {
                name.text =  "By - " + (review["author"] as? String ?? "")
                reviewText.text = review["content"] as? String
            }
        }
    }
    
    
    let name: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    let reviewText: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 15)
        label.numberOfLines = 0
        label.textAlignment = .justified
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
    
    func setup() {
        backgroundColor = .background
        addSubview(name)
        addConstraintsWithFormat(format: "H:|-20-[v0]", views: name)
        addSubview(reviewText)
        addConstraintsWithFormat(format: "H:|-15-[v0]-15-|", views: reviewText)
        addConstraintsWithFormat(format: "V:|-10-[v0]-5-[v1]-10-|", views: name, reviewText)
    }

}
