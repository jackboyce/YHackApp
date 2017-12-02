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

func test() -> String? {
    let response = Alamofire.request("\(url)/").responseString()
    return response.result.value
}
