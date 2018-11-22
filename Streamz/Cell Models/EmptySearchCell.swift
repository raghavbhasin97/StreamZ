import UIKit

class EmptySearchCell: UITableViewCell {
    
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
    
    let details: UILabel = {
        let label = UILabel()
        label.textColor = .lightWhite
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    func setup() {
        backgroundColor = .background
        addSubview(details)
        addConstraintsWithFormat(format: "H:|-30-[v0]-30-|", views: details)
        center_Y(item: details)
        details.text = "Start searching for movies by typing in the name or phrase you would like."
    }

}
