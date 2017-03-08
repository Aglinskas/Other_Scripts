function kbdemo_mycopy

	disp('TESTING KB... PRESS ANY KEY\n');
	
	start = GetSecs;
	
	stop = 0;
	keycode = 0;
	
	WaitSecs(0.2)
	while true
		[stop, keycode] = KbWait;
		if sum(keycode) > 0
			break
		end
	end
	
	delta = stop - start;
	keyname = KbName(keycode);
	
	disp(sprintf('%s PRESSED AT %.3f', keyname, delta));
	
	return
end	
