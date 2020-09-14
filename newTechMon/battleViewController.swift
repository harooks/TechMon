//
//  battleViewController.swift
//  newTechMon
//
//  Created by Haruko Okada on 9/14/20.
//  Copyright © 2020 Haruko Okada. All rights reserved.
//

import UIKit

class battleViewController: UIViewController {
    
    //player stuff
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var playerImageView: UIImageView!
    @IBOutlet weak var playerHPLabel: UILabel!
    @IBOutlet weak var playerMPLabel: UILabel!
    @IBOutlet weak var playerTPLabel: UILabel!
    
    //enemy stuff
    @IBOutlet weak var enemyNameLabel: UILabel!
    @IBOutlet weak var enemyImageView: UIImageView!
    @IBOutlet weak var enemyHPLabel: UILabel!
    @IBOutlet weak var enemyMPLabel: UILabel!
    
    let techMonManager = TechMonManager.shared
    
    //var playerHP = 100
    //var playerMP = 0
    //var enemyHP = 200
    //var enemyMP = 0
    
    var gameTimer: Timer!
    
    var player: Character!
    var enemy: Character!
    var isPlayerAttackAvailable: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        player = techMonManager.player
        enemy = techMonManager.enemy
        
        playerNameLabel.text = "勇者"
        playerImageView.image = UIImage(named: "yusya.png")
       // playerHPLabel.text = "\(playerHP) / 100"
        //playerMPLabel.text = "\(playerMP) / 20"
        
        enemyNameLabel.text = "龍"
        enemyImageView.image = UIImage(named: "monster.png")
        //enemyHPLabel.text = "\(enemyHP) / 200"
        //enemyMPLabel.text = "\(enemyMP) / 35"
        updateUI()
        
        gameTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateGame), userInfo: nil, repeats: true)
        gameTimer.fire()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        techMonManager.playBGM(fileName: "BGM_battle001")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        techMonManager.stopBGM()
    }
    
    @objc func updateGame(){
//        playerMP += 1
//        if playerMP >= 20{
//            isPlayerAttackAvailable = true
//            playerMP = 20
//        } else {
//            isPlayerAttackAvailable = false
//        }
//
//        enemyMP += 1
//
//        if enemyMP >= 35 {
//            enemyAttack()
//            enemyMP = 0
//        }
        
        player.currentMP += 1
        if player.currentMP >= 20{
            isPlayerAttackAvailable = true
            player.currentMP = 20
        } else {
            isPlayerAttackAvailable = false
        }
        
        enemy.currentMP += 1
        if enemy.currentMP >= 35{
            enemyAttack()
            enemy.currentMP = 0
        }
        
        //playerMPLabel.text = "\(playerMP) / 20"
        //enemyMPLabel.text = "\(enemyMP) / 35"
        updateUI()
    }
    
    func enemyAttack(){
        techMonManager.damageAnimation(imageView: playerImageView)
        techMonManager.playSE(fileName: "SE_attack")
        
        //playerHP -= 20
        player.currentHP -= 20

//        playerHPLabel.text = "\(playerHP) / 100"
//        //updateUI()
//
//        if playerHP <= 0{
//            finishBattle(vanishImageView: playerImageView, isPlayerWin: false)
//        }
        judgeBattle()
        updateUI()
    }
    
    func finishBattle(vanishImageView: UIImageView, isPlayerWin: Bool) {
        techMonManager.vanishAnimation(imageView: vanishImageView)
        techMonManager.stopBGM()
        gameTimer.invalidate()
        isPlayerAttackAvailable = false
        
        var finishMessage: String = ""
        if isPlayerWin {
            techMonManager.playSE(fileName: "SE_fanfare")
            finishMessage = "勇者の勝利！"
        } else {
            techMonManager.playSE(fileName: "SE_gameover")
            finishMessage = "勇者の敗北..."
        }
        
        let alert = UIAlertController(title: "OK", message: finishMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in
            self.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func attack(_ sender: Any) {
        if isPlayerAttackAvailable{
            techMonManager.damageAnimation(imageView: enemyImageView)
            techMonManager.playSE(fileName: "SE_attack")
            
            enemy.currentHP -= player.attackPoint
            
            player.currentTP += 10
           if player.currentTP >= player.maxTP{
                player.currentTP = player.maxTP
            }
//
//            enemyHP -= 30
//            playerMP = 0
//
//            enemyHPLabel.text = "\(enemyHP) / 200"
//            playerMPLabel.text = "\(playerMP) / 20"
//            //updateUI()
//
//            if enemyHP <= 0 {
//                finishBattle(vanishImageView: enemyImageView, isPlayerWin: true)
//            }
//        }
            
           // enemy.currentHP -= 30
            player.currentMP = 0
            updateUI()
            judgeBattle()
        }
    }
    
    @IBAction func fire(_ sender: Any) {
        if isPlayerAttackAvailable && player.currentTP >= 40{
            techMonManager.damageAnimation(imageView: enemyImageView)
            techMonManager.playSE(fileName:"SE_fire")
            
            enemy.currentHP -= 100
            player.currentTP -= 40
            if player.currentTP <= 0{
                player.currentTP = 0
            }
            player.currentMP = 0
            judgeBattle()
        }
    }
    
    
    @IBAction func store(_ sender: Any) {
        if isPlayerAttackAvailable{
            techMonManager.playSE(fileName: "SE_charge")
            player.currentTP += 40
            if player.currentTP >= player.maxTP{
                player.currentTP = player.maxTP
            }
            player.currentMP = 0
        }
    }
    
    
    func updateUI(){
        playerHPLabel.text = "\(player.currentHP) / \(player.maxHP)"
        playerMPLabel.text = "\(player.currentMP) / \(player.maxMP)"
        
        enemyHPLabel.text = "\(enemy.currentHP) / \(enemy.maxHP)"
        enemyMPLabel.text = "\(enemy.currentMP) / \(enemy.maxMP)"
     }
    
    func judgeBattle(){
        if player.currentHP <= 0{
            finishBattle(vanishImageView: playerImageView, isPlayerWin: false)
        }
    
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
