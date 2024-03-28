//
//  ThirdQuestionViewController.swift
//  Capstone
//
//  Created by 정성윤 on 2024/03/27.
//

import Foundation
import SnapKit
import RxSwift
import RxCocoa
import UIKit
class ThirdQuestionViewController : UIViewController {
    private let disposeBag = DisposeBag()
    private var isMicOn : Bool = false
    //MARK: - UI Components
    private let image : UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .FourthryColor
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Question3")
        view.clipsToBounds = true
        return view
    }()
    private let label : UILabel = {
        let label = UILabel()
        label.text = "Q1. 오늘은 어떤 하루를 보내셨나요?"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    private lazy var mic : UIButton = {
        let btn = UIButton()
        btn.tintColor = .gray
        btn.setImage(UIImage(systemName: "mic.fill"), for: .normal)
        btn.backgroundColor = .white
        btn.layer.cornerRadius = 15
        btn.layer.masksToBounds = true
        btn.layer.shadowOffset = CGSize(width: 3, height: 3)
        btn.layer.shadowColor = UIColor.gray.cgColor
        btn.addTarget(self, action: #selector(micBtnTapped), for: .touchUpInside)
        return btn
    }()
    private lazy var nextBtn : UIButton = {
        let btn = UIButton()
        btn.setTitle("다음 페이지 ➜", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        btn.backgroundColor = .clear
        btn.addTarget(self, action: #selector(nextBtnTapped), for: .touchUpInside)
        return btn
    }()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
    }
}
//MARK: - UI Layout
extension ThirdQuestionViewController {
    private func setLayout() {
        self.view.backgroundColor = .white
        self.title = ""
        self.view.addSubview(image)
        self.view.addSubview(label)
        self.view.addSubview(mic)
        self.view.addSubview(nextBtn)
        image.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview().inset(0)
        }
        label.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(20)
            make.top.equalToSuperview().offset(self.view.frame.height / 8)
        }
        mic.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(100)
            make.height.width.equalTo(50)
        }
        nextBtn.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(30)
            make.bottom.equalToSuperview().inset(50)
            make.height.equalTo(20)
        }
    }
}
//MARK: - Actions
extension ThirdQuestionViewController {
    @objc private func micBtnTapped() {
        mic.tintColor = isMicOn ? .gray : .systemGreen
        isMicOn.toggle()
    }
    @objc private func nextBtnTapped() {
        self.navigationController?.pushViewController(ForthQuestionViewController(), animated: true)
    }
}
