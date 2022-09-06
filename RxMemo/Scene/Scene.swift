//
//  Scene.swift
//  RxMemo
//
//  Created by Chris Kim on 9/6/22.
//

import UIKit


// 앱에서 구현할 scene을 열거형으로
// viewModel을 연관값으로 저장
enum Scene {
    case list(MemoListViewModel)
    case detail(MemoDetailViewModel)
    case compose(MemoComposeViewModel)
}




// Storyboard Scene을 생성 -> 연관값에 저장된 viewModel을 바인딩해서 리턴
extension Scene {
    func instantiate(from storyboard: String = "Main") -> UIViewController {
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        
        switch self {
        case .list(let memoListViewModel):
            // 메모 목록 scene을 생성 -> viewModel을 바인딩 후 리턴
            guard let nav = storyboard.instantiateViewController(withIdentifier: "ListNav") as? UINavigationController else {
                fatalError()
            }
            
            guard var listVC = nav.viewControllers.first as? MemoListViewController else {
                fatalError()
            }
            
            listVC.bind(viewModel: memoListViewModel)
            
            // Navigation Controller를 리턴해야 Nav Bar, Nav Stack이 정상적으로 동작함
            return nav
            
        case .detail(let memoDetailViewModel):
            
            guard var deatilVC = storyboard.instantiateViewController(withIdentifier: "DetailVC") as? MemoDetailViewController else {
                fatalError()
            }
            
            deatilVC.bind(viewModel: memoDetailViewModel)
            
            return deatilVC
            
        case .compose(let memoComposeViewModel):
    
            guard let nav = storyboard.instantiateViewController(withIdentifier: "ComposeNav") as? UINavigationController else { fatalError() }
            
            guard var composeVC = nav.viewControllers.first as? MemoComposeViewController else {
                fatalError()
            }
            
            composeVC.bind(viewModel: memoComposeViewModel)
            
            return nav
        }
    }
}

