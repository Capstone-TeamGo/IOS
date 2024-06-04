//
//  MypageResponseModel.swift
//  Capstone
//
//  Created by 정성윤 on 2024/06/04.
//

import Foundation
struct MypageResponseModel : Codable {
    let code : Int?
    let state : String?
    let message : String?
    let data : MypageData?
}
struct MypageData : Codable {
    let nickname : String?
    let email : String?
    let socialType: String?
    let analysisCount : Int?
}
