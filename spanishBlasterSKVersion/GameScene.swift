//
//  GameScene.swift
//  spanishBlasterSKVersion
//
//  Created by Jake Derouin on 12/16/18.
//  Copyright © 2018 com.JakeDerouin. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var screenSize: CGRect?
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    var word = SKLabelNode(text: "")
    var timePerQuestion = 10.00
    var ship: SKSpriteNode?
    var choiceLabels: [SKLabelNode]?
    let Haptic = UIImpactFeedbackGenerator()
    var streak = 0
    var streakLabel: SKLabelNode?
    var isAnimating = false
    var bienCounter = 0
    var bienLabel: SKLabelNode?
    override func didMove(to view: SKView) {
    bienLabel = self.childNode(withName: "//goodjob") as? SKLabelNode
        bienLabel?.isHidden = true
        streakLabel = self.childNode(withName: "//streak") as? SKLabelNode
        
        screenSize = view.bounds
        choiceLabels = [self.childNode(withName: "//choice1") as? SKLabelNode,self.childNode(withName: "//choice2") as? SKLabelNode,self.childNode(withName: "//choice3") as? SKLabelNode,self.childNode(withName: "//choice4") as? SKLabelNode] as? [SKLabelNode]
 
        ship = SKSpriteNode(imageNamed: "ship")
        ship?.setScale(0.75)
        ship?.position = CGPoint(x: (ship?.position.x)!, y: (ship?.position.y)! - 150)
        
        self.addChild(ship!)
           newWord()
        // Get label node from scene and store it for use later
  
        }
        
        // Create shape node to use during mouse interaction
    
        
    
    
    func addWord(){
       // word = self.childNode(withName: "//evilWord") as? SKLabelNode
    
        word = SKLabelNode(text: selectedWord!)
 
        word.fontSize = 40
      
       
        word.isHidden = false
        
        
        
        word.position = CGPoint(x: Int.random(in: Int(screenSize!.midX)...Int(screenSize!.maxX)-150), y: Int((screenSize?.maxY)!)-Int((word.fontSize)))
        
        var negOrPos = 0
        
           negOrPos = Int.random(in: 1...100)
        if negOrPos >= 50 {
            word.position = CGPoint(x: -word.position.x, y: word.position.y)
            
        }
        print("pos")
        self.addChild(word)
   
        word.run(SKAction.moveTo(y: (screenSize?.minY)!, duration: timePerQuestion), completion: {
            if self.word.isHidden == false{
                
            
            self.streak = 0
                self.streakLabel?.text = "Streak: 0"
            }
        })
      
        
    }
    
    func correctAnimation(){
        bienCounter+=1
        
        isAnimating = true
        if bienCounter == 5 {
        bienLabel?.isHidden = false
        
            let bienLabelOGposition = bienLabel?.position
        
        bienLabel?.run(SKAction.move(to: CGPoint(x: (screenSize?.maxX)!, y: (bienLabel?.position.y)!), duration: 3), completion: {
            self.bienLabel?.position = bienLabelOGposition!
            self.bienLabel?.isHidden = true
            self.bienCounter = 0
            
        })}
        for choice in choiceLabels!{
            
            if choice.text != correctAnswer{
                choice.isHidden = true
            }
        }
        streak+=1
        streakLabel?.text = "Streak: \(streak)"
        ship?.run(SKAction.moveTo(x: (word.position.x), duration: 1), completion: {
            self.fire()
        })
        
        
    }
    func fire(){
        var bullet = SKSpriteNode(imageNamed: "Bullet")
        self.addChild(bullet)
        Haptic.impactOccurred()
        bullet.position = CGPoint(x: (ship?.position.x)!, y: (ship?.position.y)! + ship!.size.height/2)
        bullet.run(SKAction.move(to: (word.position), duration: 0.3), completion: {
            
            self.word.isHidden = true
            self.word.removeFromParent()
            bullet.isHidden = true
            bullet.removeFromParent()
            self.timePerQuestion -= 0.20
            self.isAnimating = false
self.newWord()

            
        })
        
    }
    
    func incorrectAnimation(){
         isAnimating = true
        for choice in choiceLabels!{
            
            if choice.text != correctAnswer{
                choice.isHidden = true
            }
        }
        streak = 0
            streakLabel?.text = "Streak: \(streak)"
        timePerQuestion = 10.0
        ship?.run(SKAction.rotate(byAngle: CGFloat(Double.pi*6) , duration: 2), completion: {
            self.word.isHidden = true
            self.word.removeFromParent()
            self.isAnimating = false
       self.newWord()
            
        })
    }
    
    
    func checkAnswer(selectedIndex: Int){
        if choiceLabels![selectedIndex].text == correctAnswer! {
            print("correct")
            correct()
        }else{
            incorrectAnimation()
            
            
        }
        
        
    }
    func touchDown(atPoint pos : CGPoint) {
     print(pos)
        var labelIndex = 0
        for label in choiceLabels!{
            if label.position.x + 100 >= pos.x && label.position.x - 100 <= pos.x && label.position.y + 60 >= pos.y && label.position.y - 60 <= pos.y{
                print("yooooo")
                if isAnimating == false{
                checkAnswer(selectedIndex: labelIndex)
                }
            }else{
                labelIndex+=1
                
                
                
            }
            
            
            
            
print("labelpos \(label.position)")
            
            
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {//Users touch location
        
        for label in choiceLabels!{
            if label.position.x + CGFloat(30) <= pos.x && label.position.x - CGFloat(30) >= pos.x && label.position.y + CGFloat(10) <= pos.y && label.position.y - CGFloat(10) >= pos.y {
                
                print("hi")
                
                
                
                
                
                
                
                
                
            }
            
            
        }
        
        
        
        
        
        
        
        
        
        
        
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      
      
        
        
        
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
      
        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
  
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    let spanishWords = ["los bloques","la colección","la cuerda","saltar a la cuerda","el dinosaurio","la muñeca","el muñeco","el oso de peluche ","el tren eléctrico","el triciclo    ","el pez","la tortuga","coleccionar","molestar","pelearse","la guardería infantil","el patio de recreo","de niño","de pequeño","de vez en cuando","mentir","obedecer","ofrecer","permitir","por lo general","portarse bien","portarse mal","todo el mundo","el vecino","los vecinos","la verdad    ","bien educado","consentido","desobediente","generoso    ","obediente","tímido","travieso","la moneda","el mundo","era","eras    ","éramos","ellos eran","iba","ibas","íbamos","Uds. iban","veía ","veías","veíamos","ellas veían"] //Words in spanish
 
    let englishWwords = ["blocks","collection","rope","to jump rope","dinosaur","doll","action figure","teddy bear","electric train","tricycle","fish","turtle","to collect","to bother","to fight","daycare center","playground","as a child","as a small child","from time to time","to lie","to obey","to offer","to allow","in general","to behave well","to behave bad","everyone","neighbor","neighbors","the truth","well behaved","spoiled","disobediant","generous","obediant","shy","naughty","coin","the world","was","you were","we were","they were","went","you went","we went","you all went","saw","you saw","we saw","they saw"] //English words
   
    
    
    var selectedWord: String?
    var correctAnswer: String?
    var options: [String]?
    var lives = 3
    var score = 0
 

  

    
    func correct(){
    correctAnimation()
        
    }
    
    
    func incorrect(){
   incorrectAnimation()
    }
    
    
    
    func newWord(){
        let indexForSelection = getRandomIndex()
        selectedWord = spanishWords[indexForSelection]
        correctAnswer = englishWwords[indexForSelection]
      
  addWord()
        
        options = [correctAnswer!, englishWwords[getRandomIndex()], englishWwords[getRandomIndex()], englishWwords[getRandomIndex()]]
        options?.shuffle()
        var optionsIndex = 0
        for label in choiceLabels!{
            label.isHidden = false
            label.text = options![optionsIndex]
            optionsIndex += 1
        }
        
    }
    func getRandomIndex() -> Int {
        var randomIndex = Int.random(in: 0...spanishWords.count-1)
        
        while englishWwords[randomIndex] == correctAnswer{
            randomIndex = Int.random(in: 0...spanishWords.count-1)
        }
        
        return randomIndex
    }}

