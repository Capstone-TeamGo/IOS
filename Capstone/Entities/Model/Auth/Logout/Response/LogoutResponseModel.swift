//
//  LogoutResponseModel.swift
//  Capstone
//
//  Created by 정성윤 on 2024/05/11.
//
import Foundation
struct LogoutResponseModel : Codable {
    let code : Int
    let state : String
    let message : String?
    let data : String?
}
