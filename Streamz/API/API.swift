import Foundation
import Alamofire

struct Genre {
    var name: String
    var id: Int
}

let genres: [Genre] = [.init(name: "Action", id: 28),
                       .init(name: "Adventure", id: 12),
                       .init(name: "Comedy", id: 35),
                       .init(name: "Mystery", id: 9648),
                       .init(name: "Crime", id: 80),
                       .init(name: "Romance", id: 10749),
                       .init(name: "Drama", id: 18),
                       .init(name: "Documentary", id: 99),
                       .init(name: "Fantasy", id: 14),
                       .init(name: "Horror", id: 27),
                       .init(name: "Science Fiction", id: 878)]

let apiKey = Bundle.main.infoDictionary?["API Key"] as? String ?? ""
var allMovies: [String: Category] = [:]
var moviesIndex: Int = 0

fileprivate func checkIfshouldUpdate(completion: (() -> Void)? = nil) {
    if moviesIndex == genres.count + 1 {
        completion?()
    } else {
        moviesIndex += 1
    }
}

func fetchMovies(completion: (() -> Void)? = nil) {
    
    fecthPopularMovies { (movies) in
        allMovies["Most Popular"] = Category(category: "Most Popular", movies: movies)
        checkIfshouldUpdate(completion: completion)
    }
    
    fecthUpcomingMovies {  (movies) in
        allMovies["Upcoming"] = Category(category: "Upcoming", movies: movies)
        checkIfshouldUpdate(completion: completion)
    }
    
    for genre in genres {
        fecthFromAPI(genere: genre.id) { (movies) in
            allMovies[genre.name] = Category(category: genre.name, movies: movies)
            checkIfshouldUpdate(completion: completion)
        }
    }
}

fileprivate func fecthFromAPI(genere: Int, completion: (([[String: Any]]) -> Void)? = nil) {
    let url = "https://api.themoviedb.org/3/discover/movie"
    let parameters = ["api_key": apiKey,
                      "language": "en-US",
                      "region": "US",
                      "sort_by": "release_date.desc",
                      "with_genres": String(genere),
                      "year": "2018"]
    Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.queryString, headers: nil).responseJSON { (res) in
        if let result = res.result.value as? [String: Any] {
            if let movies =  result["results"] as? [[String: Any]] {
                var finalList: [[String: Any]] = []
                for movie in movies {
                    if let _ = movie["poster_path"] as? String {
                        if let _ = movie["backdrop_path"] as? String {
                            finalList.append(movie)
                        }
                    }
                }
                completion?(finalList)
            }
        }
    }
}

fileprivate func fecthPopularMovies(completion: (([[String: Any]]) -> Void)? = nil) {
    let url = "https://api.themoviedb.org/3/movie/popular"
    let parameters = ["api_key": apiKey,
                      "language": "en-US",
                      "region": "US"]
    Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.queryString, headers: nil).responseJSON { (res) in
        if let result = res.result.value as? [String: Any] {
            if let movies =  result["results"] as? [[String: Any]] {
                var finalList: [[String: Any]] = []
                for movie in movies {
                    if let _ = movie["poster_path"] as? String {
                        if let _ = movie["backdrop_path"] as? String {
                            finalList.append(movie)
                        }
                    }
                }
                completion?(finalList)
            }
        }
    }
}

fileprivate func fecthUpcomingMovies(completion: (([[String: Any]]) -> Void)? = nil) {
    let url = "https://api.themoviedb.org/3/movie/upcoming"
    let parameters = ["api_key": apiKey,
                      "language": "en-US",
                      "region": "US"]
    Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.queryString, headers: nil).responseJSON { (res) in
        if let result = res.result.value as? [String: Any] {
            if let movies =  result["results"] as? [[String: Any]] {
                var finalList: [[String: Any]] = []
                for movie in movies {
                    if let _ = movie["poster_path"] as? String {
                        if let _ = movie["backdrop_path"] as? String {
                            finalList.append(movie)
                        }
                    }
                }
                completion?(finalList)
            }
        }
    }
}

func fetchMovie(id: String, completion: (([String: Any]) -> Void)? = nil) {
    let url = "https://api.themoviedb.org/3/movie/\(id)"
    let parameters = ["api_key": apiKey]
    Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.queryString, headers: nil).responseJSON { (res) in
        if (res.error != nil) {
            completion?([:])
        }
        if let result = res.result.value as? [String: Any] {
            completion?(result)
        }
    }
}

func fetchSimilar(id: String, completion: (([[String: Any]]) -> Void)? = nil) {
    let url = "https://api.themoviedb.org/3/movie/\(id)/similar"
    let parameters = ["api_key": apiKey]
    Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.queryString, headers: nil).responseJSON { (res) in
        if let result = res.result.value as? [String: Any] {
            if let movies =  result["results"] as? [[String: Any]] {
                var finalList: [[String: Any]] = []
                for movie in movies {
                    if let _ = movie["poster_path"] as? String {
                        if let _ = movie["backdrop_path"] as? String {
                            finalList.append(movie)
                        }
                    }
                }
                completion?(finalList)
            }
        }
    }
}

func fetchVideo(id: String, completion: ((String) -> Void)? = nil) {
    let url = "https://api.themoviedb.org/3/movie/\(id)/videos"
    let parameters = ["api_key": apiKey]
    Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.queryString, headers: nil).responseJSON { (res) in
        if let result = res.result.value as? [String: Any] {
            if let movies =  result["results"] as? [[String: Any]] {
                if let movie = movies.first {
                    let id = movie["key"] as? String
                    completion?(id ?? "")
                }
            }
        }
    }
}


func searchMovies(term: String, completion: (([[String: Any]]) -> Void)? = nil) {
    let url = "https://api.themoviedb.org/3/search/movie"
    let parameters = ["api_key": apiKey,
                      "language": "en-US",
                      "region": "US",
                      "query": term,
                      "include_adult": "true",
                      "year": "2018"]
    Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.queryString, headers: nil).responseJSON { (res) in
        if let result = res.result.value as? [String: Any] {
            if let movies =  result["results"] as? [[String: Any]] {
                var finalList: [[String: Any]] = []
                for movie in movies {
                    if let _ = movie["poster_path"] as? String {
                        if let _ = movie["backdrop_path"] as? String {
                            finalList.append(movie)
                        }
                    }
                }
                completion?(finalList)
            }
        }
    }
}
