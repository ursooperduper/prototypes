# AirBnb-style Menu
# Made by Sarah Kuehnle
# November 25, 2015
# Based on example from Framer site example:
# http://framerjs.com/examples/preview/#airbnb-navigation.framer

# Page set up
Framer.Device.background.backgroundColor = "#303030"
Framer.Device.deviceType = "iphone-5s-silver"

#  Import art work
airbnbStyleMenuLayers = Framer.Importer.load "imported/airbnb-style-menu"

# Beta property, be warned
Utils.globalLayers(airbnbStyleMenuLayers)

# Set up default animation
Framer.Defaults.Animation =
	curve: "spring(200,30,0)"
	time: .4

# Initialize variables
menuVisible = false
currentSection = feedContent

# Set up holder for app content
container = new Layer width: 640, height: 1136
# 3D effects look more pronounced using Webkit
container.style.webkitPerspective = '1000px'
menu.superLayer = container

# Set up scroll component for the feed
scroll = new ScrollComponent
    scrollHorizontal: false
    width: 640
    height: 1136
    speedY: .8

scroll.superLayer = feedContent
card.superLayer = scroll.content

cardLayer = {}
for x in [1...20] by 1
	cardLayer[x] = card.copy()
	cardLayer[x].y = card.y + (20 + card.height) * x
	cardLayer[x].superLayer = scroll.content

# Put the feed top bar and button on top of the scrolling content
topBarFeed.bringToFront()
burgBtnFeed.bringToFront()

sections = [profileContent, feedContent, groupsContent, eventsContent, settingsContent]

for s, i in sections
	s.superLayer = container
	s.visible = true
	s.originX = 0
	s.originY = 0.5

	s.states.add
		reduced:
			x: 420
			scale: 0.55
			rotationY: -50
			blur: 3
		inview:
			x: 0
			scale: 1
			rotationY: 0
			blur: 0
		offscreen:
			x: 650
			scale: 0.55
			rotationY: -50
			blur: 3

	# Move content sections offscreen for now (except the feed)
	if s != feedContent
		s.states.switchInstant "offscreen"

handleSections = (nextSection, menuInView) ->
	if menuInView
		if nextSection != currentSection
			nextSection.states.switch "reduced"
			currentSection.states.switch "offscreen"

			nextSection.states.switch "inview"

			currentSection = nextSection
			menuVisible = false
		else
			currentSection.states.switch "inview"
			menuVisible = false
	else
		currentSection.states.switch "reduced"
		menuVisible = true

# Content Button
profileSubBtn = new Layer
feedSubBtn = new Layer
groupsSubBtn = new Layer
eventsSubBtn = new Layer
settingsSubBtn = new Layer

sectionBtns = [profileSubBtn, feedSubBtn, groupsSubBtn, eventsSubBtn, settingsSubBtn]

for sb in sectionBtns
	sb.width = 640
	sb.height = 1043
	sb.y = 92
	sb.opacity = 0

feedContent.addSubLayer(feedSubBtn)
profileContent.addSubLayer(profileSubBtn)
groupsContent.addSubLayer(groupsSubBtn)
eventsContent.addSubLayer(eventsSubBtn)
settingsContent.addSubLayer(settingsSubBtn)

# Content Buttons
topBarFeed.on Events.Click, ->
	handleSections(currentSection, true)

scroll.on Events.Click, ->
	handleSections(currentSection , true)

profileSubBtn.on Events.Click, ->
	handleSections(currentSection , true)

groupsSubBtn.on Events.Click, ->
	handleSections(currentSection , true)

eventsSubBtn.on Events.Click, ->
	handleSections(currentSection , true)

settingsSubBtn.on Events.Click, ->
	handleSections(currentSection , true)

# Burger Menus
burgBtnFeed.on Events.Click, ->
	handleSections(currentSection, false)

burgBtnProfile.on Events.Click,  ->
	handleSections(currentSection, false)

burgBtnGroups.on Events.Click, ->
	handleSections(currentSection, false)

burgBtnEvents.on Events.Click, ->
	handleSections(currentSection, false)

burgBtnSettings.on Events.Click, ->
	handleSections(currentSection, false)

# Menu Buttons
btnFeed.on Events.Click, ->
	if menuVisible
		handleSections(feedContent, true)

btnProfile.on Events.Click, ->
	if menuVisible
		handleSections(profileContent, true)

btnGroups.on Events.Click, ->
	if menuVisible
		handleSections(groupsContent, true)

btnEvents.on Events.Click, ->
	if menuVisible
		handleSections(eventsContent, true)

btnSettings.on Events.Click, ->
	if menuVisible
		handleSections(settingsContent, true)
