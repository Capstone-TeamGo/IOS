//
//  VoiceRecordViewModel.swift
//  Capstone
//
//  Created by 정성윤 on 2024/04/12.
//

import Foundation
import RxSwift
import RxCocoa
import AVFAudio
import AVFoundation

class VoiceRecordViewModel: NSObject, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    private let disposeBag = DisposeBag()
    //질문 가져오기 시작
    let questionTrigger = PublishSubject<Void>()
    let questionResult : PublishSubject<QuestionResponseModel> = PublishSubject()
    //녹음
    let recordTrigger = PublishSubject<Void>()
    //재생
    let playTrigger = PublishSubject<Void>()
    //정지
    let stopTrigger = PublishSubject<Void>()
    
    var audioRecorder : AVAudioRecorder = AVAudioRecorder()
    private var audioPlayer : AVAudioPlayer = AVAudioPlayer()
    private let record : URL = {
        let documentsUrl : URL = {
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            return paths.first!
        }()
        let fileName = UUID().uuidString + ".wav"
        let url = documentsUrl.appendingPathComponent(fileName)
        return url
    }()
    
    override init() {
        super.init()
        questionTrigger.flatMapLatest { _ in
            return QuestionService.requestQuestion()
        }
        .bind(to: questionResult)
        .disposed(by: disposeBag)
        recordTrigger.subscribe(onNext: { [weak self] _ in
            guard let self = self else{return}
            self.requestRecord() { allowed in
                if allowed {
                    self.configure() { configure in
                        if configure {
                            self.recordStart()
                        }
                    }
                }else{ print("Record Permission is Denied.") }
            }
        })
        .disposed(by: disposeBag)
        self.playTrigger.subscribe { _ in
            self.play()
        }
        .disposed(by: self.disposeBag)
        self.stopTrigger.subscribe { _ in
            self.recordStop()
        }
        .disposed(by: self.disposeBag)
    }
}
//MARK: - VoiceRecord
extension VoiceRecordViewModel {
    private func requestRecord(completion : @escaping (Bool) -> Void) {
        let audioSession: AVAudioSession = AVAudioSession.sharedInstance()
        switch audioSession.recordPermission {
        case .undetermined: //녹음 권한 미요청
            audioSession.requestRecordPermission { allowed in
                completion(allowed)
            }
        case .denied: //녹음 권한 거부
            print("Record Permission is Denied.")
            completion(false)
        case .granted: //녹음 권한 허용
            print("Record Permission is Granted.")
            completion(true)
        default:
            fatalError("requestError")
        }
    }
    private func configure(completion: @escaping(Bool) -> Void) {
        let recorderSettings : [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatLinearPCM),
            AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue,
            AVEncoderBitRateKey: 320_000, //비트율 320kpbs
            AVNumberOfChannelsKey: 2, //오디오 채널 2
            AVSampleRateKey: 44_100.0 //샘플율 44.100hz
        ]
        do {
            self.audioRecorder = try AVAudioRecorder(url: self.record, settings: recorderSettings)
            self.audioRecorder.delegate = self
            self.audioRecorder.prepareToRecord()
        } catch {
            print("Failed to initialize AVAudioRecorder: \(error)")
        }
        completion(true)
    }
    private func recordStart() {
        print("녹음 시작")
        let recorder = self.audioRecorder
        let audioSession: AVAudioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(true)
        } catch {
            fatalError(error.localizedDescription)
        }
        recorder.record()
    }
    private func recordStop() {
        print("녹음 정지")
        let recorder = self.audioRecorder
        recorder.stop()
        let audioSession: AVAudioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    private func play() {
        print("재생 시작")
        do {
            self.audioPlayer = try AVAudioPlayer(contentsOf: self.record)
            self.audioPlayer.delegate = self
            self.audioPlayer.play()
        } catch {
            print("Failed to initialize AVAudioPlayer: \(error)")
        }
    }
}

