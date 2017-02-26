
// Setup a new puzzle.

import GameplayKit

class SetupState: GameState {
    override init(controller: GameController) {
        super.init(controller: controller)
        }

    override func didEnter(from prevState: GKState?) {
        super.didEnter(from: prevState)
        print("Entered Setup from \(prevState)")
    }

    override func update(deltaTime seconds: TimeInterval) {
        print("SetupState.updateWithDeltaTime(\(seconds))")
        super.update(deltaTime: seconds)        
        // TODO: Setup a new puzzle
        self.stateMachine?.enter(FillingState.self)
        }

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is FillingState.Type
        }

    }


