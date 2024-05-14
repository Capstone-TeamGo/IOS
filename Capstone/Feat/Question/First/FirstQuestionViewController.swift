//
//  FirstQuestionViewController.swift
//  Capstone
//
//  Created by 정성윤 on 2024/03/27.
//

import Foundation
import SnapKit
import RxSwift
import RxCocoa
import UIKit
import AVFoundation

class FirstQuestionViewController : UIViewController {
    private let disposeBag = DisposeBag()
    private let voiceRecordViewModel = VoiceRecordViewModel()
    private var timer : Timer?
    private var player : AVPlayer?
    private var question : QuestionResponseModel?
    //MARK: - UI Components
    private let image : UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .SecondaryColor
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Question1")
        view.clipsToBounds = true
        return view
    }()
    private let questionText : UITextView = {
        let label = UITextView()
        label.text = nil
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.isScrollEnabled = false
        label.isUserInteractionEnabled = false
        return label
    }()
    //녹음
    private let mic : UIButton = {
        let btn = UIButton()
        btn.tintColor = .gray
        btn.setImage(UIImage(systemName: "mic.fill"), for: .normal)
        btn.backgroundColor = .white
        btn.layer.cornerRadius = 15
        btn.layer.masksToBounds = true
        btn.layer.shadowOffset = CGSize(width: 3, height: 3)
        btn.layer.shadowColor = UIColor.gray.cgColor
        return btn
    }()
    //재생
    private let play : UIButton = {
        let btn = UIButton()
        btn.tintColor = .gray
        btn.setImage(UIImage(systemName: "play.fill"), for: .normal)
        btn.backgroundColor = .white
        btn.layer.cornerRadius = 15
        btn.layer.masksToBounds = true
        btn.layer.shadowOffset = CGSize(width: 3, height: 3)
        btn.layer.shadowColor = UIColor.gray.cgColor
        return btn
    }()
    //정지
    private let stop : UIButton = {
        let btn = UIButton()
        btn.tintColor = .gray
        btn.setImage(UIImage(systemName: "stop.fill"), for: .normal)
        btn.backgroundColor = .white
        btn.layer.cornerRadius = 15
        btn.layer.masksToBounds = true
        btn.layer.shadowOffset = CGSize(width: 3, height: 3)
        btn.layer.shadowColor = UIColor.gray.cgColor
        return btn
    }()
    private let nextBtn : UIButton = {
        let btn = UIButton()
        btn.setTitle("다음 페이지 ➜", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        btn.backgroundColor = .clear
        return btn
    }()
    private let progress : UIProgressView = {
        let view = UIProgressView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setBinding()
    }
}
//MARK: - UI Layout
extension FirstQuestionViewController {
    private func setLayout() {
        self.view.backgroundColor = .white
        self.title = ""
        self.view.addSubview(image)
        self.view.addSubview(questionText)
        self.view.addSubview(progress)
        self.view.addSubview(mic)
        self.view.addSubview(play)
        self.view.addSubview(stop)
        self.view.addSubview(nextBtn)
        image.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview().inset(0)
        }
        questionText.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(80)
            make.top.equalToSuperview().offset(self.view.frame.height / 8)
        }
        progress.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(questionText.snp.bottom).offset(0)
            make.height.equalTo(20)
        }
        mic.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(100)
            make.height.width.equalTo(50)
        }
        play.snp.makeConstraints { make in
            make.top.equalTo(mic.snp.top)
            make.bottom.equalTo(mic.snp.bottom)
            make.leading.equalTo(mic.snp.trailing).offset(50)
            make.height.width.equalTo(50)
        }
        stop.snp.makeConstraints { make in
            make.top.equalTo(mic.snp.top)
            make.bottom.equalTo(mic.snp.bottom)
            make.trailing.equalTo(mic.snp.leading).offset(-50)
            make.height.width.equalTo(50)
        }
        nextBtn.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(30)
            make.bottom.equalToSuperview().inset(50)
            make.height.equalTo(20)
        }
    }
}
//MARK: - Binding
extension FirstQuestionViewController {
    private func setTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
        timer?.fire()
    }
    @objc private func updateProgress() {
        let progressValue = Float(voiceRecordViewModel.audioRecorder.currentTime) / Float(60) //1분 제한
        if Float(voiceRecordViewModel.audioRecorder.currentTime) >= Float(60) {
            self.voiceRecordViewModel.stopTrigger.onNext(())
            self.mic.tintColor = .systemGray
            self.stop.tintColor = .systemRed
            self.play.tintColor = .systemGray
        }
        progress.setProgress(progressValue, animated: true)
    }
    private func setBinding() {
        voiceRecordViewModel.questionTrigger.onNext(())
        voiceRecordViewModel.questionResult
            .subscribe(onNext: {[weak self] question in
                guard let self = self else { return }
                guard let audioURL = URL(string: question.data?.accessUrls?.first ?? "") else {return}
                DispatchQueue.main.async {
                    self.question = question
                    self.questionText.text = question.data?.questionTexts?.first
                    self.player = AVPlayer(url: audioURL)
                    self.player?.play()
                }
            })
            .disposed(by: disposeBag)
        mic.rx.tap
            .subscribe(onNext: {[weak self] in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.voiceRecordViewModel.recordTrigger.onNext(())
                    self.mic.tintColor = .systemGreen
                    self.stop.tintColor = .systemGray
                    self.play.tintColor = .systemGray
                    
                    self.setTimer()
                }
            })
            .disposed(by: disposeBag)
        play.rx.tap
            .subscribe(onNext: {[weak self] in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.voiceRecordViewModel.playTrigger.onNext(())
                    self.mic.tintColor = .systemGray
                    self.stop.tintColor = .systemGray
                    self.play.tintColor = .systemBlue
                    
                    self.timer?.invalidate() //타이머 정지
                    self.timer = nil
                }
            })
            .disposed(by: disposeBag)
        stop.rx.tap
            .subscribe(onNext: {[weak self] in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.voiceRecordViewModel.stopTrigger.onNext(())
                    self.mic.tintColor = .systemGray
                    self.stop.tintColor = .systemRed
                    self.play.tintColor = .systemGray
                    
                    self.timer?.invalidate() //타이머 정지
                    self.timer = nil
                }
            })
            .disposed(by: disposeBag)
        nextBtn.rx.tap
            .subscribe { _ in
                guard let question = self.question else { return }
                self.navigationController?.pushViewController(SecondQuestionViewController(question: question), animated: true)
            }
            .disposed(by: disposeBag)
    }
}
