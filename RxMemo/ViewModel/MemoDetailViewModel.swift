//
//  MemoDetailViewModel.swift
//  RxMemo
//
//  Created by Chris Kim on 9/6/22.
//

import Foundation
import RxSwift
import RxCocoa
import Action


class MemoDetailViewModel: CommonViewModel {
    
    let memo: Memo
    
    private var formatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "ko_kr")
        f.dateStyle = .medium
        f.timeStyle = .medium
        return f
    }()
    
    // 테이블뷰에 바인딩할 문자열은 2개(content, date) -> 문자열 배열은 방출하는 subject 생성
    // Observable 생성해도 상관 없는데 BehaviorSubject로 선언한 이유 => 편집 시 메모 보기화면으로 돌아오면 편집한 내용을 방출해야함: 일반 Observable은 이 동작이 불가능함
    var content: BehaviorSubject<[String]>
    
    
    init(memo: Memo, title: String, sceneCoordinator: SceneCoordinatorType, storage: MemoStorageType) {
        self.memo = memo
        
        content = BehaviorSubject<[String]>(value: [
            memo.content,
            formatter.string(from: memo.insertDate)
        ])
        
        super.init(title: title, sceneCoordinator: sceneCoordinator, storage: storage)
    }
    
    
    lazy var popAction = CocoaAction { [unowned self] in
        return self.sceneCoordinator.close(animated: true)
            .asObservable()
            .map { _ in }
    }
    
    
    func performUpdate(memo: Memo) -> Action<String, Void> {
        return Action { input in
            self.storage.update(memo: memo, content: input)
                .map { [$0.content, self.formatter.string(from: $0.insertDate)] }
                .bind(onNext: { self.content.onNext($0) })
                .disposed(by: self.rx.disposeBag)
            
            return Observable.empty()
        }
    }
    
    
    func makeEditAction() -> CocoaAction {
        return CocoaAction { _ in
            let composeViewModel = MemoComposeViewModel(title: "메모 편집",
                                                        content: self.memo.content,
                                                        sceneCoordinator: self.sceneCoordinator,
                                                        storage: self.storage,
                                                        saveAction: self.performUpdate(memo: self.memo))
            
            let composeScene = Scene.compose(composeViewModel)
            
            return self.sceneCoordinator.transition(to: composeScene, using: .modal, animated: true)
                .asObservable()
                .map { _ in }
        }
    }
    
    
    func makeDeleteAction() -> CocoaAction {
        return Action { input in
            self.storage.delete(memo: self.memo)
            
            return self.sceneCoordinator.close(animated: true)
                .asObservable()
                .map { _ in }
        }
    }
}
