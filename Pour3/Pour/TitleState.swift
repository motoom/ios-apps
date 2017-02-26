
// Show the title screen, initiate a new game when the user clicks anywhere.

import GameplayKit

class TitleState: GameState {
    override init(controller: GameController) {
        super.init(controller: controller)
        }

    override func didEnter(from prevState: GKState?) {
        super.didEnter(from: prevState)
        print("Entered A from \(prevState)")
    }

    override func update(deltaTime seconds: TimeInterval) {
        print("TitleState.updateWithDeltaTime(\(seconds))")
        super.update(deltaTime: seconds)
        self.stateMachine?.enter(SetupState.self)
        }

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is SetupState.Type
        }

    }


