//
//  PaPagoViewController.swift
//  Week4
//
//  Created by 마르 on 2023/08/10.
//

import UIKit
import Alamofire
import SwiftyJSON

class PaPagoViewController: UIViewController {
    
    @IBOutlet var originalTextView: UITextView!
    @IBOutlet var requestButton: UIButton!
    @IBOutlet var translateTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestButton.titleLabel?.text = "번역"
        translateTextView.isEditable = false

    }
    
    @IBAction func requestButtonClicked(_ sender: UIButton) {
        detectLanguage()
    }
    
    func callRequest(_ originLang: String) {
        
        let url = "https://openapi.naver.com/v1/papago/n2mt"
        let header: HTTPHeaders = [
            "X-Naver-Client-Id" : APIKey.naverPapagoId,
            "X-Naver-Client-Secret" : APIKey.naverPapagoKey
        ]
        let parameters: Parameters = [
            "source": originLang,
            "target": "en",
            "text": originalTextView.text ?? ""
        ]
        
        
        AF.request(url, method: .post, parameters: parameters ,headers: header).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                let result = json["message"]["result"]["translatedText"].stringValue
                self.translateTextView.text = result
                
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func detectLanguage() {
        
        let url = "https://openapi.naver.com/v1/papago/detectLangs"
        let header: HTTPHeaders = [
            "X-Naver-Client-Id" : APIKey.naverDetectId,
            "X-Naver-Client-Secret" : APIKey.naverDetectKey
        ]
        let parameter: Parameters = ["query" : originalTextView.text ?? ""]
        
        AF.request(url, method: .post, parameters: parameter, headers: header).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                //print("JSON: \(json)")
                let lang = json["langCode"].stringValue
                
                self.callRequest(lang)
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
}
