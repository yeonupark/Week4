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
        callRequest()
    }
    
    func callRequest() {
        
        let url = "https://openapi.naver.com/v1/papago/n2mt"
        let header: HTTPHeaders = [
            "X-Naver-Client-Id" : APIKey.naverId,
            "X-Naver-Client-Secret" : APIKey.naverKey
        ]
        let parameters: Parameters = [
            "source": "ko",
            "target": "es",
            "text": originalTextView.text ?? ""
        ]
        
        
        AF.request(url, method: .post,parameters: parameters ,headers: header).validate().responseJSON { response in
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
}
