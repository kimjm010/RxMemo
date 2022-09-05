//
//  Memo.swift
//  RxMemo
//
//  Created by Chris Kim on 9/5/22.
//

import Foundation


struct Memo: Equatable {
    var content: String
    var insertDate: Date
    var identity: String
    
    init(content: String, insertDate: Date = Date()) {
        self.content = content
        self.insertDate = insertDate
        self.identity = "\(insertDate.timeIntervalSinceReferenceDate)"
    }
    
    // 업데이트된 내용으로 새로운 Memo 인스턴스를 생성할 때 사용항 생성자
    init(original: Memo, updateContent: String) {
        self = original
        self.content = updateContent
    }
}
