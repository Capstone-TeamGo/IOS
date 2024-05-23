//
//  ReissueResponseModel.swift
//  Capstone
//
//  Created by 정성윤 on 2024/05/21.
//

import Foundation
struct ReissueResponseModel : Codable {
    let code : Int?
    let state : String?
    let message : String?
    let data : ReissueData?
    let errorCode : Int?
    let details : ReissueDetail?
}
struct ReissueData : Codable {
    let accessToken : String?
    let refreshToken : String?
}
struct ReissueDetail : Codable {
    let refreshToken : String?
}
