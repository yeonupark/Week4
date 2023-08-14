//
//  ViewController.swift
//  Week4
//
//  Created by 마르 on 2023/08/07.
//

import UIKit
import Alamofire
import SwiftyJSON

struct Movie {
    var title: String
    //var release: String
    var rnum: String
}

// MARK: - Welcome
struct BoxOffice: Codable {
    let boxOfficeResult: BoxOfficeResult
}

// MARK: - BoxOfficeResult
struct BoxOfficeResult: Codable {
    let boxofficeType, showRange: String
    let dailyBoxOfficeList: [DailyBoxOfficeList]
}

// MARK: - DailyBoxOfficeList
struct DailyBoxOfficeList: Codable {
    let rnum, rank, rankInten: String
    let rankOldAndNew: RankOldAndNew
    let movieCD, movieNm, openDt, salesAmt: String
    let salesShare, salesInten, salesChange, salesAcc: String
    let audiCnt, audiInten, audiChange, audiAcc: String
    let scrnCnt, showCnt: String

    enum CodingKeys: String, CodingKey {
        case rnum, rank, rankInten, rankOldAndNew
        case movieCD = "movieCd"
        case movieNm, openDt, salesAmt, salesShare, salesInten, salesChange, salesAcc, audiCnt, audiInten, audiChange, audiAcc, scrnCnt, showCnt
    }
}

enum RankOldAndNew: String, Codable {
    case old = "OLD"
}

class ViewController: UIViewController {

    @IBOutlet var movieTableView: UITableView!
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet var searchBar: UISearchBar!
    
    var movieList: [Movie] = []
    
    //codable로 수정
    var result: BoxOffice?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieTableView.delegate = self
        movieTableView.dataSource = self
        searchBar.delegate = self
        
        movieTableView.rowHeight = 60
        activityIndicatorView.isHidden = true
        
    }

    func callRequest(date: String) {
        
        activityIndicatorView.startAnimating()
        activityIndicatorView.isHidden = false
        
        
        let url = "http://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=\(APIKey.boxOffieKey)&targetDt=\(date)"
        
        AF.request(url, method: .get).validate()
            .responseDecodable(of: BoxOffice.self) { response in
                print(response.value) // 구조체에 담겨서 내용이 출력됨
                self.result = response.value // 배열 만들어서 반복문 + append 하지 않아도 된다.
            }
        
        
            
//            .responseJSON { response in
//            switch response.result {
//            case .success(let value):
//                let json = JSON(value)
//                print("JSON: \(json)")
//
//                for item in json["boxOfficeResult"]["dailyBoxOfficeList"].arrayValue {
//                    let movieNm = item["movieNm"].stringValue
//                    let ranking = item["rank"].stringValue
//                    let data = Movie(title: movieNm, rnum: ranking)
//                    self.movieList.append(data)
//                }
//
//                self.activityIndicatorView.stopAnimating()
//                self.activityIndicatorView.isHidden = true
//                self.movieTableView.reloadData()
//
//            case .failure(let error):
//                print(error)
//            }
//        }
    }
    
}
extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // 20220101 > 1. 8글자인지 2. 올바른 날짜 형식에 맞는 숫자인지 3. 날짜의 범위가 올바른지 (어제날짜 까지
        callRequest(date: searchBar.text!)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return result!.boxOfficeResult.dailyBoxOfficeList.count //movieList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath)
        
        cell.textLabel?.text = movieList[indexPath.row].title
        cell.detailTextLabel?.text = (movieList[indexPath.row].rnum)
        
        return cell
    }

}
