--too lazy to document much here but change the values around to your own liking if u know how to -heat
--ALSO THIS ONLY WORKS WITH PSYCH v5.0 AND ABOVE

local healthLoss = 1.5; -- health loss on miss
local healthGain = 0; -- health gain on hit

judgement = true; -- punishment for hitting off beat

scale = 0.6; -- scale of "note"
xOffset = -65; -- x offset of "note"
safeOffset = 0.6; -- the distance the "note" can be hit

function onCreate()
	for i = 0, getProperty('unspawnNotes.length')-1 do
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'Crosshair' then
			setPropertyFromGroup('unspawnNotes', i, 'texture', 'crosshair'); -- texture path
			setPropertyFromGroup('unspawnNotes', i, 'noteSplashDisabled', true); --no note splashes
			setPropertyFromGroup('unspawnNotes', i, 'ignoreNote', true);
			setPropertyFromGroup('unspawnNotes', i, 'mustPress', false); 
			setPropertyFromGroup('unspawnNotes', i, 'copyAlpha', false); 
			setPropertyFromGroup('unspawnNotes', i, 'copyX', false); 
		end
	end
end

function onUpdate(elapsed)
	for i = 0, getProperty('notes.length')-1 do
		if getPropertyFromGroup('notes', i, 'noteType') == 'Crosshair' then
			if getPropertyFromGroup('notes', i, 'strumTime') - getPropertyFromClass('Conductor', 'safeZoneOffset') * safeOffset < getSongPosition() then
				if keyJustPressed('space') or botPlay then 
					crossHit(i);
				end
			end

			if getSongPosition() > getPropertyFromGroup('notes', i, 'strumTime') + (300 / getProperty('songSpeed')) then
				crossMiss(i);
			end

			-- Dupe removal i guess?
			if getPropertyFromGroup('notes', i, 'strumTime') == getPropertyFromGroup('notes', i, 'prevNote.strumTime') 
				and getPropertyFromGroup('notes', i, 'prevNote.noteType') == 'Crosshair' then
				setPropertyFromGroup('notes', id, 'visible', false); 
				setPropertyFromGroup('notes', id, 'active', false); 
				removeFromGroup('notes', id, false);
			end
			
			-- Offsets?
			setPropertyFromGroup('notes', i, 'alpha', getPropertyFromGroup('playerStrums', 0, 'alpha')); 
			setPropertyFromGroup('notes', i, 'x', getPropertyFromGroup('playerStrums', 0, 'x') + xOffset); 	
			setPropertyFromGroup('notes', i, 'scale.x', scale); 
			setPropertyFromGroup('notes', i, 'scale.y', scale); 
		end	
 	end
end

-- Miss
function crossMiss(id)
	setPropertyFromGroup('notes', id, 'visible', false); 
	setPropertyFromGroup('notes', id, 'active', false); 
	removeFromGroup('notes', id, false);
	playSound('gunshot', 1);
	triggerEvent('Play Animation', 'hurt', 'bf');
	cameraShake('camGame', 0.04, 0.15);
	setProperty('health', getProperty('health') - healthLoss);
end

-- Hit
function crossHit(id)
	loss = 0;
	if judgement and not botPlay then
		loss = 0.003 * (getSongPosition() - getPropertyFromGroup('notes', id, 'strumTime')) * (healthLoss / 2);
		--if loss > 0 then loss = -loss; end 
		if loss > 0 then loss = 0; end 
	end
	setPropertyFromGroup('notes', id, 'visible', false); 
	setPropertyFromGroup('notes', id, 'active', false); 
	removeFromGroup('notes', id, false);
	triggerEvent('Play Animation', 'dodge', 'bf');
	cameraShake('camGame', 0.06, 0.2);
	playSound('gunshot', 0.5);
	setProperty('health', getProperty('health') + healthGain + loss);
end