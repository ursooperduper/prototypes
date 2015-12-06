# Menu prototype
# Made by Sarah Kuehnle
# November 21, 2015

Framer.Device.background.backgroundColor = "#303030"
Framer.Device.deviceType = "iphone-5s-silver"

mLayers = Framer.Importer.load "imported/menu"
Utils.globalLayers(mLayers)

Framer.Defaults.Animation =
  curve: "spring(300,30,0)"
  time: .4

menuVisible = false

btns = [btnDash, btnFeed, btnLock, btnBike, btnUser, btnStats, btnSettings]

for btn in btns
  btn.states.add
    stateVisible:
      x: btn.x
      y: btn.y
      opacity: 1
      scale: 1
      rotation: btn.rotationZ + 360
    stateHidden:
      x: btnMain.x
      y: btnMain.y
      opacity: 0
      scale: .2
      rotation: btn.rotationZ

  btn.states.switchInstant "stateHidden"

chevUp.states.add
  stateUp:
    rotation: 0
    y: 26
  stateDown:
    rotation: 180
    y: 30

chevUp.states.switchInstant "stateUp"

animationBop = new Animation
  layer: btnMain
  properties:
    scaleX: 1.2
    scaleY: 1.2
  curve: "ease-in-out"
  time: .1

animationBopBack = animationBop.reverse()
animationBop.on(Events.AnimationEnd, animationBopBack.start)

toggleMenu = () ->
  animationBop.start()
  if menuVisible == false
    chevUp.states.switch("stateDown")

    for btn, i in btns
      btn.states.switch "stateVisible", delay: .02 * i, time: .1

    menuVisible = !menuVisible
  else
    chevUp.states.switch("stateUp")

    for btn, i in btns
      btn.states.switch "stateHidden", delay: .03 * i, time: .1

    menuVisible = !menuVisible

btnMain.on Events.Click, ->
  toggleMenu()
