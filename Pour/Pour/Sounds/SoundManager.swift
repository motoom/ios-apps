
import UIKit
import AVFoundation

class SoundManager {

    var playersInitialized = false
    var fillPlayer: AVAudioPlayer! // TODO: Map from soundname -> initialised AVAudioPlayer instances
    var pourPlayer: AVAudioPlayer!
    var drainPlayer: AVAudioPlayer!

    init() {
        // TODO: Initialize sounds in a loop.
        let fillUrl = NSBundle.mainBundle().URLForResource("Fillup.wav", withExtension: nil)
        do {
            try fillPlayer = AVAudioPlayer(contentsOfURL: fillUrl!)
            fillPlayer.prepareToPlay()
            }
        catch {
            print("Fillup.wav not playable")
            }
        //
        let pourUrl = NSBundle.mainBundle().URLForResource("Eau.wav", withExtension: nil)
        do {
            try pourPlayer = AVAudioPlayer(contentsOfURL: pourUrl!)
            pourPlayer.prepareToPlay()
            }
        catch {
            print("Eau.wav not playable")
            }
        //
        let drainUrl = NSBundle.mainBundle().URLForResource("Toilet.wav", withExtension: nil)
        do {
            try drainPlayer = AVAudioPlayer(contentsOfURL: drainUrl!)
            drainPlayer.prepareToPlay()
            }
        catch {
            print("Toilet.wav not playable")
            }
        }


    func sndFill() {
        fillPlayer.currentTime = 0
        fillPlayer.play()
        }

    func sndPour() {
        pourPlayer.currentTime = 0
        pourPlayer.play()
        }

    func sndDrain() {
        drainPlayer.currentTime = 0
        drainPlayer.play()
        }

    func sndStop() {
        fillPlayer.stop()
        pourPlayer.stop()
        drainPlayer.stop()
        }

}
