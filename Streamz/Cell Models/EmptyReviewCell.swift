import UIKit

class EmptyReviewCell: UITableViewCell {
    
    let descText: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 20)
        label.text = "No reviews yet."
        label.textAlignment = .center
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
        addSubview(descText)
        addConstraintsWithFormat(format: "H:|-20-[v0]-20-|", views: descText)
        addConstraintsWithFormat(format: "V:|-20-[v0]-20-|", views: descText)
    }
    
}
