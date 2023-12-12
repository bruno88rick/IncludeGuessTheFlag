//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Bruno Oliveira on 27/11/23.
//

import SwiftUI

struct FlagImage: View {
    var image: String

    var body: some View {
        Image(image)
            .clipShape(.capsule)
            .shadow(radius: 5)
    }
}

extension View {
    func hiddenConditionally(isHidden: Bool) -> some View {
        isHidden ? AnyView(self.hidden()) : AnyView(self)
    }
}

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var question = 0
    @State private var totalCorrect = 0
    @State private var totalWrong = 0
    
    @State private var activeBlur = true
    @State private var startButtonHide = false
    
    var body: some View {
        
        ZStack{
            ZStack {
                RadialGradient(stops: [
                    .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                    .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
                ], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    Text("Include Guess The Flag")
                        .font(.title .bold())
                        .foregroundStyle(.white)
                    Spacer()
                    VStack(spacing: 15) {
                        VStack (spacing: 10){
                            Text("Tap the flag of")
                                .font(.subheadline.weight(.heavy))
                                .foregroundStyle(.secondary)
                            Text(countries[correctAnswer])
                                .font(.largeTitle.weight(.semibold))
                        }
                        
                        ForEach(0..<3){ number in
                            Button {
                                flagTapped(number)
                            } label: {
                                FlagImage(image: "\(countries[number])")
                            } .alert(scoreTitle, isPresented: $showingScore){
                                if question < 8 {
                                    Button("Continue..."){
                                        if question < 8 {
                                            askQuestion()
                                        } else if question == 8 {
                                            activeBlur = true
                                            startButtonHide = false
                                        }
                                    }
                                } else if question == 8 {
                                    Button("End Game"){
                                        activeBlur = true
                                        startButtonHide = false
                                    }
                                }
                                //other way do set an action to a Button
                                /*
                                 Button("Continue...", action: askQuestion)
                                 */
                            } message: {
                                if question < 8 {
                                    Text("Your score is \(totalCorrect)")
                                } else if question == 8 {
                                    Text("End game! 🎮 Your score was \(totalCorrect) and wrong answer was \(totalWrong) ")
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(.regularMaterial)
                    .clipShape(.rect(cornerRadius: 20))
                    
                    Spacer()
                    Spacer()
                    
                    Text("Your Score is: \(totalCorrect) of 8")
                        .foregroundStyle(.white)
                        .font(.title2.bold())
                    
                    Spacer()
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .blur(radius: activeBlur ? 10 : 0)
                
                Button("Start New Game", action: startGame)
                    .frame(width: 250, height: 100, alignment: .center)
                    .background(Color(red: 0.1, green: 0.2, blue: 0.45))
                    .foregroundStyle(.regularMaterial)
                    .font(.title2.bold())
                    .clipShape(.capsule)
                    .shadow(radius: 10)
                    //.opacity(startButtonHide ? 0 : 1)
                    .hiddenConditionally(isHidden: startButtonHide)
                
            }
        }
    }
    
    func flagTapped (_ number: Int) {
        if (number == correctAnswer) {
            scoreTitle = "Correct!😃 Congrats!🎊"
            countScore(correct: true)
        } else {
            scoreTitle = "Wrong!😭 That's the flag of \(countries[number])"
            countScore(correct: false)
        }
        
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    func startGame() {
        activeBlur = false
        startButtonHide = true
        totalCorrect = 0
        totalWrong = 0
        question = 0
        askQuestion()
    }
    
    func countScore (correct answer: Bool) {
        if answer {
            totalCorrect += 1
        } else {
            totalWrong += 1
        }
        question += 1
    }
    
}

#Preview {
    ContentView()
}
