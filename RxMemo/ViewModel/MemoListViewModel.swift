//
//  MemoListViewModel.swift
//  RxMemo
//
//  Created by Chris Kim on 9/6/22.
//

import Foundation
import RxSwift
import RxCocoa
import Action


// 메모 목록화면에서 사용하는 ViewModel

// ViewModel -> 1. 의존성을 주입하는 initializer 2. Binding에 사용되는 속성, 메소드
// ViewModel -> 화면전환 + 메모저장을 모두 처리 -> SceneCoordinatorType, MemoStorageType를 활용
// ViewModel 생성 시점에 initializer를통해 의존성을 주입해야함
// => 효율적인 처리를 위한 CommonViewModel 클래스 생성
class MemoListViewModel: CommonViewModel {
    
    var memoList: Observable<[Memo]> {
        return storage.memoList()
    }
    
    func makeCreateAction() -> CocoaAction {
        return CocoaAction { _ in
            
            // createMemo를 호출하면 새로운메모가 만들어지고 이 메모를 방출하는 Observable이 리턴됨
            return self.storage.createMemo(content: "")
                .flatMap { memo -> Observable<Void> in
                    // 여기서 화면전화을 처리
                    
                    let composeViewModel = MemoComposeViewModel(title: "새 메모", sceneCoordinator: self.sceneCoordinator, storage: self.storage, saveAction: self.performUpdate(memo: memo), cancelAction: self.performCancel(memo: memo))
                    
                    let composeScene = Scene.compose(composeViewModel)
                    
                    return self.sceneCoordinator.transition(to: composeScene, using: .modal, animated: true)
                        .asObservable()
                        .map { _ in }
                }
        }
    }
    
    
    func performUpdate(memo: Memo) -> Action<String, Void> {
        return Action { input in
            return self.storage.update(memo: memo, content: input)
                .debug()
                .map { _ in }
        }
    }
    
    
    func performCancel(memo: Memo) -> CocoaAction {
        return Action {
            return self.storage.delete(memo: memo).map { _ in }
        }
    }
    
    
    //closure내에서 self로 접근해야해서 lazy로 선언
    lazy var detailAction: Action<Memo, Void> = {
        
        return Action { memo in
            
            let detailViewModel = MemoDetailViewModel(memo: memo,
                                                      title: "메모 보기",
                                                      sceneCoordinator: self.sceneCoordinator,
                                                      storage: self.storage)
            
            let detailScene = Scene.detail(detailViewModel)
            
            return self.sceneCoordinator.transition(to: detailScene, using: .push, animated: true)
                .asObservable()
                .map { _ in }
        }
    }()
}
