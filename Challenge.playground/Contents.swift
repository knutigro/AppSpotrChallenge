//: Playground - noun: a place where people can play


import UIKit

struct Challenge {
    let question: String
    let quiz: [String]
}

extension Array {
    
    func uniqueStrings() -> [String] {
        var uniqueStrings = [String]()
        var valueMapper = [String : Int]()
        
        for value in self {
            if let stringValue = value as? String {
                if let _ = valueMapper[stringValue] {
                    valueMapper[stringValue]!++
                } else {
                    valueMapper[stringValue] = 1
                }
            }
        }
        
        for stringValue in valueMapper.keys {
            if valueMapper[stringValue] == 1 {
                uniqueStrings.append(stringValue)
            }
        }
        
        return uniqueStrings
    }
}

func fetchChallenge(completion: (challenge: Challenge?, error: NSError?) -> Void) {
    var challenge: Challenge?

    let url = NSURL(string: "http://api2.appspotr.com/givemeachallenge")
    let request = NSURLRequest(URL: url!)
    var response: AutoreleasingUnsafeMutablePointer<NSURLResponse?> = nil
    var error: NSError?
    
    if let data = NSURLConnection.sendSynchronousRequest(request, returningResponse: response, error:&error) {
        if error == nil {
            if let parsedObject: AnyObject? = NSJSONSerialization.JSONObjectWithData(data,
                options: NSJSONReadingOptions.AllowFragments,
                error:&error) as? NSDictionary {
                    if let challengeJSON = parsedObject as? NSDictionary, let question = challengeJSON["question"] as? String, let quiz = challengeJSON["quiz"] as? [String]  {
                        challenge = Challenge(question: question, quiz: quiz)
                    }
            }
        }
    }
    
    completion(challenge: challenge, error: error)
}

fetchChallenge( {
    (challenge, error) in
    
    if let challenge = challenge {
        let question = challenge.question
        let quiz = challenge.quiz
        if let uniqueString = quiz.uniqueStrings().first {
            println("Answer is: " + uniqueString)
        }
    } else {
        println("Error: \(error)")
    }
})






