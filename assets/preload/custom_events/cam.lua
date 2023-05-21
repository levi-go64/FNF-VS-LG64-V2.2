-- Event notes hooks
function onEvent(name, value1, value2)
	if name == 'cam' then
		doTweenZoom('screenZoom', 'camGame', value1, value2, 'quadInOut');
	end
end