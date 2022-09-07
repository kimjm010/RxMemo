//
//  MemoDetailViewController.swift
//  RxMemo
//
//  Created by Chris Kim on 9/6/22.
//

import UIKit
import RxSwift
import RxCocoa
import Action
import NSObject_Rx


class MemoDetailViewController: UIViewController, ViewModelBindableType {
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var contentTableView: UITableView!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    

    // MARK: - Vars
    
    var viewModel: MemoDetailViewModel!
    
    
    // MARK: - Bind ViewModel to View
    
    func bindViewModel() {
        
        viewModel.title
            .drive(navigationItem.rx.title)
            .disposed(by: rx.disposeBag)
        
        viewModel.content
            .bind(to: contentTableView.rx.items) { (tableView, row, value) in
                switch row {
                case 0:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "contentCell")!
                    cell.textLabel?.text = value
                    return cell
                case 1:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell")!
                    cell.textLabel?.text = value
                    return cell
                default:
                    fatalError()
                }
            }
            .disposed(by: rx.disposeBag)
        
        
        editButton.rx.action = viewModel.makeEditAction()
        
        
        shareButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { (vc, _) in
                let memo = vc.viewModel.memo.content
                
                let activityVC = UIActivityViewController(activityItems: [memo], applicationActivities: nil)
                vc.present(activityVC, animated: true, completion: nil)
            })
            .disposed(by: rx.disposeBag)
        
        
        deleteButton.rx.action = viewModel.makeDeleteAction()
    }
    
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
}
