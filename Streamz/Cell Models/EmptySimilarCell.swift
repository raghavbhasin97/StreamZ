import UIKit

class EmptySimilarCell: BaseCollectionViewCell {
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 13)
        label.numberOfLines = 0
        label.text = "Sorry, we couldn't find any similar movies."
        label.textAlignment = .center
        return label
    }()
    
    override func setup() {
        backgroundColor = .background
        addSubview(infoLabel)
        addConstraintsWithFormat(format: "H:|[v0]|", views: infoLabel)
        addConstraintsWithFormat(format: "V:|-20-[v0]", views: infoLabel)
    }
}
