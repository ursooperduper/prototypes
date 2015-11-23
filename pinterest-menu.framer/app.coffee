# Pinterest Menu prototype
# Made by Sarah Kuehnle
# November 22, 2015

Framer.Device.background.backgroundColor = "#303030"
Framer.Device.deviceType = "iPhone-5s-silver"

pinterestMenuLayers = Framer.Importer.load "imported/pinterest-menu"

# beta property, be warned
Utils.globalLayers(pinterestMenuLayers)

Framer.Defaults.Animation =
	curve: "spring(400,20,0)"
	time: .1

# Arrays for button states and components
pressBtns = [pressPinBtn, pressHeartBtn, pressSendBtn]
pressSelecteds = [pinSelected, heartSelected, sendSelected]
pressLabels = [pressPinLabel, pressHeartLabel, pressSendLabel]

# set up states for the buttons
for pb in pressBtns
	pb.states.add
		inactive:
			scale: 0
			x: 0
			y: 0

	pb.states.switchInstant "inactive"

# set up states for the ring that appears under your finger
pressRing.states.add
	on:
		scale: 1
	off:
		scale: 0
pressRing.states.switchInstant "off"

# set up states for the pressed states of buttons
for ps in pressSelecteds
	ps.states.add
		on:
			visible: true
		off:
			visible: false
	ps.states.switchInstant "off"

# set up states for button labels
for pl in pressLabels
	pl.states.add
		on:
			visible: true
			scale: 1
		off:
			visible: false
			scale: .4
	pl.states.switchInstant "off"

# set up button animations based on touch location
setupButtons = (xPos, yPos, loc) ->
	
	if loc == "left"
		pinX = xPos
		pinY = yPos - 140
		heartX = xPos + 108
		heartY = yPos - 106
		sendX = xPos + 140
		sendY = yPos	
	else if loc == "middle"
		pinX = xPos - 106
		pinY = yPos - 88
		heartX = xPos
		heartY = yPos - 160
		sendX = xPos + 112
		sendY = yPos - 88		
	else if loc == "right"	
		pinX = xPos - 140
		pinY = yPos
		heartX = xPos - 100
		heartY = yPos - 102
		sendX = xPos
		sendY = yPos - 140
		
	for btn in pressBtns
		btn.states.add 
			off: 
				x: xPos
				y: yPos
				opacity: 0
				scale: 0
		btn.states.switchInstant "off"
 
	aniPin = new Animation
	    layer: pressPinBtn
	    properties:
	        x: pinX
	        y: pinY
	        scale: 1
	        opacity: 1
	        
	aniHeart = new Animation
	    layer: pressHeartBtn
	    properties:
	        x: heartX
	        y: heartY
	        scale: 1
	        opacity: 1
 
 	aniSend = new Animation
	    layer: pressSendBtn
	    properties:
	        x: sendX
	        y: sendY
	        scale: 1
	        opacity: 1

	aniPin.start()
	aniHeart.start()
	aniSend.start()

# handle touches on the bike picture
bikePic.on Events.TouchStart, (event, layer) ->
	touchEvent = Events.touchEvent(event)
	
	# determine if this prototype is being run on 
	# the phone or computer so we can get the
	# correct coordinates for touches
	if Utils.isPhone() || Utils.isTablet()
		tX = touchEvent.clientX - layer.x
		tY = touchEvent.clientY - layer.y
		pressRingXPos = tX - 30
		pressRingYPos = tY + 80
	else
		tX = touchEvent.offsetX + layer.x
		tY = touchEvent.offsetY + layer.y
		pressRingXPos = tX
		pressRingYPos = tY + 80
		
	pressRing.x = pressRingXPos
	pressRing.y = pressRingYPos
	
	# determine which section of the bike pic 
	# is being touched so we can orient the buttons 
	# correctly
	if tX > 0 && tX < 88 # left side
		loc = "left"
	else if tX > 88 && tX < 481
		loc = "middle"
	else if tX > 481 && tX < 561 # right side
		loc = "right"
	
	# show the buttons
	pressRing.states.switch "on"
	setupButtons(pressRingXPos, pressRingYPos, loc)
	
# hide the buttons when the touch ends
bikePic.on Events.TouchEnd, ->
	pressRing.states.switch "off"
	for pb in pressBtns
		pb.states.switch "off"

# pressPinBtn.on Events.MouseOver, (event, layer) ->
# 	pinSelected.states.switch "on"
# 
# pressHeartBtn.on Events.MouseOver, (event, layer) ->
# 	heartSelected.states.switch "on"
# 
# pressSendBtn.on Events.MouseOver, (event, layer) ->
# 	sendSelected.states.switch "on"	
# 	
# pressPinBtn.on Events.MouseOut, (event, layer) ->
# 	pinSelected.states.switch "off"
# 
# pressHeartBtn.on Events.MouseOut, (event, layer) ->
# 	heartSelected.states.switch "off"
# 
# pressSendBtn.on Events.MouseOut, (event, layer) ->
# 	sendSelected.states.switch "off"	