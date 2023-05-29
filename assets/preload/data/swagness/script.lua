local playerBop = true	

local bopStength = 28

local downToNega = 1

local relocatePosition = 571

function onCreatePost()
  playerRelocatePos = getPropertyFromGroup('strumLineNotes', direction,'y')
end

function directionProcessing(bopStength)
  return bopStength*downToNega
end

function onBeatHit()
	for i=3,0,-1 do
		opponentRelocatePos = getPropertyFromGroup('strumLineNotes', direction,'y')
		setPropertyFromGroup('strumLineNotes', i+0,'y',directionProcessing(bopStength)+opponentRelocatePos)
		noteTweenY('opponentBop'..i, i+0, opponentRelocatePos, 0.15,"circInOut")
	end
	
    for i = 1,4 do
          setPropertyFromGroup('strumLineNotes', i+3,'y',directionProcessing(bopStength)+playerRelocatePos)
          noteTweenY('playerBop'..i, i+3,playerRelocatePos, 0.15,"circInOut")
	end
end