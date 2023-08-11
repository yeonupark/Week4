//
//  TranslateAPIManager.swift
//  Week4
//
//  Created by 마르 on 2023/08/11.
//

import Foundation
import Alamofire
import SwiftyJSON

class TranslateAPIManager {
    
    static let shared = TranslateAPIManager()
    
    private init() {}
    
    func callRequest(text: String, resultString: @escaping (String) -> Void ) {
        
        let url = "https://openapi.naver.com/v1/papago/n2mt"
        let header: HTTPHeaders = [
            "X-Naver-Client-Id" : APIKey.naverPapagoId,
            "X-Naver-Client-Secret" : APIKey.naverPapagoKey
        ]
        let parameters: Parameters = [
            "source": "ko",
            "target": "en",
            "text": text
        ]
        
        
        AF.request(url, method: .post, parameters: parameters ,headers: header).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                let result = json["message"]["result"]["translatedText"].stringValue
                resultString(result)
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    
}
