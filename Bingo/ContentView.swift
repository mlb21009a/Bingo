//
//  ContentView.swift
//  Bingo
//
//  Created by R on 2020/08/13.
//  Copyright © 2020 マック太郎. All rights reserved.
//

import SwiftUI

struct ContentView: View {

    @ObservedObject private var bingoModel = BingoModel()

    var body: some View {
        NavigationView {
            HStack {
                VStack {
                    self.circleText
                        .padding(.top, 100)
                    HStack {
                        Spacer()
                        self.lotteryButton
                        Spacer()
                        self.resetButton
                        Spacer()
                    }.padding(.top, 100)

                    Spacer()
                }

                self.historyView
            }
            .navigationBarTitle(Text("BINGO"))
        }
    }
}

// MARK: - パーツ
private extension ContentView {

    var circleText: some View {
        CircleNumberView(size: 96, number: self.bingoModel.currentNumber)
    }

    var lotteryButton: some View {
        Button(action: {
            switch self.bingoModel.state {
            case .start:
                self.bingoModel.stop()
            case .stop:
                self.bingoModel.lottery()
            case .end:
                break
            }
        }) {
            Text(self.bingoModel.state.rawValue)
                .font(.system(size: 36))
                .fontWeight(.bold)
        }
    }

    var resetButton: some View {
        Button(action: {
            self.bingoModel.reset()
        }) {
            Text("Reset")
                .font(.system(size: 36))
                .fontWeight(.bold)
        }
    }

    var historyView: some View {
        VStack {
            Text("Histroy")
                .font(.system(size: 24))
                .fontWeight(.bold)
                .foregroundColor(Color.blue)
                .padding(.top, 100)

            List(bingoModel.historyNumbers) { item in
                Group {
                    Spacer()
                    CircleNumberView(size: 12, number: item.id)
                    Spacer()
                }
            }
        }
        .frame(width: 100)

    }

    private struct CircleNumberView: View {

        var size: CGFloat
        var number: Int

        var body: some View {
            Text(String(number))
                .font(.system(size: size))
                .fontWeight(.bold)
                .foregroundColor(Color.red)
                .background(
                    GeometryReader { geometry in
                        Circle()
                            .foregroundColor(Color.yellow)
                            .frame(width: geometry.size.width + self.size, height: geometry.size.width + self.size)
                            .overlay(
                                GeometryReader { geometry in
                                    RoundedRectangle(cornerRadius: geometry.size.width/2)
                                        .stroke(Color.red, lineWidth: 1)
                                }
                        )
                })
                .shadow(radius: 10)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

