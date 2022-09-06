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
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }   
}
