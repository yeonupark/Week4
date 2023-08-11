//
//  VideoViewController.swift
//  Week4
//
//  Created by 마르 on 2023/08/08.
//

import UIKit
import SwiftyJSON
import Alamofire
import Kingfisher

struct Video {
    let author: String
    let date: String
    let time: Int
    let thumbNail: String
    let title: String
    let url: String
    
    var contents: String {
        return "\(author) | \(time)회\n\(date)"
    }
}

class VideoViewController: UIViewController {

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    
    var videoList: [Video] = []
    var page = 1
    var isEnd = false // 현재 페이지가 마지막 페이지인지 점검하는 프로퍼티
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        tableView.rowHeight = 140
        
        searchBar.delegate = self
        
    }

    func callRequest(query: String, page: Int) {
        KakaoAPIManager.shared.callRequest(type: .video, query: query) { json in
            print(json)
        }
        
//        AF.request(url, method: .get, headers: header).validate(statusCode: 200...500).responseJSON { response in
//            switch response.result {
//            case .success(let value):
//
//                let json = JSON(value)
//                //print("JSON: \(json)")
//                print(url)
//
//                // statusCode는 optional이기 때문에 처리해주자. 500이 보편적 에러임
//                let statusCode = response.response?.statusCode ?? 500
//
//                if statusCode == 200 {
//
//                    self.isEnd = json["meta"]["is_end"].boolValue // 마지막 페이지인 순간에 true가 될 것
//                    print(self.isEnd)
//
//                    for item in json["documents"].arrayValue {
//
//                        let title = item["title"].stringValue
//                        let author = item["author"].stringValue
//                        let date = item["datetime"].stringValue
//                        let time = item["play_time"].intValue
//                        let thumbnail = item["thumbnail"].stringValue
//                        let link = item["url"].stringValue
//
//                        let data = Video(author: author, date: date, time: time, thumbNail: thumbnail, title: title, url: link)
//                        self.videoList.append(data)
//
//                        //print(self.videoList)
//                        self.tableView.reloadData()
//                    }
//
//                } else {
//                    print("문제가 발생했습니다. 잠시 후 다시 시도해주세요!")
//                }
//
//            case .failure(let error):
//                print(error)
//            }
//        }
    }
    
}

// 서치바는 액션 연결이 안되는 대신 다양한 시점을 트리거 할 수 있는 delegate가 있음
extension VideoViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // 새로운 검색어 입력했을 때 기존 조건 리셋. 페이지, 배열
        page = 1
        videoList.removeAll()
        view.endEditing(true)
        
        guard let query = searchBar.text else { return }
        callRequest(query: query, page: page)
    }
}

// UITableViewDataSourcePrefetching: iOS 10 이상 사용 가능한 프로토콜, cellForRowAt 메서드가 호출되기 전에 미리 호출됨
extension VideoViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: VideoTableViewCell.identifier) as? VideoTableViewCell else {
            return UITableViewCell()
        }
        
        cell.titleLabel.text = videoList[indexPath.row].title
        cell.contentLabel.text = videoList[indexPath.row].contents
        
        // 존재하는 url인지 확인
        if let url = URL(string: videoList[indexPath.row].thumbNail){
            cell.thumbnailImageView.kf.setImage(with: url)
        }
        
        return cell
        
    }
    
    // 셀에 화면이 보이기 직전에 필요한 리소스를 미리 다운 받는 기능
    // videoList 개수와 indexPath.row 위치를 비교해 마지막 스크롤 시점을 확인-> 네트워크 요청 시도
    // page count에 대한 체크도 필요
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if videoList.count - 1 == indexPath.row && page < 15 && !isEnd {
                // 세가지 조건을 만족 해야만 서버 통신.
                page += 1
                callRequest(query: searchBar.text!, page: page)
            }
        }
    }
    
    // 취소 기능: 직접 취소하는 기능을 구현해줘야 함 !
    // 빨리빨리 넘길 때 굳이 빨리 지나간 것 까지 다운로드 할 필요는 없으니 그런 데이터들은 준비 안해도 돼. 취소해줘
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        print("==== 취소: \(indexPaths)")
    }
}
