//
//  AnalysisPagingViewController.swift
//  Capstone
//
//  Created by 정성윤 on 2024/05/25.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit
import SnapKit
import SwiftKeychainWrapper

final class AnalysisPagingViewController : UIViewController {
    private let disposeBag = DisposeBag()
    private let analysisPagingViewModel = AnalysisPagingViewModel()
    private let reissueViewModel = ReissueViewModel()
    //MARK: - UI Components
    private let refresh : UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.tintColor = .gray
        return refresh
    }()
    private let imageView : UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        view.clipsToBounds = true
        view.image = UIImage(named: "Splash")
        return view
    }()
    private let tableView : UITableView = {
        let view = UITableView()
        view.backgroundColor = .clear
        view.register(AnalysisPagingTableViewCell.self, forCellReuseIdentifier: AnalysisPagingTableViewCell.id)
        return view
    }()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.tintColor = .black
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setBinding()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.tintColor = .white
    }
}
//MARK: - UI Layout
private extension AnalysisPagingViewController {
    private func setLayout() {
        self.view.backgroundColor = .white
        self.title = ""
        self.view.addSubview(imageView)
        self.tableView.refreshControl = refresh
        self.view.addSubview(tableView)
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
//MARK: - Binding
private extension AnalysisPagingViewController {
    private func setBinding() {
        //토큰 유효성 검사
        reissueViewModel.reissueTrigger.onNext(())
        reissueViewModel.reissueExpire
            .take(1)
            .bind(onNext: { [weak self] expire in
            guard let self = self else { return }
            if expire == true {
                DispatchQueue.main.async {
                    self.logoutAlert()
                }
            }else{
                self.analysisPagingViewModel.refreshTrigger.onNext(())
                self.analysisPagingViewModel.pagingResult.bind(to: tableView.rx.items(cellIdentifier: AnalysisPagingTableViewCell.id, cellType: AnalysisPagingTableViewCell.self)) { index, model, cell in
                    cell.configure(model: model)
                    cell.selectionStyle = .none
                    cell.backgroundColor = .clear
                }.disposed(by: disposeBag)
                self.tableView.rx.modelSelected(AnaylsisResponseDtoList.self)
                    .subscribe { selectedModel in
                        self.navigationController?.pushViewController(AnalysisDetailViewController(model: selectedModel), animated: true)
                    }
                    .disposed(by: disposeBag)
                self.refresh.rx.controlEvent(.valueChanged)
                    .subscribe { _ in
                        self.analysisPagingViewModel.refreshTrigger.onNext(())
                        self.refresh.endRefreshing()
                    }.disposed(by: disposeBag)
                self.tableView.rx.contentOffset
                    .flatMapLatest { [weak self] contentOffset -> Observable<Void> in
                        guard let self = self else { return Observable.empty() }
                        let contentHeight = self.tableView.contentSize.height
                        let offsetY = contentOffset.y
                        let frameHeight = self.tableView.frame.size.height
                        
                        if offsetY > (contentHeight - frameHeight) {
                            return Observable.just(())
                        } else {
                            return Observable.empty()
                        }
                    }
                    .bind(to: self.analysisPagingViewModel.nextPageTrigger)
                    .disposed(by: self.disposeBag)
            }
        }).disposed(by: disposeBag)
    }
    private func logoutAlert() {
        let Alert = UIAlertController(title: "세션이 만료되어 로그아웃 되었습니다.", message: nil, preferredStyle: .alert)
        let Ok = UIAlertAction(title: "확인", style: .default) { _ in
            //키체인에 저장된 값 모두 삭제
            KeychainWrapper.standard.removeAllKeys()
            self.navigationController?.pushViewController(LoginViewController(), animated: true)
        }
        Alert.addAction(Ok)
        self.present(Alert, animated: true)
    }
}
