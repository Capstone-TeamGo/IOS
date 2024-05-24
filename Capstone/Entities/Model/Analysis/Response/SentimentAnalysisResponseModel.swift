//
//  SentimentAnalysisResponseModel.swift
//  Capstone
//
//  Created by 정성윤 on 2024/05/23.
//

import Foundation
struct SentimentAnalysisResponseModel : Codable {
    let code : Int?
    let state : String?
    let message : String?
    let data : SentimentAnalysisData?
    let errorCode : Int?
    let details : String?
}
struct SentimentAnalysisData : Codable {
    let transcribedText : String?
    let feelingState : Double?
}
