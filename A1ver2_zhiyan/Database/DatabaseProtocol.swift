//
//  DatabaseProtocol.swift
//  A1ver2_zhiyan
//
//  Created by steven liu on 31/8/19.
//  Copyright © 2019 steven liu. All rights reserved.
//

import Foundation
import UIKit

enum DatabaseChange {
    case add
    case remove
    case update
}
enum ListenerType {
    case sight
    
}
protocol DatabaseListener: AnyObject {
    var listenerType: ListenerType {get set}
    //func onTeamChange(change: DatabaseChange, teamHeroes: [SuperHero])
    func onSightListChange(change: DatabaseChange, sightsDB: [SightEntity])
}
protocol DatabaseProtocol: AnyObject {
  //  var defaultList: SightEntity {get}
    
    func addSight(name: String, desc: String, image:UIImage,lat: String,lon: String, icon : String) -> SightEntity
    //func addTeam(teamName: String) -> Team
   // func addHeroToTeam(hero: SuperHero, team: Team) -> Bool
    func deleteSight(sight: SightEntity)
    //func deleteTeam(team: Team)
   // func removeHeroFromTeam(hero: SuperHero, team: Team)
    func addListener(listener: DatabaseListener)
    func removeListener(listener: DatabaseListener)
}
