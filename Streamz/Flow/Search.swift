import UIKit

class Search: BaseViewController {

    let cellID = "MoviewSearchCell"
    let emptyCellID = "EmptySearchCell"
    var moviesList: [[String: Any]] = []
    lazy var searchBar: UISearchBar = {
        let search = UISearchBar()
        search.barTintColor = .background
        search.layer.borderColor = UIColor.background.cgColor
        search.layer.borderWidth = 2
        search.delegate = self
        search.placeholder = "Find movies & more"
        if let textfield = search.value(forKey: "searchField") as? UITextField {
            textfield.textColor = .white
            textfield.backgroundColor = .search
            if let backgroundview = textfield.subviews.first {
                backgroundview.layer.cornerRadius = 18;
                backgroundview.clipsToBounds = true;
            }
        }
        return search
    }()
    
    let titleView: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 15)
        label.text = "Search"
        return label
    }()
    
    lazy var moviesTable: UITableView = {
        let table = UITableView()
        table.backgroundColor = .background
        table.keyboardDismissMode = .onDrag
        table.showsVerticalScrollIndicator = false
        table.separatorStyle = .none
        table.register(MovieSearchCell.self, forCellReuseIdentifier: cellID)
        table.register(EmptySearchCell.self, forCellReuseIdentifier: emptyCellID)
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    fileprivate func setupSearch() {
        view.addSubview(searchBar)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: searchBar)
    }
    
    fileprivate func setupTable() {
        view.addSubview(moviesTable)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: moviesTable)
    }
    
    override func setup() {
        view.backgroundColor = .background
        navigationItem.titleView = titleView
        setupSearch()
        setupTable()
        let top = navigationController?.navigationBar.frame.height ?? 44
        view.addConstraintsWithFormat(format: "V:|-\(top + 30)-[v0(50)]-20-[v1]|", views: searchBar, moviesTable)

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchBar.resignFirstResponder()
    }
}

extension Search: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let term = searchBar.text {
            searchMovies(term: term) {[unowned self] (movies) in
                self.moviesList = movies
                self.moviesTable.reloadData()
                self.searchBar.resignFirstResponder()
            }
        }
    }
}

extension Search: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return max(1, moviesList.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if moviesList.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: emptyCellID, for: indexPath)
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! MovieSearchCell
        cell.item = moviesList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movieId = moviesList[indexPath.row]["id"] as? Int ?? 0
        let controller = MovieDetail()
        moviesTable.isUserInteractionEnabled = false
        fetchMovie(id: String(movieId)) {[unowned self] (fetched_movie) in
            controller.movie = fetched_movie
            self.moviesTable.isUserInteractionEnabled = true
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return moviesList.count == 0 ? 300.0 : 120.0
    }
}
