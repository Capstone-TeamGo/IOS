//
//  AnalaysisPagingResponseModel.swift
//  Capstone
//
//  Created by 정성윤 on 2024/05/25.
//

import Foundation
struct AnalysisPagingResponseModel : Codable {
    let code : Int?
    let state : String?
    let message : String?
    let data : AnalysisPagingData
}
struct AnalysisPagingData : Codable {
    let pageNumber : Int?
    let totalPage : Int?
    let anaylsisResponseDtoList : [AnaylsisResponseDtoList]?
}
struct AnaylsisResponseDtoList : Codable {
    let analysisId : Int?
    let time : String?
    let feelingState : Double?
    let questionContent : [String]?
}
