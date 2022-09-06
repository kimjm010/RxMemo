//
//  MemoryStorage.swift
//  RxMemo
//
//  Created by Chris Kim on 9/5/22.
//

import Foundation
import RxSwift


// 메모리에 메모를 저장하는 클래스
class MemoryStorage: MemoStorageType {
    
    // 클래스 외부에서 배열에 직접 접근할 필요가 없어 private으로 선언
    // 배열은 Observable을 통해 외부로 공개됨
    // Observable은 배열의 상태가 업데이트되면 새로운 Next이벤트를 방출해야함 -> Subject -? Behavior로 생성(초기 더미데이터 표시해야해서)
    private var list = [
        Memo(content: "Hello, RxSwift", insertDate: Date().addingTimeInterval(-10)),
        Memo(content: "Hello, SwiftUI", insertDate: Date().addingTimeInterval(-20))
    ]
    
    private lazy var store = BehaviorSubject<[Memo]>(value: list)
    
    @discardableResult
    func createMemo(content: String) -> Observable<Memo> {
        // 새로운 메모를 생성
        let memo = Memo(content: content)
        // 리스트에 추가
        list.insert(memo, at: 0)
        
        // 리스트가 변경되었으니 subject에서 새로운 Next이벤트를 방출
        // -> ⭐️subject에서 새로운 Next 이벤트를 방출하도록 구현 => 추후에 subject를 tableView와 바인딩할 때 새로운 배열을 계속해서 방출해야 tableView가 업데이트 됨
        // RxSwift로는 reloadData()로 tableView가 업데이트 되지 않기때문에
        store.onNext(list)
        
        // 새로운 메모를 방출하는 Observable 리턴
        return Observable.just(memo)
    }
    
    
    @discardableResult
    func memoList() -> Observable<[Memo]> {
        return store
    }
    
    
    @discardableResult
    func update(memo: Memo, content: String) -> Observable<Memo> {
        // 업데이트된 메모 인스턴스 생성
        let updated = Memo(original: memo, updateContent: content)
        
        // 배열에 저장된 원본 인스턴스를 새로운(업데이트된) 인스턴스로 교체
        if let index = list.firstIndex(where: { $0 == memo }) {
            list.remove(at: index)
            list.insert(updated, at: index)
        }
        
        store.onNext(list)
        
        return Observable.just(updated)
    }
    
    
    @discardableResult
    func delete(memo: Memo) -> Observable<Memo> {
        if let index = list.firstIndex(where: { $0 == memo }) {
            list.remove(at: index)
        }
        
        store.onNext(list)
        
        return Observable.just(memo)
    }
}

