//
//  FeelingRequestModel.swift
//  Capstone
//
//  Created by 정성윤 on 2024/04/25.
//

import Foundation
struct FeelingRequestModel : Codable {
    let code : Int?
    let state : String?
    let message : String?
    let data : FeelingData?
}
struct FeelingData : Codable {
    let feelingStateResponsesDto : [FeelingState]?
}
struct FeelingState : Codable {
    let date : String?
    let avgFeelingState : Double?
}
