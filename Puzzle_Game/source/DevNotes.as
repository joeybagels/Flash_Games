			var colOffset:Number = 0;
				if (i%2 > 0) {
					colOffset = 0.5;
				} else {
					colOffset = 0;
				}
					gems[i][j].y = j * Config.BLOCKSIZE + Config.BLOCKSIZE / 2 + Config.BLOCKSIZE * colOffset - maxDistance + distance;

					
					
					
					
					selectedX
					getAreAdjacent
					
-need to see where it's looking at the click release, calculating which gem to swap

may need to adjust this in onGemMouseDown() as well
  may need to make sure the horizontal selection difference isn't messing it up, that the count is right between vertical and horizontal moves
  
  checkDestroy()
  
  createNewGems()

set valid swap locations, between  columns to go both up and down
when swapping horizontally, check for modded colum Y position

when looking for matches, it needs to go up on the last

-------
Next swaps:  look at the code that determines valid swap directions
look at the matching code, use same directional logic

getFormedGroups()
getHasMoves()
getGroup()
+getAreAdjacent()


Does caps allow open moves?
Can we get rid of getHasMoves?


Diagonal Groups not going all the way to the edges?


On mouse down, if already selected piece, don't let them swap with a block++




-------------------
In Game.as
For building the special move actions:

follow checkDestroy() method and what calls it
Probably want to call our own destroy method that follows basic logic of check destroy, then calls the check match logic like during a swap.
Look at how destroyingGems[] is used, it puts groups in there.  Can we form our own group (regardless of piece type) and have it mirror the process?

checkDestroy() called on fall complete or on swap
  so, we need to have the click method call its own special destroy/treatment, then follow through with the rest of the code.
  for special moves that destroy, the special can follow its destroy animation
  for type change, we should go through a type change sequence, and then loop into like the end of the fall or swap, to see if it needs to destroy




onSpecialTileTime() - do check for special color matches
  set a timer up, at the end of which, make a color switch, similar to the specialDestroy
  then check for specialDestroy.  Make sure special destroy has its own timer going on.
  so we'll be setting up onSpecialColorTime, then colorSwitch, then it will go to the special destroy sequence



Rnd gem color - debug, make sure its working, test SS and Thing






Right now, Galactus projects outward, is that ok?  otherwise, i'll have to code a simpler pattern rather than trying to code a 2x1 logic



Fix Gem's color settings to level settings
and 1575 in Game



Do we need getHasMoves() ?  What happens during a game if there are no moves left?  For this reason, would need to control pieces that enter the board?
  Looks like it just needs to check both the diagonals properly, can it be recoded to use the diagonal groups that swapping does?
  
When it hits no more moves, it resets the board.  How do we want to handle this?


After color shuffle, do not go into fall sequence if there's no deletes?


in onGemOverTime(), to the angle calculation, look at the border conditions, test for odd or even row, and cap the angle sensitivity based on that.
rollovers for special gems, in onGemOverTime() set specific frames that have animation for specific gems.  rearrange the directional to be a sub-clip, or lay the rest out in other frames




-------------------------------'

doMoveInitialGems() is where the pieces are being told to move from
  should try tracing out old and new positions
  

createNewGems
onFallTime











