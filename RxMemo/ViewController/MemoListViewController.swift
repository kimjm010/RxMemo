//
//  MemoLisstViewController.swift
//  RxMemo
//
//  Created by Chris Kim on 9/6/22.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx


class MemoListViewController: UIViewController, ViewModelBindableType {
    
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    
    
    var viewModel: MemoListViewModel!
    
    func bindViewModel() {
        // ViewModel - View Binding
        viewModel.title
            .drive(navigationItem.rx.title)
            .disposed(by: rx.disposeBag)
        
        // memolist -> Observable과 tableView를 바인딩
        viewModel.memoList
            .bind(to: listTableView.rx.items(cellIdentifier: "cell")) { (row, memo, cell) in
                cell.textLabel?.text = memo.content
            }
            .disposed(by: rx.disposeBag)
        
        addButton.rx.action = viewModel.makeCreateAction()
        
        Observable.zip(listTableView.rx.modelSelected(Memo.self), listTableView.rx.itemSelected)
            .withUnretained(self)
            .do(onNext: { (vc, data) in
                vc.listTableView.deselectRow(at: data.1, animated: true)
            })
            .map { $1.0 }
            .bind(to: viewModel.detailAction.inputs)
            .disposed(by: rx.disposeBag)
        
        listTableView.rx.modelDeleted(Memo.self)
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind(to: viewModel.deleteAction.inputs)
            .disposed(by: rx.disposeBag)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }   
}
