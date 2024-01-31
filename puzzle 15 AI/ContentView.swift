//
//  ContentView.swift
//  puzzle 15 AI
//
//  Created by Brody Dickson on 1/11/24.
//

import SwiftUI

struct PuzzleView: View {
    @State private var tiles = Array(0...8)
    @State private var shuffleCount = 0
    @State private var PlayerMoves = 0
    @State private var Playable = true
//    @State private var tilesColors = []


    var body: some View {
        ZStack{
            Color.blue
                .ignoresSafeArea()
            VStack {
                
                Text("Moves: \(PlayerMoves)")
                    .padding()
                    .font(.system(size: 30))
                    .foregroundColor(Color.white)
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 0) {
                    ForEach(tiles, id: \.self) { number in
                        Text("\(number)")
                            .font(.system(size: 30))
                            .frame(width: 80, height: 80)
                            .background(Color.teal)
                            .cornerRadius(10)
                            .shadow(radius: 10)
                            .onTapGesture {
                                if Playable == true {
                                    withAnimation {
                                        swapTiles(number)
                                    }
                                }
//                                if tiles[number] == number {
//
//                                }
                            }
                    }
                }
                Button("Shuffle") {
                    if Playable == false {
                        tiles[8] = 0
                    }
                    PlayerMoves = 0
                    Playable = true
                    shuffleTiles()
                }
                .buttonStyle(GrowingButton())
                
            }
        }
        .onAppear(){
            shuffleTiles()
        }
            
    }
    func countInversions(_ arr: [Int]) -> Int {
        var count = 0
        for i in 0..<arr.count {
            for j in i+1..<arr.count {
                if arr[i] > arr[j] {
                    count += 1
                }
            }
        }
        return count
    }

    func shuffleTiles() {
        var shuffledTiles = tiles.shuffled()
            while countInversions(shuffledTiles) % 2 != 0 {
                shuffledTiles = tiles.shuffled()
            }
            tiles = shuffledTiles
    }
    

    func swapTiles(_ number: Int) {
        guard let index = tiles.firstIndex(of: number) else { return }
        if index % 3 != 2 && tiles[index + 1] == 0 {
            tiles.swapAt(index, index + 1)
            PlayerMoves += 1
        } else if index % 3 != 0 && tiles[index - 1] == 0 {
            tiles.swapAt(index, index - 1)
            PlayerMoves += 1
        } else if index / 3 != 2 && tiles[index + 3] == 0 {
            tiles.swapAt(index, index + 3)
            PlayerMoves += 1
        } else if index / 3 != 0 && tiles[index - 3] == 0 {
            tiles.swapAt(index, index - 3)
            PlayerMoves += 1
        }
        if tiles == [1,2,3,4,5,6,7,8,0] {
            tiles[8] = 9
            Playable = false
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        PuzzleView()
    }
}

struct GrowingButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(.teal)
            .foregroundStyle(.white)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}


//github.com/PeterMyrobot/Slide-Puzzle-Game-on-Swift.
//github.com/gsurma/sliding_puzzle.
//stackoverflow.com/questions/64027529/swiftui-drag-and-drop-puzzle-game.
//medium.com/a-developer-in-making/puzzle-game-using-ui-drag-drop-apis-in-swift-4bd9d29f6c20.
//www.cs.bham.ac.uk/~mdr/teaching/modules04/java2/TilesSolvability.html.
