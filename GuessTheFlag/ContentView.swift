//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Bruno Oliveira on 27/11/23.
//

import SwiftUI

struct LargeText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title.bold())
            .foregroundStyle(.white)
    }
}

extension View {
    func hiddenConditionally(isHidden: Bool) -> some View {
        isHidden ? AnyView(self.hidden()) : AnyView(self)
    }
    
    func proeminentTitle() -> some View {
        modifier(LargeText())
    }
}

struct ContentView: View {
    
    static let allCountries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"]
    
    @State private var countries = allCountries.shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var showingResult = false
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var question = 0
    @State private var totalCorrect = 0
    @State private var totalWrong = 0
    
    @State private var activeBlur = true
    @State private var startButtonHide = false
    
    //track flag to apply effects
    @State private var selectedFlag = -1
    
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
                        .proeminentTitle()
                    Spacer()
                    VStack(spacing: 15) {
                        VStack (spacing: 10) {
                            Text("Tap the flag of")
                                .font(.subheadline.weight(.heavy))
                                .foregroundStyle(.secondary)
                            Text(countries[correctAnswer])
                                .font(.largeTitle.weight(.semibold))
                                .opacity(selectedFlag == -1 ? 1 : 0)
                                .animation(.easeOut(duration: 0.5), value: selectedFlag)
                        }
                        
                        ForEach(0..<3){ number in
                            Button {
                                flagTapped(number)
                            } label: {
                                FlagImage(image: countries[number])
                            }
                            //if selectedFlag was the number who was selected, apply a 360 rotarion on y axis
                            .rotation3DEffect(
                                .degrees(selectedFlag == number ? 360 : 0),
                                axis: (x: 0, y: 1, z: 0)
                            )
                            //apply effects on not selected flags (selectedFlag Track == -1) or if selectedeFlag was == to number
                            .opacity(selectedFlag == -1 || selectedFlag == number ? 1 : 0.25)
                            .scaleEffect(selectedFlag == -1 || selectedFlag == number ? 1 : 0.25)
                            .blur(radius: selectedFlag == -1 || selectedFlag == number ? 0 : 4)
                            .saturation(selectedFlag == -1 || selectedFlag == number ? 1 : 0)
                            .animation(.spring(
                                duration: 0.5,
                                bounce: 0.6),
                                value: selectedFlag
                            )
                            .alert(scoreTitle, isPresented: $showingScore){
                                Button("Continue..."){
                                    askQuestion()
                                }
                                //other way do set an action to a Button
                                /*
                                 Button("Continue...", action: askQuestion)
                                 */
                            } message: {
                                Text("Your score is \(totalCorrect)")
                            }
                            .alert ("\(scoreTitle), but the Game is over! 🎮", isPresented: $showingResult){
                                Button("Start a New Game"){
                                    startGame()
                                }
                                Button("End Game"){
                                    activeBlur = true
                                    startButtonHide = false
                                }
                            } message: {
                                Text("Your score was \(totalCorrect) and you asnwer \(totalWrong) flags wrong. Play again")
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
                .animation(.spring, value: activeBlur)
                
                Button("Start New Game", action: startGame)
                    .frame(width: 250, height: 100, alignment: .center)
                    .background(Color(red: 0.1, green: 0.2, blue: 0.45))
                    .foregroundStyle(.white)
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
            
            let needsThe = ["US", "UK"]
            let theirAnswer = countries[number]
            
            if needsThe.contains(theirAnswer) {
                scoreTitle = "Wrong!😭 That's the flag of the \(theirAnswer)"
            } else {
                scoreTitle = "Wrong!😭 That's the flag of \(theirAnswer)"
            }
                countScore(correct: false)
        }
        
        //store in variable what flag was tapped
        selectedFlag = number
        
        if question < 8 {
            showingScore = true
        } else if question == 8 {
            showingResult = true
        }
    }
    
    func askQuestion() {
        countries.remove(at: correctAnswer)
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        //return @state track flag image tapped back to -1
        selectedFlag = -1
    }
    
    func startGame() {
        activeBlur = false
        startButtonHide = true
        totalCorrect = 0
        totalWrong = 0
        question = 0
        countries = Self.allCountries
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
