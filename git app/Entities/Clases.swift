//
//  CRepositorio.swift
//  git app
//
//  Created by Henry Silva Olivo on 1/15/20.
//  Copyright © 2020 hsilva. All rights reserved.
//

import Foundation

class UsersRepo: NSObject{
    
    var username: String = ""
    var href : String = ""
    var avatar : String = ""
    
    static func createfrom(dictionary : NSDictionary) -> UsersRepo {
        
        let userbultl = UsersRepo()
        
        if let usernam = dictionary.object(forKey: "username") as? String{
            userbultl.username = usernam
        }
        if let hrefstr = dictionary.object(forKey: "href") as? String{
            userbultl.href = hrefstr
        }
        if let avatar = dictionary.object(forKey: "avatar") as? String{
            userbultl.avatar = avatar
        }
        
        return userbultl
    }
    
    static func createArrayFrom(dictionarys: [NSDictionary]) -> [UsersRepo]{
        var arrayuser = [UsersRepo]()
        for userr in dictionarys{
            var userrepo = UsersRepo.createfrom(dictionary: userr)
            arrayuser.append(userrepo)
        }
        return arrayuser
    }
}


class CRepositorio: NSObject {
    
    var author : String = ""
    var name: String = ""
    var avatar: String = ""
    var url: String = ""
    var descripcion: String = ""
    var language: String = ""
    var languageColor: String = ""
    var stars: Int = 0
    var forks: Int = 0
    var currentPeriodStars : Int = 0
    
    var buildby = [UsersRepo]()
    
    static func createfrom(dictionary : NSDictionary) -> CRepositorio {
        
        let objrepo = CRepositorio()
        if let autor = dictionary.object(forKey: "author") as? String{
            objrepo.author = autor
        }
        if let name = dictionary.object(forKey: "name") as? String{
            objrepo.name = name
        }
        if let avatar = dictionary.object(forKey: "avatar") as? String{
            objrepo.avatar = avatar
        }
        if let url = dictionary.object(forKey: "url") as? String{
            objrepo.url = url
        }
        if let deascrip = dictionary.object(forKey: "description") as? String{
            objrepo.descripcion = deascrip
        }
        if let lang = dictionary.object(forKey: "language") as? String{
            objrepo.language = lang
        }
        if let langcolor = dictionary.object(forKey: "languageColor") as? String{
            objrepo.languageColor = langcolor
        }
        if let stars = dictionary.object(forKey: "stars") as? Int{
            objrepo.stars = stars
        }
        if let forks = dictionary.object(forKey: "forks") as? Int{
            objrepo.forks = forks
        }
        if let currentPeriodStar = dictionary.object(forKey: "currentPeriodStars") as? Int{
            objrepo.currentPeriodStars = currentPeriodStar
        }
        
        if let arrayuserbuild = dictionary.object(forKey: "builtBy") as? [NSDictionary]{
            objrepo.buildby = UsersRepo.createArrayFrom(dictionarys: arrayuserbuild)
        }
        return objrepo
    }
    
    static func createArrayFrom(dictionarys: [NSDictionary]) -> [CRepositorio]{
        var arrayrepo = [CRepositorio]()
        for repodis in dictionarys{
            var repo = CRepositorio.createfrom(dictionary: repodis)
            arrayrepo.append(repo)
        }
        return arrayrepo
    }
}
