//
//  ServerCommands.swift
//  YHackApp
//
//  Created by Jack Boyce on 12/2/17.
//  Copyright © 2017 Jack Boyce. All rights reserved.
//

import Foundation
import Alamofire
//import Alamofire_Synchronous

let url = "http://35.188.243.12:8080"
var fbid = "kgskdhkjshdk"
//let fire = Alamofire

func getUserFacebookID(_ facebookID: String) -> String? {
    let response = Alamofire.request("\(url)/get_user_fb_id", method: .post, parameters: ["facebook_id": facebookID]).responseString()
    return response.result.value
}

func getFriendsByUserFacebookID(_ facebookID: String) -> String? {
    let response = Alamofire.request("\(url)/get_friends_by_user_fbid", method: .post, parameters: ["facebook_id": facebookID]).responseString()
    return response.result.value
}

func getConvoFromKeywords(_ facebookID: String, _ keywords: String) -> String? {
    let response = Alamofire.request("\(url)/get_convo_from_keywords", method: .post, parameters: ["facebook_id": facebookID, "keywords": keywords]).responseString()
    return response.result.value
}

func addUser(_ facebookID: String, _ email: String, _ fName: String, _ lName: String) -> String? {
    let response = Alamofire.request("\(url)/add_user", method: .post, parameters: ["facebook_id": facebookID, "email": email, "f_name": fName, "l_name": lName]).responseString()
    return response.result.value
}

func addFriend(_ facebookID: String, _ friendName: String) -> String? {
    let response = Alamofire.request("\(url)/add_friend", method: .post, parameters: ["facebook_id": facebookID, "friend_name": friendName]).responseString()
    return response.result.value
}

func addConvo(_ facebookID: String, _ friend_name: String, _ convo_data: String) -> String? {
    let response = Alamofire.request("\(url)/add_convo", method: .post, parameters: ["facebook_id": facebookID, "friend_name": friend_name, "convo_data": convo_data]).responseString()
    return response.result.value
}


func convertToDictionary(text: String) -> [String: Any]? {
    if let data = text.data(using: .utf8) {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch {
            print(error.localizedDescription)
        }
    }
    return nil
}

func test() -> String? {
    let response = Alamofire.request("\(url)/").responseString()
    return response.result.value
}

func stringToDict(string: String) -> [[String : String]] {
    var final = [[String: String]]()
    
    
    var manip = string
    var openingBracket = manip.index(of: "[")
    var closingBracket = manip.index(of: "]")
    
    manip = manip.substring(to: closingBracket!)
    manip = manip.substring(from: openingBracket!)
    
    manip = manip.substring(from: 1)
    
    //print(manip)
    
    /////////////////ENDINGS HAVE BEEN CLEARED/////////////////
    
    var fullDataSets = manip.components(separatedBy: "}, ")
    var dataSetTrimmed = [String]()
    for i in fullDataSets {
        dataSetTrimmed.append(i.substring(from: 1))
    }
    
    var arrayStringArray = [[String]]()
    
    for i in dataSetTrimmed {
        arrayStringArray.append(i.components(separatedBy: ", "))
    }
    
    for i in arrayStringArray {
        for j in i {
            var splitary = j.components(separatedBy: ": ")
            splitary[0] = splitary[0].replacingOccurrences(of: "\"", with: "")
            splitary[1] = splitary[1].replacingOccurrences(of: "\"", with: "")
            splitary[0] = splitary[0].replacingOccurrences(of: "}", with: "")
            splitary[1] = splitary[1].replacingOccurrences(of: "}", with: "")
            splitary[0] = splitary[0].trimmingCharacters(in: .whitespacesAndNewlines)
            splitary[1] = splitary[1].trimmingCharacters(in: .whitespacesAndNewlines)
            
            final.append([splitary[0]:splitary[1]])
        }
    }
    
    //print(final)
    return final
}

extension String {
    func index(of string: String, options: CompareOptions = .literal) -> Index? {
        return range(of: string, options: options)?.lowerBound
    }
    func endIndex(of string: String, options: CompareOptions = .literal) -> Index? {
        return range(of: string, options: options)?.upperBound
    }
    func indexes(of string: String, options: CompareOptions = .literal) -> [Index] {
        var result: [Index] = []
        var start = startIndex
        while let range = range(of: string, options: options, range: start..<endIndex) {
            result.append(range.lowerBound)
            start = range.upperBound
        }
        return result
    }
    func ranges(of string: String, options: CompareOptions = .literal) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var start = startIndex
        while let range = range(of: string, options: options, range: start..<endIndex) {
            result.append(range)
            start = range.upperBound
        }
        return result
    }
}
extension String {
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return substring(from: fromIndex)
    }
    
    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return substring(to: toIndex)
    }
    
    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return substring(with: startIndex..<endIndex)
    }
}
