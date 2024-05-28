//
//  SecondQuestionViewController.swift
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
import NVActivityIndicatorView
import SCLAlertView

final class SecondQuestionViewController : UIViewController {
    private let disposeBag = DisposeBag()
    private let voiceRecordViewModel = VoiceRecordViewModel()
    private let reissueViewModel = ReissueViewModel()
    //Audio(AVFoundation)
    private var timer : Timer?
    private var player : AVPlayer?
    var question : QuestionResponseModel
    init(question : QuestionResponseModel){
        self.question = question
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - UI Components
    private let image : UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .ThirdryColor
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Question2")
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
    private let loadingIndicator : NVActivityIndicatorView = {
        let view = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50), type: .ballBeat, color: .white)
        return view
    }()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setValue()
        setBinding()
        setTimer()
    }
    private func setValue(){
        guard let audioURL = URL(string: self.question.data?.accessUrls?[1] ?? "") else { return }
        self.questionText.text = question.data?.questionTexts?[1] ?? ""
        self.player = AVPlayer(url: audioURL)
        self.player?.play()
    }
}
//MARK: - UI Layout
private extension SecondQuestionViewController {
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
        self.view.addSubview(loadingIndicator)
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
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
//MARK: - Binding
private extension SecondQuestionViewController {
    private func setTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
        timer?.fire()
    }
    @objc private func updateProgress() {
        let progressValue = Float(voiceRecordViewModel.audioRecorder.currentTime) / Float(60) //5분 제한
        if Float(voiceRecordViewModel.audioRecorder.currentTime) >= Float(60) {
            self.voiceRecordViewModel.stopTrigger.onNext(())
            self.mic.tintColor = .systemGray
            self.stop.tintColor = .systemRed
            self.play.tintColor = .systemGray
        }
        progress.setProgress(progressValue, animated: true)
    }
    private func setBinding() {
        //토큰 유효성 검사
        reissueViewModel.reissueTrigger.onNext(())
        reissueViewModel.reissueExpire
            .take(1)
            .bind { expire in
            if expire == true {
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(LoginViewController(), animated: true)
                }
            } else {
                DispatchQueue.main.async {
                    guard let audioURL = URL(string: self.question.data?.accessUrls?[1] ?? "") else {return}
                    self.questionText.text = self.question.data?.questionTexts?[1]
                    self.player = AVPlayer(url: audioURL)
                    self.player?.play()
                }
                self.mic.rx.tap
                    .subscribe(onNext: {[weak self] in
                        guard let self = self else { return }
                        DispatchQueue.main.async {
                            self.voiceRecordViewModel.recordTrigger.onNext(())
                            self.loadingIndicator.stopAnimating()
                            self.mic.tintColor = .systemGreen
                            self.stop.tintColor = .systemGray
                            self.play.tintColor = .systemGray
                            
                            self.setTimer()
                        }
                    })
                    .disposed(by: self.disposeBag)
                self.play.rx.tap
                    .subscribe(onNext: {[weak self] in
                        guard let self = self else { return }
                        DispatchQueue.main.async {
                            self.voiceRecordViewModel.playTrigger.onNext(())
                            self.loadingIndicator.stopAnimating()
                            self.mic.tintColor = .systemGray
                            self.stop.tintColor = .systemGray
                            self.play.tintColor = .systemBlue
                            
                            self.timer?.invalidate() //타이머 정지
                            self.timer = nil
                        }
                    })
                    .disposed(by: self.disposeBag)
                self.stop.rx.tap
                    .subscribe(onNext: {[weak self] in
                        guard let self = self else { return }
                        DispatchQueue.main.async {
                            self.voiceRecordViewModel.stopTrigger.onNext(())
                            self.loadingIndicator.stopAnimating()
                            self.mic.tintColor = .systemGray
                            self.stop.tintColor = .systemRed
                            self.play.tintColor = .systemGray
                            
                            self.timer?.invalidate() //타이머 정지
                            self.timer = nil
                        }
                    })
                    .disposed(by: self.disposeBag)
                self.nextBtn.rx.tap
                    .subscribe { _ in
                        self.voiceRecordViewModel.postRecordTrigger.onNext([self.question.data?.analysisId ?? 0, self.question.data?.questionIds?[1] ?? 0])
                        DispatchQueue.main.async {
                            self.loadingIndicator.startAnimating()
                        }
                    }
                    .disposed(by: self.disposeBag)
                self.voiceRecordViewModel.postRecordResult.subscribe(onNext: { [weak self] result in
                    guard let self = self else { return }
                    if result.code == 200 {
                        DispatchQueue.main.async {
                            self.loadingIndicator.stopAnimating()
                            self.navigationController?.pushViewController(ThirdQuestionViewController(question: self.question), animated: true)
                        }
                    }else if result.code == nil {
                        DispatchQueue.main.async {
                            let alert = SCLAlertView()
                            alert.showError("녹음을 완료해 주세요")
                            self.loadingIndicator.stopAnimating()
                        }
                    }
                }, onError: { error in
                    DispatchQueue.main.async {
                        self.navigationController?.pushViewController(ErrorViewController(), animated: true)
                    }
                })
                .disposed(by: self.disposeBag)
            }
        }.disposed(by: disposeBag)
    }
}
