//
//  Network.swift
//  Capstone
//
//  Created by 정성윤 on 2024/05/11.
//

import Foundation
import RxCocoa
import RxAlamofire
import RxSwift
import Alamofire
import SwiftKeychainWrapper

final class Network<T: Decodable> {
    private let endpoint : String //서버 엔드포인트
    private let queue : ConcurrentDispatchQueueScheduler //동시성(백그라운드에서 실행)
    init(_ endpoint: String) {
        self.endpoint = endpoint
        self.queue = ConcurrentDispatchQueueScheduler(qos: .background)
    }
    //MARK: - General Get Method
    public func getNetwork(path: String) -> Observable<T> {
        let fullPath = "\(endpoint)\(path)"
        let accessToken = KeychainWrapper.standard.string(forKey: "JWTaccessToken") ?? ""
        return RxAlamofire.data(.get, fullPath, headers: ["Authorization":"\(accessToken)","Content-Type":"application/json"])
            .observe(on: queue)
            .debug()
            .map { data -> T in
                return try JSONDecoder().decode(T.self, from: data)
            }
    }
    //MARK: - General Post Method
    public func postNetwork(path: String, params: [String:Any]) -> Observable<T> {
        let fullpath = "\(endpoint)\(path)"
        let accessToken = KeychainWrapper.standard.string(forKey: "JWTaccessToken") ?? ""
        return Observable.create { observer in
            AF.request(fullpath, method : .post, parameters : params, encoding : JSONEncoding.default, headers: ["Authorization":"\(accessToken)","Content-Type":"application/json"])
                .validate()
                .responseDecodable(of: T.self) { response in
                    print(response.debugDescription)
                    switch response.result {
                case .success(let data):
                    observer.onNext(data)
                    observer.onCompleted()
                case.failure(let error):
                    observer.onError(error)
                    }
                }
            return Disposables.create()
        }
    }
    //MARK: - Auth/Login Method
    public func loginNetwork(path: String, params: [String:Any]) -> Observable<T> {
        let fullpath = "\(endpoint)\(path)"
        return RxAlamofire.data(.post, fullpath, parameters: params, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json"])
            .observe(on: queue)
            .debug()
            .map { data -> T in
                return try JSONDecoder().decode(T.self, from: data)
            }
    }
    //MARK: - MultipartFormData Method
    public func formDataNetwork(path: String, params: [String:Any], dataURL : URL) -> Observable<T> {
        let fullpath = "\(endpoint)\(path)"
        let accessToken = KeychainWrapper.standard.string(forKey: "JWTaccessToken") ?? ""
        do {
            let audioData = try Data(contentsOf: dataURL)
            return Observable.create { observer in
                AF.upload(multipartFormData: { formData in
                    formData.append(audioData, withName: "file", fileName: "recording.wav", mimeType: "audio/wav")
                }, to: fullpath, method: .post, headers:  ["Authorization":"\(accessToken)","Content-Type": "multipart/form-data"])
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .success(let data):
                        observer.onNext(data)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
                return Disposables.create()
            }
        } catch {
            print("Failed to load audio data: \(error)")
            return Disposables.create() as! Observable<T>
        }
    }
    //MARK: - SentimentAnalysisNetwork
    public func postSentimentNetwork(path: String) -> Observable<T> {
        let fullpath = "\(endpoint)\(path)"
        let accessToken = KeychainWrapper.standard.string(forKey: "JWTaccessToken") ?? ""
        return Observable.create { observer in
            AF.request(fullpath, method: .post, headers: ["Authorization":"\(accessToken)","Content-Type":"application/json"])
                .validate()
                .responseDecodable(of: T.self) { response in
                    print("\(response.debugDescription)")
                    switch response.result {
                    case .success(let data):
                        observer.onNext(data)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            return Disposables.create()
        }
    }
}
