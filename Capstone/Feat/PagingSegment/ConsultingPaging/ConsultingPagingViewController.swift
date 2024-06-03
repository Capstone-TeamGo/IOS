//
//  ConsultingPagingViewController.swift
//  Capstone
//
//  Created by 정성윤 on 2024/05/31.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit
import SnapKit
import SwiftKeychainWrapper

final class ConsultingPagingViewController : UIViewController {
    private let disposeBag = DisposeBag()
    private let consultingPagingViewModel = ConsultingPagingViewModel()
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
        view.register(ConsultingPagingTableViewCell.self, forCellReuseIdentifier: ConsultingPagingTableViewCell.id)
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
private extension ConsultingPagingViewController {
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
private extension ConsultingPagingViewController {
    private func setBinding() {
        //토큰 유효성 검사
        reissueViewModel.reissueTrigger.onNext(())
        reissueViewModel.reissueExpire
            .take(1)
            .bind(onNext: { [weak self] expire in
            guard let self = self else { return }
            if expire == true {
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(LoginViewController(), animated: true)
                }
            }else{
                self.consultingPagingViewModel.refreshTrigger.onNext(())
                self.consultingPagingViewModel.pagingResult.bind(to: tableView.rx.items(cellIdentifier: ConsultingPagingTableViewCell.id, cellType: ConsultingPagingTableViewCell.self)) { index, model, cell in
                    cell.configure(model: model)
                    cell.selectionStyle = .none
                    cell.backgroundColor = .clear
                }.disposed(by: disposeBag)
                self.tableView.rx.modelSelected(CounselContent.self)
                    .subscribe { selectedModel in
                        self.navigationController?.pushViewController(ConsultingDetailViewController(model: selectedModel), animated: true)
                    }
                    .disposed(by: disposeBag)
                self.refresh.rx.controlEvent(.valueChanged)
                    .subscribe { _ in
                        self.consultingPagingViewModel.refreshTrigger.onNext(())
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
                    .bind(to: self.consultingPagingViewModel.nextPageTrigger)
                    .disposed(by: self.disposeBag)
            }
        }).disposed(by: disposeBag)
    }
}
