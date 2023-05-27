
Dodged = false;
canDodge = false;
DodgeTime = 0;

function onCreate()
    precacheImage('spacebar_icon');
end

function onEvent(name, value1, value2)
if name == "DodgeEvent" then

    DodgeTime = (value1);
	--debugPrint(DodgeTime);

	makeAnimatedLuaSprite('spacebar_icon', 'spacebar_icon', 400, 200);
    luaSpriteAddAnimationByPrefix('spacebar_icon', 'spacebar', 'spacebar', 25, true);
	luaSpritePlayAnimation('static', 'static');
	setObjectCamera('spacebar_icon', 'other');
	scaleLuaSprite('spacebar_icon', 0.50, 0.50); 
    addLuaSprite('spacebar_icon', true); 
	
	canDodge = true;
	runTimer('Died', DodgeTime);
	
	end
end

function onUpdate()
   if canDodge == true and keyJustPressed('space') then
   Dodged = true;
   --playSound('energy shot', 0.5);
   removeLuaSprite('spacebar_icon')
   canDodge = false;
   end
end

function onTimerCompleted(tag, loops, loopsLeft)
   if tag == 'Died' and Dodged == false then
   setProperty('health', 0);
   
   elseif tag == 'Died' and Dodged == true then
   Dodged = false;
   
   end
end