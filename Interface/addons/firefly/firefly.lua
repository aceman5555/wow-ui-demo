function firefly()

	if not (UnitName("target") == nil) then 

		blah = math.random(1,26);
	local genderTable = { "its", "his", "her" };
	local genderTablet = { "it", "him", "her" };
	local genderBench = { "ERROR", "Man", "Woman" };
	local genderChair = { UnitName("target"), "Sir", "Maam" }

		if blah == 1 then SendChatMessage("We're not gonna die. We can't die, " .. UnitName("target") .. ". You know why? Because we are so...very...pretty. We are just too pretty for God to let us die.", "SAY"); end
		if blah == 2 then SendChatMessage("I don't believe there's a power in the 'verse that can stop " .. UnitName("target") .. " from being cheerful. Sometimes you just wanna duct tape " .. genderTable[UnitSex("target")] .. " mouth and dump " .. genderTablet[UnitSex("target")] .. " in the hold for a month.", "SAY"); end
		if blah == 3 then SendChatMessage("And " .. UnitName("target") .. ", what the hell's goin' on in the engine room? Were there monkeys? Some terrifying space monkeys maybe got loose?", "SAY"); end
		if blah == 4 then SendChatMessage("Damn you, " .. UnitName("target") .. "! Damn you 'ta Hades! You broke my heart in a million pieces! You made me love you, and then y-- I SHAVED MY BEARD FOR YOU!", "SAY"); end
		if blah == 5 then SendChatMessage(UnitName("target") .. ", You are completely off your nut.", "SAY"); end
		if blah == 6 then SendChatMessage("Hey, no, we'll just set course for the Planet of the Lonely, Rich, and Appropriately Hygienic Men. I'll just tell " .. UnitName("target") .. ", we can park there for a month.", "SAY"); end
		if blah == 7 then SendChatMessage(UnitName("target") .. "'s out of it. That bumblebee laid down arms at the first sign of inevitable crushing defeat, can you imagine such a cowardly creature?", "SAY"); end
		if blah == 8 then SendChatMessage("Any friend of " .. UnitName("target") .. "'s is a strictly business-like relationship of mine.", "SAY"); end
		if blah == 9 then SendChatMessage(UnitName("target") .. ", I'm taking your sister under my protection here. If anything happens to her, anything at all, I swear to you, I will get very choked up. Honestly, there could be tears.", "SAY"); end
		if blah == 10 then SendChatMessage(UnitName("target") .. ", what in the sphincter o' hell you playing at?","SAY"); end
		if blah == 11 then SendChatMessage("Start with the part where " .. UnitName("target") .. " gets knocked out by a ninety-pound girl, 'cuase I don't think that's ever gettin' old.","SAY"); end
		if blah == 12 then SendChatMessage("I think you're beginning to understand how dangerous " .. UnitName("target") .. " is.","SAY"); end
		if blah == 13 then SendChatMessage(UnitName("target") .. " used to tell me, 'Can't do somethin' smart, do somethin' right'.","SAY"); end
		if blah == 14 then SendChatMessage(UnitName("target") .. ". Guy killed me, " .. UnitName("target") .. ". He killed me with a sword. How weird is that?","SAY"); end
		if blah == 15 then SendChatMessage(UnitName("target") .. ", we've got some local color happening. Your grand entrance would not go amiss right now.","SAY"); end		
		if blah == 16 then SendChatMessage("See, " .. UnitName("target") .. "? Dress yourself up you get taken out somewhere fun.","SAY"); end
		if blah == 17 then SendChatMessage("Now " .. UnitName("target") .. ", stay behind the others. If there's fighting, you drop to the floor and run away.... It's okay to leave them to die.","SAY"); end
		if blah == 18 then SendChatMessage("Sure. It would be humiliating. Having to lie there while the better " .. genderBench[UnitSex("player")] .. " refuses to spill your blood. Mercy is the mark of a great " .. genderBench[UnitSex("player")] .. ". (lightly stabs " .. UnitName("target") .. ") Guess I'm just a good " .. genderBench[UnitSex("player")] .. ". (stabs " .. genderTablet[UnitSex("target")] .. " again) Well, I'm all right.","SAY"); end
		if blah == 19 then SendChatMessage("You're like... a trained ape. Without the training.","SAY"); end
		if blah == 20 then SendChatMessage("I don't like fellows that kill me. Not in general.","SAY"); end
		if blah == 21 then SendChatMessage("See, this is a sign of your tragic space dementia. All paranoid and crotchety, it breaks the heart.","SAY"); end
		if blah == 22 then SendChatMessage(genderChair[UnitSex("target")] .. ", I think you have a problem with your brain being missing.","SAY"); end
		if blah == 23 then SendChatMessage("But, " .. UnitName("target") .. "! You hear what that purple belly called Serenity?","SAY"); end
		if blah == 24 then SendChatMessage("I like watching the game. As with other situations, the key seems to be giving " .. UnitName("target") .. " a heavy stick and standing back.","SAY"); end
		if blah == 25 then SendChatMessage("We need a diversion. I say " .. UnitName("target") .. " gets nekkid.","SAY"); end
		if blah == 26 then SendChatMessage("Well, my days of taking you seriously are certainly coming to a middle.","SAY"); end

	else
	
		blah = math.random(1,49);
	
		if blah == 1 then SendChatMessage("Ten percent of nuthin' is...let me do the math here...nuthin' into nuthin'...carry the nuthin'...", "SAY"); end
		if blah == 2 then SendChatMessage("I brought you some supper, but if you'd prefer a lecture I've a few very catchy ones prepped... sin and hellfire... one has lepers.","SAY"); end
		if blah == 3 then SendChatMessage("Well they tell you: 'Never hit a man with a closed fist'. But it is, on occasion, hilarious.", "SAY"); end
		if blah == 4 then SendChatMessage("Time for some thrilling heroics.","SAY"); end
		if blah == 5 then SendChatMessage("Do you know what the chain of command is here? It's the chain I go get and beat you with to show you who's in command.","SAY"); end
		if blah == 6 then SendChatMessage("You know, it's all very sweet, stealing from the rich, selling to the poor...","SAY"); end
		if blah == 7 then SendChatMessage("Ahh, the pitter patter of tiny feet in huge combat boots.","SAY"); end
		if blah == 8 then SendChatMessage("Bye, hon! We promise not to stop for beers with the fellas! ... So, are we gonna sing army songs of something?","SAY"); end
		if blah == 9 then SendChatMessage("Hey, I've been in a firefight before! Well, I was in a fire.... Actually, I was fired from a fry-cook opportunity.","SAY"); end
		if blah == 10 then SendChatMessage("Well this is one of the crazier things I've heard today, and when I tell you about the rest of my day you'll appreciate...","SAY"); end
		if blah == 11 then SendChatMessage("Captain says you're to stay put. Doesn't want you runnin' afoul of his blushin' psychotic bride. She figures out who you are, she'll turn you in 'fore you can say 'Don't turn me in, lady'.","SAY"); end
		if blah == 12 then SendChatMessage("I hate to bring up our imminent arrest during your crazy time, but we gotta move.","SAY"); end
		if blah == 13 then SendChatMessage("Also? I can kill you with my brain.","SAY"); end
		if blah == 14 then SendChatMessage("Oh my god, it's grotesque! Oh, and there's something in a jar.","SAY"); end
		if blah == 15 then SendChatMessage("Do not fear me. Ours is a peaceful race, and we must live in harmony...","SAY"); end
		if blah == 16 then SendChatMessage("My food is problematic.","SAY"); end
		if blah == 17 then SendChatMessage("Oh! That was bracing. They don't like it when you shoot at them. I worked that out myself.","SAY"); end
		if blah == 18 then SendChatMessage("This distress call wouldn't be taking place in someones pants, would it?","SAY"); end
		if blah == 19 then SendChatMessage("I look out for me and mine. That don't include you 'less I conjure it does. Now you stuck a thorn in the Alliance's paw -- that tickles me a bit. But it also means I gotta step twice as fast to avoid 'em, and that means turnin' down plenty of jobs.","SAY"); end
		if blah == 19 then SendChatMessage("Even honest ones. Put this crew together with the promise of work, which the Alliance makes harder every year. Come a day there won't be room for naughty men like us to slip about at all.","SAY"); end
		if blah == 20 then SendChatMessage("This job goes south, there well not be another. So here's us, on the raggedy edge.","SAY"); end
		if blah == 21 then SendChatMessage("Shiny. Let's be bad guys.","SAY"); end
		if blah == 22 then SendChatMessage("You know what the definition of a hero is? Someone who gets other people killed. You can look it up later.","SAY"); end
		if blah == 23 then SendChatMessage("At last. We can retire and give up this life of crime.","SAY"); end
		if blah == 24 then SendChatMessage("You shoot me if they take me! ... Well, don't shoot me FIRST!","SAY"); end
		if blah == 25 then SendChatMessage("I'll kill a man in a fair fight. Or if I think he's gonna start a fair fight. Or if he bothers me. Or if there's a woman. Or if I'm gettin' paid. Mostly when I'm gettin' paid.","SAY"); end
		if blah == 26 then SendChatMessage("Eating people alive? Where's that get fun?","SAY"); end
		if blah == 27 then SendChatMessage("No, not now that she's a...a killer woman, we oughtta be bringin' her tea and dumplings!","SAY"); end
		if blah == 28 then SendChatMessage("She's starting to damage my calm!","SAY"); end
		if blah == 29 then SendChatMessage("No more runnin'. I aim to misbehave.","SAY"); end
		if blah == 30 then SendChatMessage("Target the Reavers... target the Reavers.. target everyone... somebody FIRE!","SAY"); end
		if blah == 31 then SendChatMessage("Shot me in the back! Haven't made you angry, have I?","SAY"); end
		if blah == 32 then SendChatMessage("Now think real hard. You been bird-dogging this township a while now. They wouldn't mind a corpse of you. Now you can luxuriate in a nice jail cell, but if your hand touches metal, I swear by my pretty floral bonnet: I will end you.","SAY"); end	
		if blah == 33 then SendChatMessage("It's a real burn, being right so often.","SAY"); end
		if blah == 34 then SendChatMessage("Take my love, take my land - Take me where I cannot stand - I don't care, I'm still free - You can't take the sky from me - Take me out to the black - Tell 'em I ain't comin' back","SAY"); end
		if blah == 34 then SendChatMessage("Burn the land and boil the sea - You can't take the sky from me - There's no place I can be - Since I found serenity - But you can't take the sky from me.","SAY"); end
		if blah == 35 then SendChatMessage("Okay, uh, I'm lost. I'm angry. And I'm armed.","SAY"); end
		if blah == 36 then SendChatMessage("One of you is gonna fall and die. And I'm not cleaning it up.","SAY"); end
		if blah == 37 then SendChatMessage("Can we all vote on the murdering people issue?","SAY"); end
		if blah == 38 then SendChatMessage("Bad. In the Latin.","SAY"); end		
		if blah == 39 then SendChatMessage("Looks like civilization's finally caught up with us.","SAY"); end		if blah == 40 then SendChatMessage("Well now, ain't this a whole lotta fuss. I didn't know better, might think we were dangerous.","SAY"); end
		if blah == 41 then SendChatMessage("Oh, look at the pretties!","SAY"); end
		if blah == 42 then SendChatMessage("Now, we're favored guests, treated to the finest in beverages that make you blind.","SAY"); end
		if blah == 43 then SendChatMessage("Yeah. I wouldn't trade this for nothing, playing cards for a night off from septic flush duty.","SAY"); end
		if blah == 44 then SendChatMessage("Up 'til the punching, it was a real nice party.","SAY"); end
		if blah == 45 then SendChatMessage("It never goes smooth. How come it never goes smooth?","SAY"); end
		if blah == 46 then SendChatMessage("Once, just once, I want things to go according to the gorram plan!","SAY"); end
		if blah == 47 then SendChatMessage("My sister's a ship. We had a fairly complicated childhood.","SAY"); end
		if blah == 48 then SendChatMessage("I am a leaf on the wind… watch how I soar.","SAY"); end
		if blah == 49 then SendChatMessage("'A lot of people are asking me, you know, what exactly is Firefly?  It's a TV show you morons!' -Joss Whedon","SAY"); end
	
	end
end
