//
//  WeatherViewController.swift
//  Week4
//
//  Created by 마르 on 2023/08/08.
//

import UIKit
import Alamofire
import SwiftyJSON

class WeatherViewController: UIViewController {

    @IBOutlet var weaterLabel: UILabel!
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var humidLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        callRequest()
    }
    
    func callRequest() {
        let url = "https://api.openweathermap.org/data/2.5/weather?lat=44.34&lon=10.99&appid=\(APIKey.weatherKey)"
        
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                let temp = json["main"]["temp"].doubleValue - 273.15
                let humidity = json["main"]["humidity"].intValue
                // 순서대로 차근차근 !!!
                let id = json["weather"][0]["id"].intValue
                
                switch id {
                case 800 : self.weaterLabel.text = "매우 맑음"
                case 801...899 :
                    self.weaterLabel.text = "구름 낀 날씨입니다"
                    self.view.backgroundColor = .cyan
                default: print("나머지는 생략")
                }
                
                self.tempLabel.text = "온도 \(temp)도 입니다"
                self.humidLabel.text = "습도 \(humidity)% 입니다"
                
            case .failure(let error):
                print(error)
            }
        }
    }

}
