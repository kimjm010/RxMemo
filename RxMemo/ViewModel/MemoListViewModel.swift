//
//  MemoListViewModel.swift
//  RxMemo
//
//  Created by Chris Kim on 9/6/22.
//

import Foundation
import RxSwift
import RxCocoa


// 메모 목록화면에서 사용하는 ViewModel

// ViewModel -> 1. 의존성을 주입하는 initializer 2. Binding에 사용되는 속성, 메소드
// ViewModel -> 화면전환 + 메모저장을 모두 처리 -> SceneCoordinatorType, MemoStorageType를 활용
// ViewModel 생성 시점에 initializer를통해 의존성을 주입해야함
// => 효율적인 처리를 위한 CommonViewModel 클래스 생성
class MemoListViewModel: CommonViewModel {
    var memoList: Observable<[Memo]> {
        return storage.memoList()
    }
}
