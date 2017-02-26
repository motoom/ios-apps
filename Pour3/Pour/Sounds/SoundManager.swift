
import UIKit
import AVFoundation

class SoundManager {

    var playersInitialized = false
    var fillPlayer: AVAudioPlayer! // TODO: Map from soundname -> initialised AVAudioPlayer instances
    var pourPlayer: AVAudioPlayer!
    var drainPlayer: AVAudioPlayer!

    init() {
        // TODO: Initialize sounds in a loop.
        let fillUrl = Bundle.main.url(forResource: "Fillup.wav", withExtension: nil)
        do {
            try fillPlayer = AVAudioPlayer(contentsOf: fillUrl!)
            fillPlayer.prepareToPlay()
            }
        catch {
            print("Fillup.wav not playable")
            }
        //
        let pourUrl = Bundle.main.url(forResource: "Eau.wav", withExtension: nil)
        do {
            try pourPlayer = AVAudioPlayer(contentsOf: pourUrl!)
            pourPlayer.prepareToPlay()
            }
        catch {
            print("Eau.wav not playable")
            }
        //
        let drainUrl = Bundle.main.url(forResource: "Toilet.wav", withExtension: nil)
        do {
            try drainPlayer = AVAudioPlayer(contentsOf: drainUrl!)
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
