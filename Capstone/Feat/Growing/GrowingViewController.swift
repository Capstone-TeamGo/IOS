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
    //MARK: - UI Components
    private let frame : UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        view.image = UIImage(named: "gameFrame")
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        return view
    }()
    //캐릭터 관리 버튼
    //힐링이 업그레이드를 시키기 위한 버튼 -> 감정 분석 페이지로 이동
    private let upBtn : UIButton = {
        let btn = UIButton()
        btn.layer.cornerRadius = 15
        btn.layer.masksToBounds = true
        btn.backgroundColor = .SecondaryColor
        btn.setTitle("🌳", for: .normal)
        return btn
    }()
    //힐링이 위한 설명 버튼 -> 설명 페이지
    private let explainBtn : UIButton = {
        let btn = UIButton()
        btn.layer.cornerRadius = 15
        btn.layer.masksToBounds = true
        btn.backgroundColor = .ThirdryColor
        btn.setTitle("📝", for: .normal)
        return btn
    }()
    //힐링이 ??
    private let Btn1 : UIButton = {
        let btn = UIButton()
        btn.layer.cornerRadius = 15
        btn.layer.masksToBounds = true
        btn.backgroundColor = .FourthryColor
        btn.setTitle("🍃", for: .normal)
        return btn
    }()
    //힐링이 ??
    private let Btn2 : UIButton = {
        let btn = UIButton()
        btn.layer.cornerRadius = 15
        btn.layer.masksToBounds = true
        btn.backgroundColor = .FifthryColor
        btn.setTitle("🌸", for: .normal)
        return btn
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
    override func viewDidLoad() {
        super.viewDidLoad()
        UINavigation()
        setLayout()
    }
}
//MARK: - UINavigation
extension GrowingViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.tintColor = .black
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
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
        let BtnView = UIView()
        BtnView.backgroundColor = .white
        BtnView.addSubview(upBtn)
        BtnView.addSubview(explainBtn)
        BtnView.addSubview(Btn1)
        BtnView.addSubview(Btn2)
        
        self.view.addSubview(BtnView)
        self.view.addSubview(frame)
        self.view.addSubview(tree)
        self.view.addSubview(progress)
        self.view.addSubview(percent)
        
        frame.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
        }
        upBtn.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(0)
            make.width.height.equalTo(50)
        }
        explainBtn.snp.makeConstraints { make in
            make.leading.equalTo(upBtn.snp.trailing).offset(30)
            make.width.height.equalTo(50)
        }
        Btn1.snp.makeConstraints { make in
            make.leading.equalTo(explainBtn.snp.trailing).offset(30)
            make.width.height.equalTo(50)
        }
        Btn2.snp.makeConstraints { make in
            make.leading.equalTo(Btn1.snp.trailing).offset(30)
            make.width.height.equalTo(50)
            make.trailing.equalToSuperview().inset(0)
        }
        BtnView.snp.makeConstraints { make in
            make.width.equalTo(290)
            make.height.equalTo(50)
            make.top.equalToSuperview().inset(self.view.frame.height / 9)
            make.centerX.equalToSuperview()
        }
        tree.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(130)
            make.center.equalToSuperview()
            make.top.equalToSuperview().inset(self.view.frame.height / 5)
            make.bottom.equalToSuperview().inset(self.view.frame.height / 2.5)
        }
        progress.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().inset(90)
            make.height.equalTo(20)
            make.bottom.equalToSuperview().inset(self.view.frame.height / 7)
        }
        percent.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.trailing.equalToSuperview().inset(20)
            make.leading.equalTo(progress.snp.trailing).offset(10)
            make.bottom.equalToSuperview().inset(self.view.frame.height / 7)
        }
//        if let gifUrl = Bundle.main.url(forResource: "healing4", withExtension: "gif") {
//            tree.kf.setImage(with: gifUrl)
//        }
    }
}
//MARK: - Binding
private extension GrowingViewController {
    
}
