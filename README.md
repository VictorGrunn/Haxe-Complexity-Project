Haxe-Complexity-Project
=======================

Author: Victor Grunn/Joseph Antolick

A haxe project illustrating some points of OO complexity and innovation.

This is a large (yet incomplete!) project, so instead of going through 
and exhaustively commenting on the individual functions, features, etc
in a wholesale way, a few highlights are going to be offered here.

* This builds off the fundamental logic of the other puzzle game on
display in the git repository, implementing the core game logic within
the skeleton of an RPG system. This shows off a bit of applied logic
and code-reuse / innovation, with a key enhancement being the queue
system for commands.

* The major innovation here is on display in
/source/puzzlebase/rules
/source/puzzlebase/puzzprocess

Whereas the previous puzzle project simply showed off the puzzle solution
logic and process, I modified that system here to implement a turn-by-turn
queue system.

Basically - rather than automatically resolving and switching from function
to wait state, etc, this project divides the game logic into discrete actions
and subactions. These are implemented in the form of instruction objects
all of which extend ProcessPart (source/puzzlebase/puzzprocess/ProcessPart).

A vector of pieces which extend ProcessPart is used. Each 'set' of instructions 
overrides functions begin, launch, onFinalComplete and flush as needed. When
placed into the master array, each piece in position 0 is 'begun', and remains
in the array until boolean 'complete' is set to 'true'. Once complete, the array
removes the relevant ProcessPart-extending object via a shift() and either
processes (moves into position 0 and begin()s) the next ProcessPart in the queue,
or, if there are no remaining moves, automatically generates the ProcessPart for
the next 'turn' - such as waiting for the player or AI to make its next move.

Here's a high level overview of how this works:

On initialization, PuzzleInitializeProcess is created and placed in the ruleQueue 
array in the StandardRules object. This object extends ProcessPart and steps through
all of the processes needed to generate a fresh puzzle, making sure that the puzzle
contains no automatic 3+ matching pieces (Since the goal of the game is to place
3 or more pieces in a horizontal or vertical row, which is left up to the player
or AI). Once the puzzle is generated and arranged, onFinalComplete() is called,
setting this object's 'complete' variable to true and informing the queue that
it is time to remote it from position 0 and 'begin' the next move.

Currently the game is set to expect a move from the human player when all processes
are complete - so a MovePieceProcess object is automatically generated and added
to the queue. In this case, MovePieceProcess awaits input from the player to move
a piece of the puzzle in order to continue. Once the player moves, MovePieceProcess
processes and evaluates the desired move. If the move is invalid, it animates the
failed match, and continues to wait for another move on the part of the player. If
the move is valid (it results in a match of 3 or more horizontal or vertical pieces)
then it generates and adds a MatchCheckProcess to the queue after itself, and sets
itself to 'complete'.

The queue is told to flush out MovePieceProcess and move on to MatchCheckProcess.
MatchCheckProcess is 'begin()'d' and proceeds to check the entire puzzle for matches.
For each valid match present, relevant data is recorded (what is the length of the
match, what particular pieces were matched). The particular pieces determined to
be part of a 'match' are added to a RemovePieceProcess object created by
MatchCheckProcess, while at the same time a RefillRowsProcess object is created.
RemovePieceProcess is added to the queue, with RefillRows Process added behind it -
so pieces are removed from the puzzle, the row is refilled. After a row refill,
a fresh MatchCheckProcess object is generated (to see if this clear and refill
has resulted in a 'cascade', ie, additional matches). If so, the process of 
clearing the pieces and refilling the rows completes. Otherwise, the queue is emptied
and a MovePieceProcess is added to the queue to await player instructions again.

The advantage of this system is that it allows for a wide, wide variety of 'rules'
and systems to be implemented, with each 'step' in the rules being divided into
smaller, self-contained bits of logic/programming, making it easier to manage
as well as modify. This in turn allows for easy modification of the game itself
in grand ways - puzzlebase/combatgame shows off a similar system used for enemy
AI logic, stepping through monster-specific rules (to attack the player, move
pieces on the screen potentially, alter statistics, etc.) This makes the entire
game easier to bug-check and lends itself to a straightforward, turn-based
charting.

There's more at work here, but those are the highlights.

This uses the HaxeFlixel library, specifically the 3.5 library, but the swf included
in the export/flash/bin directory shows this app running with the code as of that time.
