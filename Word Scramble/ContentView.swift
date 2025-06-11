//
//  ContentView.swift
//  Word Scramble
//
//  Created by Santhosh Srinivas on 11/06/25.
//

import SwiftUI

struct ContentView: View {
    
    let b99 = ["Jake", "Amy", "Charles", "Terry"]
    var body: some View {
        VStack {
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
            List(b99, id: \.self){
                Text($0)
            }
            
        }
    }
    func testBundles() {
        
        // This bundle can have a file or cannot have a file. so optional. resoure is the name of the file and extension is the extension
        if let fileURL = Bundle.main.url(forResource: "someFile", withExtension: "txt"){
//            fileURL gets the link to the file. and string contentsOf converts it to a string
            if let fileContents = try? String(contentsOf: fileURL){
                // If it has the cotnents it can execute it. if it doesnt it throws an error
            }
        }
    }
    func testString() {
        let input = "a b c"
        let mlInput = """
        a
        b
        c
        """
        let array = input.components(separatedBy: " ")
        let array2 = mlInput.components(separatedBy: "\n")
        let letter = array.randomElement()
        // randomElement returns an optional string as the array might be empty so we need to unwrap it using nil coelescing so we use ?.
        let trimmed = letter?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let word = "swift"
        let checker = UITextChecker()
        // SWIFT allows using complex chars like emojis in a string. so we need to convert the swift string to an Objcetive C string to check it using below:
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        // this returns if a misspelled word is found as a range
        let allGood = misspelledRange.location == NSNotFound
        // this NSNotFound is sent if there is no spelling mistake
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
