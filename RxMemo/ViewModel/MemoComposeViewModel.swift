//
//  MemoComposeViewModel.swift
//  RxMemo
//
//  Created by Chris Kim on 9/6/22.
//

import Foundation
import RxSwift
import RxCocoa
import Action

// 메모 추가, 편집할 때 공통적으로 사용
class MemoComposeViewModel: CommonViewModel {
    
    /// compose Scene에 표시할 메모를 저장할 속성
    /// 메모 추가 시 nil, 편집하 때 편집할 내용 저장
    private let content: String?
    
    /// 메모 속성을 View에 binding할 수 있도록 driver 추가
    var initialText: Driver<String?> {
        return Observable.just(content).asDriver(onErrorJustReturn: nil)
    }
    
    /// 저장, 취소 2가지 액션 구현
    let saveAction: Action<String, Void>
    let cancelAction: CocoaAction
    
    
    /// ViewModel에서 취소, 저장코드를 직접 구현할 수 있지만, 지금은 취소, 저장 액션은 파라미터로 받고 있음
    /// ViewModel에서 직접 구현하면 처리방삭이 1개로 고정됨
    /// 파라미터로 받으면 이전화면에서 처리방식을 동적으로 결정할 수 있음
    init(title: String,
         content: String? = nil,
         sceneCoordinator: SceneCoordinatorType,
         storage: MemoStorageType,
         saveAction: Action<String, Void>? = nil,
         cancelAction: CocoaAction? = nil) {
        
        self.content = content
        
        self.saveAction = Action<String, Void> { input in
            if let action = saveAction {
                action.execute(input)
            }
            
            return sceneCoordinator.close(animated: true).asObservable().map { _ in }
        }
        
        self.cancelAction = CocoaAction {
            if let action = cancelAction {
                action.execute()
            }
            
            return sceneCoordinator.close(animated: true).asObservable().map { _ in }
        }
        
        super.init(title: title, sceneCoordinator: sceneCoordinator, storage: storage)
    }
    
    
}
