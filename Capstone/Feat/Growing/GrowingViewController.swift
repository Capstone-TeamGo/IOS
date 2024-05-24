//
//  GrowingViewController.swift
//  Capstone
//
//  Created by 정성윤 on 2024/05/17.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit
import SnapKit
import Kingfisher

final class GrowingViewController : UIViewController {
    private let disposeBag = DisposeBag()
    private let reissueViewModel = ReissueViewModel()
    //MARK: - UI Components
    private let topFrame : UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        view.image = UIImage(named: "topFrame")
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        return view
    }()
    //GIf
    private let tree : UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        view.image = nil
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        return view
    }()
    //진행바
    private let progress : UIProgressView = {
        let view = UIProgressView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.progress = Float((CGFloat(0.3)))
        view.tintColor = .systemGreen
        return view
    }()
    //퍼센트
    private let percent : UILabel = {
        let label = UILabel()
        label.text = "30%🏃🏻‍♀️"
        label.textColor = .black
        label.textAlignment = .right
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    private let bottomFrame : UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        view.image = UIImage(named: "bottomFrame")
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        return view
    }()
    private let bottomText : UITextView = {
        let view = UITextView()
        view.backgroundColor = .clear
        view.textColor = .gray
        view.font = UIFont.systemFont(ofSize: 13)
        view.isUserInteractionEnabled = false
        view.isScrollEnabled = false
        return view
    }()
    private let upBtn : UIButton = {
        let btn = UIButton()
        btn.setTitle("힐링이 성장시키기 >", for: .normal)
        btn.setTitleColor(.systemGreen, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        return btn
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        UINavigation()
        setLayout()
        TypingAnimation()
        setBinding()
    }
}
//MARK: - UINavigation
extension GrowingViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.tintColor = .black
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.tintColor = .white
    }
    private func UINavigation() {
        self.view.backgroundColor = .white
        self.view.clipsToBounds = true
    }
}
//MARK: - UI Layout
private extension GrowingViewController {
    private func setLayout() {
        self.title = ""
        self.view.addSubview(topFrame)
        self.view.addSubview(tree)
        self.view.addSubview(progress)
        self.view.addSubview(percent)
        self.view.addSubview(bottomFrame)
        self.view.addSubview(bottomText)
        self.view.addSubview(upBtn)
        
        topFrame.snp.makeConstraints { make in
            make.center.equalToSuperview().inset(100)
            make.height.equalToSuperview().dividedBy(4)
        }
        tree.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(topFrame.snp.top).offset(20)
            make.height.equalToSuperview().dividedBy(5)
        }
        progress.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(30)
            make.trailing.equalToSuperview().inset(90)
            make.height.equalTo(20)
            make.top.equalToSuperview().inset(self.view.frame.height / 9)
            make.centerX.equalToSuperview()
        }
        percent.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.trailing.equalToSuperview().inset(20)
            make.leading.equalTo(progress.snp.trailing).offset(10)
            make.top.equalToSuperview().inset(self.view.frame.height / 9)
        }
        bottomFrame.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(topFrame.snp.bottom).offset(20)
            make.bottom.equalToSuperview().inset(self.view.frame.height / 10)
        }
        bottomText.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(100)
            make.top.equalTo(topFrame.snp.bottom).offset(60)
        }
        upBtn.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(100)
            make.bottom.equalToSuperview().inset(self.view.frame.height / 7)
        }
        if let gifUrl = Bundle.main.url(forResource: "flowerInit", withExtension: "gif") {
            tree.kf.setImage(with: gifUrl)
        }
    }
    private func TypingAnimation() {
        let fullText : String = "나만의 힐링이를 키워보세요! 많은 감정 분석과 상담을 받을수록 힐링이는 더 성장해요!🌳 힐링이를 성장시켜 혜택을 받아보세요🕊️"
        Observable<Int>
            .interval(.milliseconds(100), scheduler: MainScheduler.instance)
            .take(fullText.count)
            .subscribe(onNext: { [weak self] index in
                guard let self = self else { return }
                let stringIndex = fullText.index(fullText.startIndex, offsetBy: index)
                self.bottomText.text += String(fullText[stringIndex])
            }).disposed(by: disposeBag)
    }
}
//MARK: - Binding
private extension GrowingViewController {
    private func setBinding() {
        //토큰 유효성 검사
        reissueViewModel.reissueTrigger.onNext(())
        reissueViewModel.reissueExpire.bind(onNext: { [weak self] expire in
            guard let self = self else { return }
            if expire == true {
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(LoginViewController(), animated: true)
                }
            } else {
                upBtn.rx.tap.bind { _ in
                    DispatchQueue.main.async {
                        self.navigationController?.pushViewController(FirstQuestionViewController(), animated: true)
                    }
                }.disposed(by: disposeBag)
            }
        }).disposed(by: disposeBag)
    }
}
