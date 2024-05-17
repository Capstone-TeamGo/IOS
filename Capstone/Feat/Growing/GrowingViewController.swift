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
        view.image = UIImage(named: "photoFrame")
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    private let tree : UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .gray
        view.image = nil
        view.contentMode = .scaleAspectFit
        return view
    }()
    private let progress : UIProgressView = {
        let view = UIProgressView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
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
        self.view.addSubview(frame)
        self.view.addSubview(tree)
        self.view.addSubview(progress)
        
        frame.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().dividedBy(2)
            
        }
        tree.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(frame.snp.top).inset(frame.frame.height / 3)
        }
        progress.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(20)
            make.top.equalTo(frame.snp.bottom).offset(30)
        }
    }
}
//MARK: - Binding
private extension GrowingViewController {
    
}
