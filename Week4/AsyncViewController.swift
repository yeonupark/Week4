//
//  AsyncViewController.swift
//  Week4
//
//  Created by 마르 on 2023/08/11.
//

import UIKit

class AsyncViewController: UIViewController {

    @IBOutlet var firstImageView: UIImageView!
    @IBOutlet var secondImageView: UIImageView!
    @IBOutlet var thirdImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstImageView.backgroundColor = .systemPink
        print("1")
        DispatchQueue.main.async {
            print("2")
            // 정적인 디자인일 때는 상관이 없음. frame 사용하는 등 경우에만 ,,
            self.firstImageView.layer.cornerRadius = self.firstImageView.frame.width / 2
        }
       print("3")
    }
    
    // sync async serial concurrent
    // UI Freezing
    
    @IBAction func buttonClicked(_ sender: UIButton) {
        
        // 1.
        let url = URL(string: "https://api.nasa.gov/assets/img/general/apod.jpg")!
        
        DispatchQueue.global().async {
            
            // 2. 이게 오래걸림. -> global로 맡김
            let data = try! Data(contentsOf: url)
            
            DispatchQueue.main.async {
                // 3. UI 관련해서 다루는거는 main에서 처리해야함.
                self.firstImageView.image = UIImage(data: data)
            }
        }
        
    }
}
