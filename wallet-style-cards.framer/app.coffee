# Wallet-Style Cards prototype
# Made by Sarah Kuehnle
# November 21, 2015

Framer.Device.background.backgroundColor = "#303030"
Framer.Device.deviceType = "iphone-5s-silver"

wLayers = Framer.Importer.load "imported/wallet-style-cards"
# beta property, be warned
Utils.globalLayers(wLayers)

Framer.Defaults.Animation =
  curve: "spring(200,30,0)"
  time: .4

cards = [cardBlue, cardYellow, cardGreen, cardOrange, cardRed]

# set up card states
for c, i in cards
  c.states.add
    up:
      x: c.x
      y: 150 + (i - 1) * 150
    focus:
      x: c.x
      y: 150
  # set cards in the 'up' position
  c.states.switchInstant 'up'

# object to hold card down animations
animation = {}

# send unfocused cards down
cardsDown = (card) ->
  counter = 1
  startY = 980
  for c in cards
    if c != card
      animation[counter] = new Animation
        layer: c
        properties:
          y: 960 + counter * 20
      c.position = 'down'
      animation[counter].start()
      counter++

# figure out what to do with cards based on position
handleCards = (card) ->
  cardState = card.position
  if cardState == 'up'
    card.states.switch 'focus'
    card.position = 'focus'
    cardsDown(card)
  else
    for c in cards
      c.states.switch "up"
      c.position = 'up'

# card button events
cardRed.on Events.Click, ->
  handleCards(cardRed)

cardOrange.on Events.Click, ->
  handleCards(cardOrange)

cardGreen.on Events.Click, ->
  handleCards(cardGreen)

cardYellow.on Events.Click, ->
  handleCards(cardYellow)

cardBlue.on Events.Click, ->
  handleCards(cardBlue)
