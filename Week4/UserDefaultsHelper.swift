//
//  UserDefaultsHelper.swift
//  Week4
//
//  Created by 마르 on 2023/08/11.
//

import Foundation

class UserDefaultsHelper {  // property wrapper로 개선 가능
    
    static let standard = UserDefaultsHelper()  // 싱글턴 패턴. 초기화가 한번만 일어남
    
    private init() { } // 접근 제어자. 싱글턴 패턴과 함께 쓰임
    
    let userDefaults = UserDefaults.standard
    
    // 클래스 안에서 정의하면 빌드했을 때 부담이 덜함. 여러 파일에 영향을 안미침 -> 컴파일 최적화
    enum Key: String {
        case nickname, age
    }
    
    var nickname: String {
        get {
            return userDefaults.string(forKey: Key.nickname.rawValue) ?? "대장"
        }
        set {
            userDefaults.set(newValue, forKey: Key.nickname.rawValue)
        }
    }
    
    var age: Int {
        get {
            return userDefaults.integer(forKey: Key.age.rawValue)
        }
        set {
            return userDefaults.set(newValue, forKey: Key.age.rawValue)
        }
    }
}
