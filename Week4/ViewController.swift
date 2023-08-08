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

class ViewController: UIViewController {

    @IBOutlet var movieTableView: UITableView!
    
    var movieList: [Movie] = []
    //var rankList: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieTableView.delegate = self
        movieTableView.dataSource = self
        
        movieTableView.rowHeight = 60
        
        callRequest()
    }

    func callRequest() {
        let url = "http://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=\(APIKey.boxOffieKey)&targetDt=20120101"
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                // 복잡한 json 구조. 데이터를 원하는 형태에 맞게끔 차근차근 가져오는 것 필요. 한칸 한칸 들어가는 과정
//                let name1 = json["boxOfficeResult"]["dailyBoxOfficeList"][0]["movieNm"].stringValue
//                let name2 = json["boxOfficeResult"]["dailyBoxOfficeList"][1]["movieNm"].stringValue
//                let name3 = json["boxOfficeResult"]["dailyBoxOfficeList"][2]["movieNm"].stringValue
//                self.movieList.append(contentsOf: [name1,name2,name3])
                
                for item in json["boxOfficeResult"]["dailyBoxOfficeList"].arrayValue {
                    let movieNm = item["movieNm"].stringValue
                    let ranking = item["rankOldAndNew"].stringValue
                    let data = Movie(title: movieNm, rnum: ranking)
                    self.movieList.append(data)
                }
                
                
                self.movieTableView.reloadData()
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath)
        
        cell.textLabel?.text = movieList[indexPath.row].title
        cell.detailTextLabel?.text = (movieList[indexPath.row].rnum)
        
        return cell
    }

}
