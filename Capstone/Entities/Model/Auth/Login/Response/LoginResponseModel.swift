//
//  LoginResponseModel.swift
//  Capstone
//
//  Created by 정성윤 on 2024/04/19.
//

import Foundation
struct LoginResponseModel : Codable {
    let code : Int
    let state : String
    let message : String?
    let data : LoginData?
}
struct LoginData : Codable {
    let accessToken : String
    let refreshToken : String
}
