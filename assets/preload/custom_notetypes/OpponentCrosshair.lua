--too lazy to document much here but change the values around to your own liking if u know how to -heat
--ALSO THIS ONLY WORKS WITH PSYCH v5.0 AND ABOVE

local damage = 0.2; -- damage on hit

scale = 0.6; -- scale of "note"
xOffset = -65; -- x offset of "note"

function onCreate()
	for i = 0, getProperty('unspawnNotes.length')-1 do
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'OpponentCrosshair' then
			setPropertyFromGroup('unspawnNotes', i, 'texture', 'crosshair'); -- texture path
			setPropertyFromGroup('unspawnNotes', i, 'noteSplashDisabled', true); --no note splashes
			setPropertyFromGroup('unspawnNotes', i, 'mustPress', false); 
			setPropertyFromGroup('unspawnNotes', i, 'copyAlpha', false); 
			setPropertyFromGroup('unspawnNotes', i, 'copyX', false); 
		end
	end
end

function onUpdate(elapsed)
	for i = 0, getProperty('notes.length')-1 do
		if getPropertyFromGroup('notes', i, 'noteType') == 'OpponentCrosshair' then
			if getPropertyFromGroup('notes', i, 'strumTime') <= getSongPosition() then
				crossHit(i);
			end

			-- Dupe removal i guess?
			if getPropertyFromGroup('notes', i, 'strumTime') == getPropertyFromGroup('notes', i, 'prevNote.strumTime') 
				and getPropertyFromGroup('notes', i, 'prevNote.noteType') == 'OpponentCrosshair' then
				setPropertyFromGroup('notes', id, 'visible', false); 
				setPropertyFromGroup('notes', id, 'active', false); 
				removeFromGroup('notes', id, false);
			end
			
			-- Offsets?
			setPropertyFromGroup('notes', i, 'alpha', getPropertyFromGroup('opponentStrums', 0, 'alpha')); 
			setPropertyFromGroup('notes', i, 'x', getPropertyFromGroup('opponentStrums', 0, 'x') + xOffset); 	
			setPropertyFromGroup('notes', i, 'scale.x', scale); 
			setPropertyFromGroup('notes', i, 'scale.y', scale); 
		end	
 	end
end


-- Hit
function crossHit(id)
	setPropertyFromGroup('notes', id, 'visible', false); 
	setPropertyFromGroup('notes', id, 'active', false); 
	removeFromGroup('notes', id, false);
	cameraShake('camGame', 0.06, 0.2);
	playSound('gunshot', 0.5);
	setProperty('health', getProperty('health') - damage);
end