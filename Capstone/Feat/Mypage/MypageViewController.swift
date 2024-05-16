//
//  MypageViewController.swift
//  Capstone
//
//  Created by 정성윤 on 2024/03/27.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import AuthenticationServices
import SwiftKeychainWrapper

final class MypageViewController: UIViewController{
    private let disposeBag = DisposeBag()
    private let mypageViewModel = MypageViewModel()
    //MARK: UI Components
    private let naviLogo : UILabel = {
        let label = UILabel()
        label.text = "CheeYou"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .FifthryColor
        label.textAlignment = .left
        return label
    }()
    //이미지
    private let personImage : UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .white
        view.contentMode = .scaleAspectFit
        view.image = UIImage(systemName: "person.circle.fill")
        view.tintColor = .BackgroundColor
        return view
    }()
    //개인 정보 텍스트
    private let nameLabel : UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.text = "김승진"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()
    private let emailLabel : UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.text = "Permission@Denied"
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .center
        return label
    }()
    //하위 메뉴
    private let spacing : UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    private let logoutBtn : UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .clear
        btn.setTitle("로그아웃", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.setTitleColor(.gray, for: .highlighted)
        btn.configuration = .bordered()
        return btn
    }()
    private let listBtn : UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .clear
        btn.setTitle("분석 기록", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.setTitleColor(.gray, for: .highlighted)
        btn.configuration = .bordered()
        return btn
    }()
    private let feedBackBtn : UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .clear
        btn.setTitle("피드백 보내기", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.setTitleColor(.gray, for: .highlighted)
        btn.configuration = .bordered()
        return btn
    }()
    private let vsLabel : UITextView = {
        let label = UITextView()
        label.backgroundColor = .white
        label.text = "CheeYou v 1.0.0\nMade by CapstoneTeam3"
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .center
        label.isUserInteractionEnabled = false
        label.isScrollEnabled = false
        return label
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigation()
        setLayout()
        setBinding()
    }
}
//MARK: - UI Navigation
extension MypageViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = true
        self.tabBarController?.tabBar.isHidden = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.hidesBackButton = false
    }
    private func setNavigation() {
        self.title = "마이페이지"
        self.view.backgroundColor = .white
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: naviLogo)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = .white
    }
}
//MARK: - UI Layout
private extension MypageViewController {
    private func setLayout() {
        self.view.backgroundColor = .white
        self.view.addSubview(personImage)
        self.view.addSubview(nameLabel)
        self.view.addSubview(emailLabel)
        self.view.addSubview(spacing)
        self.view.addSubview(logoutBtn)
        self.view.addSubview(listBtn)
        self.view.addSubview(feedBackBtn)
        self.view.addSubview(vsLabel)
        
        personImage.snp.makeConstraints { make in
            make.height.equalToSuperview().dividedBy(4)
            make.leading.trailing.equalToSuperview().inset(80)
            make.top.equalToSuperview().offset(self.view.frame.height / 9)
        }
        nameLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(personImage.snp.bottom).offset(10)
            make.height.equalTo(20)
        }
        emailLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.height.equalTo(30)
        }
        spacing.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.top.equalTo(emailLabel.snp.bottom).offset(20)
            make.height.equalTo(0.5)
        }
        logoutBtn.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.top.equalTo(spacing.snp.bottom).offset(20)
            make.height.equalTo(40)
        }
        listBtn.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.top.equalTo(logoutBtn.snp.bottom).offset(20)
            make.height.equalTo(40)
        }
        feedBackBtn.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.top.equalTo(listBtn.snp.bottom).offset(20)
            make.height.equalTo(40)
        }
        vsLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(feedBackBtn.snp.bottom).offset(40)
            make.bottom.equalToSuperview().inset(self.view.frame.height / 9)
        }
    }
}
//MARK: - Binding
private extension MypageViewController {
    private func setBinding() {
        mypageViewModel.logoutResult.subscribe(onNext: { [weak self] result in
            guard let self = self else { return }
            if result.code == 200 {
                KeychainWrapper.standard.removeAllKeys() //저장된 토큰 삭제
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(LoginViewController(), animated: true)
                }
            }
        }).disposed(by: disposeBag)
        logoutBtn.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            self.mypageViewModel.logoutTrigger.onNext(())
        }.disposed(by: disposeBag)
        feedBackBtn.rx.tap.bind { [weak self] in
            guard let self = self else { return  }
            if let url = URL(string: "https://forms.gle/EG8UVLx8vfuoCuAS7"){
                UIApplication.shared.open(url)
            }
        }.disposed(by: disposeBag)
    }
    private func setBindView() {
        
    }
}
