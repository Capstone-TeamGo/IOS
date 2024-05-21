//
//  URL.swift
//  Capstone
//
//  Created by 정성윤 on 2024/05/07.
//

import Foundation

//MARK: - Endpoint
let endpointURL = "http://13.124.95.110:8080/api/v1" //엔드포인트

//MARK: - Auth
let loginURL = "/user/login-oauth" //로그인
let logoutURL = "/user/logout-oauth" //로그아웃
let reissueURL = "/api/v1/user/reissue" //토큰 재발행

//MARK: - Question
let questionURL = "/analysis" //질문 텍스트, 음성

//MARK: - Feeling
let feelingWeekURL = "/analysis/week" //일주일 감정

