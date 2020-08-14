//
//  BingoModel.swift
//  Bingo
//
//  Created by R on 2020/08/14.
//  Copyright © 2020 マック太郎. All rights reserved.
//

import Combine
import Foundation
import QuartzCore

class BingoModel: ObservableObject {

    enum State: String {
        case start = "Stop"
        case stop = "Start"
        case end = "End"
    }

    // List表示用のためIdentifiableに準拠する必要あり
    struct HistoryNumbers: Identifiable {
        var id: Int
    }

    @Published var currentNumber = 0
    @Published var remnantNumbers = [Int](1...75)
    @Published var historyNumbers = [HistoryNumbers]()
    @Published var state = State.stop

    private var displayLink: CADisplayLink!

    /// 抽選
    func lottery() {
        state = .start
        remnantNumbers.shuffle()
        displayLink = CADisplayLink(target: self, selector: #selector(loop))
        displayLink.preferredFramesPerSecond = 60
        displayLink.add(to: RunLoop.current, forMode: RunLoop.Mode.common)
    }

    /// 抽選停止
    func stop() {
        state = .stop
        displayLink.invalidate()
        displayLink = nil
        remnantNumbers.remove(value: currentNumber)
        historyNumbers.append(HistoryNumbers(id: currentNumber))

        if remnantNumbers.isEmpty {
            state = .end
        }

    }


    /// 最初からにする
    func reset() {
        currentNumber = 0
        remnantNumbers = [Int](1...75)
        historyNumbers = [HistoryNumbers]()
        state = State.stop

    }

    @objc private func loop() {
        currentNumber = remnantNumbers[Int.random(in: 0...(remnantNumbers.count - 1))]
    }
}

extension Array where Element: Equatable {
    mutating func remove(value: Element) {
        if let i = self.firstIndex(of: value) {
            self.remove(at: i)
        }
    }
}

