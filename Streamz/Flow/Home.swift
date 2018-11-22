import UIKit

class Home: BaseViewController {
    
    let cellID = "HomeCell"
    let headerCellID = "HeaderHomecell"
    
    lazy var library: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.register(CategoryCell.self, forCellWithReuseIdentifier: cellID)
        collection.register(HomeHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerCellID)
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = .background
        collection.showsVerticalScrollIndicator = false
        collection.isPrefetchingEnabled = true
        return collection
    }()
    
    

    let titleView: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Noteworthy-Bold", size: 22)
        label.text = "streamZ"
        return label
    }()
    
    
    override func setup() {
        view.backgroundColor = .background
        navigationItem.titleView = titleView
        navigationItem.title = "Home"
        view.addSubview(library)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: library)
        view.addConstraintsWithFormat(format: "V:|[v0]|", views: library)
        
        fetchMovies {[unowned self] in
            self.library.reloadData()
        }
    }
}

extension Home: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return genres.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! CategoryCell
        if indexPath.item == 0 {
            cell.item = allMovies["Most Popular"]
        } else {
            cell.item = allMovies[genres[indexPath.row - 1].name]
        }
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerCellID, for: indexPath) as! HomeHeader
        header.moviesList = allMovies["Upcoming"]?.movies ?? []
        header.delegate = self
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height * 0.30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height * 0.40)
    }
    
}

extension Home: CategoryMovieSelectDelegate {
    func didSelectMovie(movieId: String) {
        let controller = MovieDetail()
        library.isUserInteractionEnabled = false
        fetchMovie(id: movieId) {[unowned self] (fetched_movie) in
            controller.movie = fetched_movie
            self.library.isUserInteractionEnabled = true
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func didSelectOption(category: String) {
        let controller = GenreController()
        controller.category = category
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
}
