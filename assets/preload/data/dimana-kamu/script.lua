-- time bar changes colours every note hit cool epic, by HavenMari
-- both opponent and player

function onSongStart()
	setProperty("timeBar.color",getColorFromHex("000fff"))
end


function goodNoteHit(id, noteData, noteType, isSustainNote)
	if noteData == 0 then
		setProperty("timeBar.color",getColorFromHex("E200ff"))
	end

	if noteData == 1 then
		setProperty("timeBar.color",getColorFromHex("00ddff"))
	end

	if noteData == 2 then
		setProperty("timeBar.color",getColorFromHex("06ff00"))
	end

	if noteData == 3 then
		setProperty("timeBar.color",getColorFromHex("Ff0004"))
	end
end

function opponentNoteHit(id, noteData, noteType, isSustainNote)
	if noteData == 0 then
		setProperty("timeBar.color",getColorFromHex("E200ff"))
	end

	if noteData == 1 then
		setProperty("timeBar.color",getColorFromHex("00ddff"))
	end

	if noteData == 2 then
		setProperty("timeBar.color",getColorFromHex("06ff00"))
	end

	if noteData == 3 then
		setProperty("timeBar.color",getColorFromHex("Ff0004"))
	end
end

