//
//  CounselResponseModel.swift
//  Capstone
//
//  Created by 정성윤 on 2024/05/31.
//

import Foundation
struct CounselResponseModel : Codable {
    let code : Int?
    let state : String?
    let message : String?
    let data : CounselResponseData?
}
struct CounselResponseData : Codable {
    let counselId : Int?
    let counselResult : String?
    let imageUrl : String?
}
