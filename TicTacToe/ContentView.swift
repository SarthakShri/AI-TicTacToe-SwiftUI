//
//  ContentView.swift
//  TicTacToe
//
//  Created by Sarthak Shrivastava on 08/04/23.
//

import SwiftUI

struct ContentView: View {
    
    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible()),]
    
    @State private var moves: [Move?] = Array(repeating: nil, count: 9)
    //@State private var isHumanTurn = true //used only for testing
    @State private var isGameBoardDisabled = false
    
    var body: some View {
        GeometryReader{ geometry in
            VStack{
                Spacer()
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(0..<9){ i in
                        ZStack{ //Used to place the zero and cricle on top of the tiles
                            RoundedRectangle(cornerRadius: 25, style: .continuous)
                                .foregroundColor(.red)
                                .frame(width: geometry.size.width/3-15, height: geometry.size.width/3-15)
                            
                            Image(systemName: moves[i]?.indicator ?? "")
                                .resizable()
                                .frame(width: 90, height: 90)
                        }
                        .onTapGesture {
                            if isSquareOccupied(in: moves, forIndex: i){return}
                            moves[i] = Move(player: .human, boardIndex: i)
                            //isHumanTurn.toggle() //was only used for testing
                            isGameBoardDisabled = true
                            
                            //check for win
                            if checkWinConditions(for: .human, in: moves){
                                print("Human Wins!")
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                                let computerPos = computerPosition(in: moves)
                                moves[computerPos] = Move(player: .computer, boardIndex: computerPos)
                                isGameBoardDisabled = false
                                
                                //check for win
                                if checkWinConditions(for: .computer, in: moves){
                                    print("Computer Wins!")
                                }
                            }
                            
                        }
                        
                    }
                    
                }
                Spacer()
            }
            .disabled(isGameBoardDisabled)
            .padding()
        }
        
    }
    
    func isSquareOccupied(in moves: [Move?], forIndex index: Int)->Bool{
        return moves.contains(where: {$0?.boardIndex == index})  //For all the MOVES that are not nil in the array->$0?
    }
    
    func computerPosition(in moves: [Move?])->Int{
        var position = Int.random(in: 0..<9)
        while isSquareOccupied(in: moves, forIndex: position) {
            position = Int.random(in: 0..<9)
        }
        return position
    }
    
    func checkWinConditions(for player: Player, in move: [Move?])->Bool{
        let winPattern: Set<Set<Int>> = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]
        
        let playermoves = moves.compactMap{ $0 }.filter{ $0.player == player}
        let playerpos = Set(playermoves.map{ $0.boardIndex })
        
        for pattern in winPattern where pattern.isSubset(of: playerpos) {return true}
        return false
    }
}


enum Player{
    case human, computer
}

struct Move{
    let player: Player
    let boardIndex: Int
    
    var indicator: String{
        return player == .human ? "xmark" : "circle"
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
