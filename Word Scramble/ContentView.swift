//
//  ContentView.swift
//  Word Scramble
//
//  Created by Santhosh Srinivas on 11/06/25.
//

import SwiftUI

struct ContentView: View {
    
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    @State private var errorTitle = ""
    @State private var errorMsg = ""
    @State private var showError = false
    @State private var totalScore = 0
    var body: some View {
        NavigationStack{
            VStack {
                List(){
                    Section(){
                        TextField("Enter your word", text: $newWord)
                            .textInputAutocapitalization(.never)
                    }
                    Section{
                        ForEach(usedWords, id: \.self){ word in
                            HStack{
                                Text(word)
                                Spacer()
                                Image(systemName: "\(word.count).circle")
                            }
                            
                        }
                    }
                }
                Text("Score: \(totalScore)")
                    .font(.largeTitle)
    //            List() {
    //                Section("Section 2"){
    //                    Text("Static Row 1")
    //                    Text("Static Row 2")
    //                    Text("Static Row 3")
    //                    Text("Static Row 4")
    //                }
    //                Section("Section 1"){
    //                    ForEach(0..<5){
    //                        Text("Dynamic Row \($0+1)")
    //                    }
    //                }
    //            }
    //            .listStyle(.grouped)
    //            List(b99, id: \.self){
    //                Text($0)
    //            }
                
            }
            .navigationTitle(rootWord)
            .onSubmit(addNewWord)
            .onAppear(perform: pickWord)
            .alert(errorTitle,isPresented: $showError){
//                Button("Ok") { }
                // if no button, alert gives an automatic ok button
            } message: {
                Text(errorMsg)
            }
            .toolbar{
                Button("Restart Game") {
                    restartGame()
                }
            }
        }
        
    }
    func addNewWord() {
        let rawWord = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard rawWord.count > 0 else { return }
        
        guard isOriginal(word: rawWord) else{
            wordError(title: "Duplicate Word", msg: "Word is already present in the list")
            return
        }
        
        guard isReal(word: rawWord) else {
            wordError(title: "Fake Word", msg: "Word entered is not a real word")
            return
        }
        
        guard possibleWord(word: rawWord) else {
            wordError(title: "Impossible Word", msg: "Word is not possible from \(rootWord)")
            return
        }
        
        guard shortWord(word: rawWord) else {
            wordError(title: "Small Word", msg: "Come on, youre not a baby")
            return
        }
        
        guard sameRootWord(word: rawWord) else {
            wordError(title: "Same Word", msg: "Dont enter the same given word")
            return
        }
        
        withAnimation{
            usedWords.insert(rawWord, at: 0)
        }
        
        calculateScore(word: rawWord)
        newWord = ""
        
    }
    func pickWord() {
        // if there is some major issue w the file, we can throw a fatalError which crashes the app totally
        if let fileURL = Bundle.main.url(forResource: "start", withExtension: "txt"){
            if let fileContents = try? String(contentsOf: fileURL){
                let allWords = fileContents.components(separatedBy: "\n")
                rootWord = allWords.randomElement() ?? "silkWorm"
                
                return
            }
        }
        fatalError("Cant Load start.txt from bundle")
    }
    
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }
    
    func possibleWord(word: String) -> Bool{
        var rootWordCopy = rootWord
        
        for letter in word{
            if let pos = rootWordCopy.firstIndex(of: letter){
                rootWordCopy.remove(at: pos)
            } else {
                return false
            }
        }
        return true
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledWord = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledWord.location == NSNotFound
        
    }
    
    func wordError(title: String, msg: String){
        errorTitle = title
        errorMsg = msg
        showError = true
    }
    
    func shortWord(word: String) -> Bool{
        word.count >= 3
    }
    func sameRootWord(word: String) -> Bool{
        word != rootWord
    }
    
    func restartGame() {
        usedWords = [String]()
        rootWord = ""
        newWord = ""
        totalScore = 0
        pickWord()
    }
    
    func calculateScore(word: String){
        if word.count <= 4 {
            totalScore += word.count
        } else {
            totalScore += word.count + 1
        }
        
        if usedWords.count == 5 {
            totalScore += 1
        } else if usedWords.count == 10 {
            totalScore += 2
        }
    }
//    func testBundles() {
//
//        // This bundle can have a file or cannot have a file. so optional. resoure is the name of the file and extension is the extension
//        if let fileURL = Bundle.main.url(forResource: "someFile", withExtension: "txt"){
////            fileURL gets the link to the file. and string contentsOf converts it to a string
//            if let fileContents = try? String(contentsOf: fileURL){
//                // If it has the cotnents it can execute it. if it doesnt it throws an error
//            }
//        }
//    }
//    func testString() {
//        let input = "a b c"
//        let mlInput = """
//        a
//        b
//        c
//        """
//        let array = input.components(separatedBy: " ")
//        let array2 = mlInput.components(separatedBy: "\n")
//        let letter = array.randomElement()
//        // randomElement returns an optional string as the array might be empty so we need to unwrap it using nil coelescing so we use ?.
//        let trimmed = letter?.trimmingCharacters(in: .whitespacesAndNewlines)
//
//        let word = "swift"
//        let checker = UITextChecker()
//        // SWIFT allows using complex chars like emojis in a string. so we need to convert the swift string to an Objcetive C string to check it using below:
//        let range = NSRange(location: 0, length: word.utf16.count)
//        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
//        // this returns if a misspelled word is found as a range
//        let allGood = misspelledRange.location == NSNotFound
//        // this NSNotFound is sent if there is no spelling mistake
//    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
