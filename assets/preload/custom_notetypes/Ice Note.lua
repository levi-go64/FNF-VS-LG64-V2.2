local ice = -1

local canPlay = {
  [1] = false,
  [2] = false,
  [3] = false,
  [4] = false,
}

function onCreatePost()

  luaDebugMode = true

  for i = 0, getProperty('unspawnNotes.length') do
    if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'Ice Note' then
      setPropertyFromGroup('unspawnNotes', i, 'texture', 'customNotes/ICENOTE_assets');
      setPropertyFromGroup('unspawnNotes', i, 'noteSplashDisabled', true);
      if getPropertyFromGroup('unspawnNotes', i, 'mustPress') then
        setPropertyFromGroup('unspawnNotes', i, 'ignoreNote', true);
      end
    end
  end

  for _, img in pairs({'customNotes/effects/freezedBf', 'customNotes/effects/notes'}) do precacheImage(img); end
  for _, snd in pairs({'notes/hitZipIce', 'deez/struggle', 'notes/missZipIce', 'deez/WindowShatter'}) do precacheSound(snd); end

  makeAnimatedLuaSprite('zipNotes', 'customNotes/effects/notes', 0, 0);
  for _, animsZN in pairs({
    'arrowLEFT', 'arrowDOWN', 'arrowUP', 'arrowRIGHT', 'blue', 'green', 'purple', 'red'
  }) do addAnimationByPrefix('zipNotes', animsZN, animsZN, 1, true); end
  setObjectCamera('zipNotes', 'camHUD');
  screenCenter('zipNotes');
  setProperty('zipNotes.visible', false);
  addLuaSprite('zipNotes', false);

  makeAnimatedLuaSprite('frozenBF', 'customNotes/effects/freezedBf', getProperty('boyfriend.x') - 100, getProperty('boyfriend.y') - 100);
  addAnimationByPrefix('frozenBF', 'idle', 'Idle_Frozen', 24, true);
  for animsBFF = 1, 4 do
    if animsBFF == 1 then addAnimationByIndices('frozenBF', animsBFF, animsBFF, '0,1,2,3,4,5,6', 24);
    else addAnimationByPrefix('frozenBF', animsBFF, animsBFF, 24, false);
    end
  end
  setObjectOrder('frozenBF', getObjectOrder('boyfriendGroup') + 1);
  setProperty('frozenBF.visible', false);
  addLuaSprite('frozenBF', false);

end

local ratiScore = {
  ['sick'] = -700,
  ['good'] = -400,
  ['bad'] = -200,
  ['shit'] = -100,
}

function goodNoteHit(membersIndex, noteData, noteType, isSustainNote)
  if noteType:find('Ice Note') and (ice == -1) then
    for pStrums = 0, getProperty('playerStrums.length') - 1 do setPropertyFromGroup('playerStrums', pStrums, 'alpha', 0.5); end
    setProperty('boyfriend.visible', false);
    setProperty('boyfriend.stunned', true);
    addMisses(1);
    addScore(ratiScore[getPropertyFromGroup('notes', i, 'rating')]);
    playSound('notes/hitZipIce', 5);
    ice = ice + 1
  end
end

local check = true

function onUpdatePost(elapsed)

  if ice == -1 then
    if check then
      check = false
      for pStrums = 0, getProperty('playerStrums.length') - 1 do setPropertyFromGroup('playerStrums', pStrums, 'alpha', 1); end
      setProperty('frozenBF.visible', false);
      setProperty('zipNotes.visible', false);
      setProperty('boyfriend.visible', true);
      setProperty('boyfriend.stunned', false);
    end
  elseif ice == 0 then
    for a = 1, 4 do if not canPlay[a] then canPlay[a] = true end
    if not check then
      check = true
      setProperty('frozenBF.visible', true);
      setProperty('zipNotes.visible', true);
      playAnim('frozenBF', 'idle', false);
    end
  end

  if ice % 2 == 0 then
    playAnim('zipNotes', 'purple', false);
    if keyboardJustPressed('LEFT') then
      if ice ~= 4 then
        ice = ice + 1
        playSound('deez/struggle', 5);
      else
        ice = -1
        playSound('deez/WindowShatter', 5);
        playAnim('boyfriend', 'hey', true);
      end
    end
  elseif ice % 1 == 0 then
    playAnim('zipNotes', 'red', false);
    if keyboardJustPressed('RIGHT') and (ice ~= -1) then
      ice = ice + 1
      playSound('deez/struggle', 5);
    end
  end

  if canPlay[ice] then
    canPlay[ice] = false
    playAnim('frozenBF', ice, true);
  end

end