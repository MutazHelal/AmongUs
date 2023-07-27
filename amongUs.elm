myShapes model =
case model.state of
Cafeteria ->
[ text "Cafeteria"
|> centered
|> filled black
, button "to Med Bay"
|> move (30,30)
|> notifyTap P1LD
, button "to Upper Engine"
|> move (-30,30)
|> notifyTap P1L
]
Admin ->
[ text "Admin"
|> centered
|> filled black
, button "to Cafeteria"
|> move (-30,30)
|> notifyTap P4LU
, button "Start SwipeCard Task"
|> move (30,30)
|> notifyTap StartSwipeCard
]
Storage ->
[ text "Storage"
|> centered
|> filled black
, button "to Cafeteria"
|> move (-30,30)
|> notifyTap P4U
, button "to Admin"
|> move (30,30)
|> notifyTap P4UR
]
Electrical ->
[ text "Electrical"
|> centered
|> filled black
, button "to Storage"
|> move (0,30)
|> notifyTap P3DR
]
LowerEngine ->
[ text "LowerEngine"
|> centered
|> filled black
, button "to Electrical"
|> move (-30,30)
|> notifyTap P3RU
, button "to Storage"
|> move (30,30)
|> notifyTap P3R
]
Reactor ->
[ text "Reactor"
|> centered
|> filled black
, button "to Security"
|> move (30,30)
|> notifyTap P2R
, button "to Lower Engine"
|> move (0,-30)
|> notifyTap P2RD
, button "Start CleanUp Task"
|> move (-30,30)
|> notifyTap StartCleanUp
]
UpperEngine ->
[ text "UpperEngine"
|> centered
|> filled black
, button "to Reactor"
|> move (-30,30)
|> notifyTap P2DL
, button "to Lower Engine"
|> move (0,-30)
|> notifyTap P2D
, button "to Security"
|> move (30,30)
|> notifyTap P2DR
]
Security ->
[ text "Security"
|> centered
|> filled black
, button "to Reactor"
|> move (-30,30)
|> notifyTap P2L
, button "to Lower Engine"
|> move (30,30)
|> notifyTap P2LD
]
MedBay ->
[ text "MedBay"
|> centered
|> filled black
, button "to Upper Engine"
|> move (0,30)
|> notifyTap P1UL
]
CleanUpTask ->
[ case model.gameState of
Play -> cleanUpGame model
Fail -> group [cleanUpGame model
, roundedRect 58 22 5
|> filled red
, text "Repeat Task"
|> centered
|> size 6.5
|> filled black
|> notifyTap RepeatCleanUp]
Win -> group [

--cleanUpGame model
text "Task Complete"
|> filled green
|> move (-35, 50)
, button "End Task"

|> move (0,30)
|> scaleX 0.8
|> scaleY 0.8
|> notifyTap EndCleanUp
, button "Repeat Task"
|> move (0,0)
|> scaleX 0.8
|> scaleY 0.8
|> notifyTap RepeatCleanUp

]

]

SwipeCardTask ->
[ if model.taskComplete
then group [button "End Task"
|> move (-90,30)
|> scaleX 0.8
|> scaleY 0.8
|> notifyTap EndSwipeCard

, button "Repeat Task"
|> move (90,30)
|> scaleX 0.8
|> scaleY 0.8
|> notifyTap RepeatSwipeCard]
else group[]

, swipeCardGame model
]

{- Type declarations -}
type Msg = Tick Float GetKeyState
| P1LD
| P1L
| P1UL
| P2DL
| P2DR
| P2D
| P2LD
| P2RD
| P2R
| P2L
| P3R
| P3RU
| P3DR
| P4U
| P4UR
| P4LU
| StartCleanUp
| StartSwipeCard
| EndCleanUp
| EndSwipeCard
| RepeatCleanUp
| RepeatSwipeCard
| Drag (Float, Float)
| ChangeDragState
| Click
| Reset
| StartDragTime
| StopDragTime
| TimeCheck
| SwipeCheck
| IsComplete
| Drag1 (Float, Float)
| Drag2 (Float, Float)
| Drag3 (Float, Float)
| Drag4 (Float, Float)
| ChangeToInDrag1
| ChangeToInDrag2
| ChangeToInDrag3
| ChangeToInDrag4
| ChangeToRelease
| StartTimeC

type State = Cafeteria
| Admin
| Storage
| Electrical
| LowerEngine
| Reactor
| UpperEngine
| Security
| MedBay
| CleanUpTask
| SwipeCardTask

type GameState = Play | Fail | Win

type DragState = Released | Dragging| InDrag1 | InDrag2 | InDrag3 | InDrag4

type alias Model =
{ time : Float
, state : State
}

{- Update Model -}
update msg model =
case msg of
Tick t _ -> { model | time = t
, timeLeft = case model.gameState of
Win -> 30
Play -> 30 - (model.time - model.startTimeLeaf)
Fail -> 0
, gameState = if model.timeLeft>0 && getX model.position1<(-60) && getX model.position2<(-60) && getX model.position3<(-60) && getX model.position4<(-60)
then Win
else if model.timeLeft <= 0
then Fail
else Play }

Drag (x, y) -> { model | pos = case model.dragState of
Dragging -> (x , y)
Released -> model.pos
InDrag1 -> model.pos
InDrag2 -> model.pos
InDrag3 -> model.pos
InDrag4 -> model.pos
}
Drag1 (x, y) -> { model | position1 = (x , y) }

Drag2 (x, y) -> { model | position2 = (x , y) }

Drag3 (x, y) -> { model | position3 = (x , y) }

Drag4 (x, y) -> { model | position4 = (x , y) }

ChangeToRelease -> { model | dragStateLeaf = Released }

ChangeToInDrag1 -> { model | dragStateLeaf = InDrag1 }

ChangeToInDrag2 -> { model | dragStateLeaf = InDrag2 }

ChangeToInDrag3 -> { model | dragStateLeaf = InDrag3 }

ChangeToInDrag4 -> { model | dragStateLeaf = InDrag4 }

ChangeDragState -> { model | dragState = case model.dragState of
Released -> Dragging
Dragging -> Released
InDrag1 -> InDrag1
InDrag2 -> InDrag2
InDrag3 -> InDrag3
InDrag4 -> InDrag4 }

StartTimeC -> { model | startTimeLeaf = model.time }

Click -> { model | pos = (-35, 30), screenText = "Swipe Card", positionCard = False
, swipeCheck = False, timeCheck = False, taskComplete = False }

StartDragTime -> { model | startTime = model.time }

StopDragTime -> { model | stopTime = model.time
, timeElapsed = model.time - model.startTime }

TimeCheck-> { model | timeCheck = if model.timeElapsed >= 1 && model.timeElapsed <= 2
then True
else False }

SwipeCheck -> { model | swipeCheck = if (Tuple.first model.pos) > 30
then True
else False }

IsComplete -> { model | taskComplete = if model.timeCheck == True && model.swipeCheck == True
then True
else False }

Reset -> { model | screenText = "Bad read", positionCard = True, pos = (0,0) }

P1LD ->
case model.state of
Cafeteria ->
{ model | state = MedBay }
otherwise ->
model
P1L ->
case model.state of
Cafeteria ->
{ model | state = UpperEngine }
otherwise ->
model
P1UL ->
case model.state of
MedBay ->
{ model | state = UpperEngine }
otherwise ->
model
P2DL ->
case model.state of
UpperEngine ->
{ model | state = Reactor }
otherwise ->
model
P2DR ->
case model.state of
UpperEngine ->
{ model | state = Security }
otherwise ->
model
P2D ->
case model.state of
UpperEngine ->
{ model | state = LowerEngine }
otherwise ->
model
P2LD ->
case model.state of
Security ->
{ model | state = LowerEngine }
otherwise ->
model
P2RD ->
case model.state of
Reactor ->
{ model | state = LowerEngine }
otherwise ->
model
P2R ->
case model.state of
Reactor ->
{ model | state = Security }
otherwise ->
model
P2L ->
case model.state of
Security ->
{ model | state = Reactor }
otherwise ->
model
P3R ->
case model.state of
LowerEngine ->
{ model | state = Storage }
otherwise ->
model
P3RU ->
case model.state of
LowerEngine ->
{ model | state = Electrical }
otherwise ->
model
P3DR ->
case model.state of
Electrical ->
{ model | state = Storage }
otherwise ->
model
P4U ->
case model.state of
Storage ->
{ model | state = Cafeteria }
otherwise ->
model
P4UR ->
case model.state of
Storage ->
{ model | state = Admin }
otherwise ->
model
P4LU ->
case model.state of
Admin ->
{ model | state = Cafeteria }
otherwise ->
model
StartCleanUp ->
case model.state of
Reactor ->
{ model | state = CleanUpTask, time = 0, pos = (0,0), timeLeft=30, gameState=Play, position1 = (0,-10)
, position2 = (30,22), position3 = (20,-34), position4 = (3,20), dragState = Released, dragStateLeaf = Released, startTimeLeaf = model.time}
otherwise ->
model
StartSwipeCard ->
case model.state of
Admin ->
{ model | state = SwipeCardTask }
otherwise ->
model
EndCleanUp ->
case model.state of
CleanUpTask ->
{ model | state = Reactor }
otherwise ->
model
EndSwipeCard ->
case model.state of
SwipeCardTask ->
{ model | state = Admin, pos = (0,0), screenText = "Swipe Card", positionCard = True
, swipeCheck = False, timeCheck = False, taskComplete = False, dragState = Released}
otherwise ->
model
RepeatCleanUp ->
case model.state of
CleanUpTask ->
{ model | state = CleanUpTask, time = 0 , pos = (0,0), timeLeft=30, gameState=Play, position1 = (0,-10)
, position2 = (30,22), position3 = (20,-34), position4 = (3,20), dragState = Released, dragStateLeaf = Released, startTimeLeaf = model.time}
otherwise ->
model
RepeatSwipeCard ->
case model.state of
SwipeCardTask ->
{ model | state = SwipeCardTask, pos = (0,0), screenText = "Swipe Card", positionCard = True
, swipeCheck = False, timeCheck = False, taskComplete = False, dragState = Released}
otherwise ->
model

init = {
time = 0
, state = Cafeteria
, pos = (0,0)
, positionCard = True
, screenText = "Swipe Card"
, startTime = 0
, stopTime = 0
, taskComplete = False
, timeElapsed = 0
, swipeCheck = False
, timeCheck = False
, timeLeft=30
, gameState=Play
, position1 = (0,-10)
, position2 = (30,22)
, position3 = (20,-34)
, position4 = (3,20)
, dragState = Released
, dragStateLeaf = Released
, startTimeLeaf = 0
}

-----------------------------------------------------------------
-- CLEAN-UP GAME SHAPES --
-----------------------------------------------------------------
cleanUpGame model = group [
sky,

vacuum,

leaf1
|> move model.position1
|> notifyMouseDown ChangeToInDrag1


|> if model.dragStateLeaf /= InDrag1 && getX model.position1 > (-60)
then move ((8 * cos (4 * model.time)), (8 * sin model.time))
else (if getX model.position1 < (-60)
then (makeTransparent 0)
else move (0,0)),

leaf2
|> move model.position2
|> notifyMouseDown ChangeToInDrag2

|> if model.dragStateLeaf /= InDrag2 && getX model.position2 > (-60)
then move ((6 * cos (4 * model.time + 1)), (6 * sin model.time))
else (if getX model.position2 < (-60)
then makeTransparent 0
else move (0,0)),

leaf3
|> move model.position3
|> notifyMouseDown ChangeToInDrag3

|> if model.dragStateLeaf /= InDrag3 && getX model.position3 > (-60)
then move ((7 * cos (4 * model.time + 2)), (7 * sin model.time))
else (if getX model.position3 < (-60)
then makeTransparent 0
else move (0,0)),

leaf4
|> move model.position4
|> notifyMouseDown ChangeToInDrag4

|> if model.dragStateLeaf /= InDrag4 && getX model.position4 > (-60)
then move ((9 * cos (4 * model.time + 3)), (10 * sin model.time))
else (if getX model.position4 < (-60)
then makeTransparent 0
else move (0,0)),

text ("Time Remaining: " ++ (Round.round 2 model.timeLeft))
|> size 7
|> centered
|> filled black
|> move (25,-55)
|>if model.timeLeft>0 && getX model.position1<(-60) && getX model.position2<(-60) && getX model.position3<(-60) && getX model.position4<(-60)
then makeTransparent 0
else ( if model.timeLeft<=0
then makeTransparent 0
else makeTransparent 1 )
,
case model.dragStateLeaf of
Dragging -> group []
Released -> group []
InDrag1 -> rect 185 125
|> ghost
|> notifyMouseMoveAt Drag1
|> notifyLeave ChangeToRelease
|> notifyMouseUp ChangeToRelease
InDrag2 -> rect 185 125
|> ghost
|> notifyMouseMoveAt Drag2
|> notifyLeave ChangeToRelease
|> notifyMouseUp ChangeToRelease
InDrag3 -> rect 185 125
|> ghost
|> notifyMouseMoveAt Drag3
|> notifyLeave ChangeToRelease
|> notifyMouseUp ChangeToRelease
InDrag4 -> rect 185 125
|> ghost
|> notifyMouseMoveAt Drag4
|> notifyLeave ChangeToRelease
|> notifyMouseUp ChangeToRelease ,

case model.gameState of
Play -> group []

Win -> text "Task Complete"
|> filled green
|> move (-15, 50)

Fail -> text "Task Failed"
|> filled red
|> move (-28, 50)

]

leaf1 = group [
rect 0.5 10
|> filled (brown)
|> move (20,-10),
curve (30,15) [Pull (10,0) (20,-10)]
|> filled (green)
]

leaf2 = group [
rect 0.5 10
|> filled (brown)
|> move (20,-10),
curve (25,15) [Pull (10,0) (20,-10)]
|> filled (red)
]


leaf3 = group [
rect 0.5 10
|> filled (brown)
|> move (20,-10),
curve (27,15) [Pull (10,0) (20,-10)]
|> filled (yellow)

]

leaf4 = group [
rect 0.5 10
|> filled (brown)
|> move (20,-10),
curve (22,15) [Pull (10,0) (20,-10)]
|> filled (brown)
]

sky =
rect 150 150
|> filled (lightBlue)

vacuum = group [
rect 50 150
|> filled (gray)
|> move (-55,0),

polygon [(0,76),(0,0),(21,8),(20,69)]
|> filled (black)
|> move (-60,-35),

triangle 6
|> filled (darkGray)
|> move (-68,4),

triangle 3
|> filled (darkGray)
|> rotate (degrees 180)
|> move (-35,4)
]

-----------------------------------------------------------------
-- SWIPE CARD GAME SHAPES --
-----------------------------------------------------------------
swipeCardGame model = group [wallet
|> move (0,-40)
, cardMachineBack
|> move (0,30)
, if model.positionCard == True
then card
|> move (-20,-37)
|> move model.pos
|> notifyTap Click
else card
|> notifyMouseDown ChangeDragState
|> notifyMouseDown StartDragTime
|> move model.pos
, case model.dragState of
Released -> group []
InDrag1 -> group []
InDrag2 -> group []
InDrag3 -> group []
InDrag4 -> group []
Dragging -> rect 150 30
|> filled orange
|> makeTransparent 0
|> move (0,30)
|> notifyMouseMoveAt Drag
|> notifyLeave ChangeDragState
|> notifyLeave StopDragTime
|> notifyLeave Reset
|> notifyMouseUp ChangeDragState
|> notifyMouseUp StopDragTime
|> notifyMouseUp TimeCheck
|> notifyMouseUp SwipeCheck
|> notifyMouseUp IsComplete
|> notifyMouseUp Reset

, cardMachineFront model
|> move (0,30)
, walletPocket
]

wallet = group
[rect 84 62
|> filled (rgb 84 54 2)
|> move (0,6)
, rect 80 57
|> filled (rgb 156 142 89)
|> move (0,7)
, rect 62 40
|> filled (rgb 32 97 40)
|> move (6,9)
|> rotate (degrees 30)
, rect 60 35
|> filled (rgb 63 166 75)
|> move (4,9)
|> rotate (degrees 30)
, rect 80 50
|> filled (rgb 84 54 2)
, rect 80 40
|> filled (rgb 120 90 10)
, rect 22 12
|> filled (rgb 84 54 2)
|> move (29,0)
, rect 20 10
|> filled (rgb 153 118 26)
|> move (30,0)
, circle 2.5
|> filled (rgb 191 190 186)
|> move (25,0)
]

walletPocket = group [rect 34 22
|> filled (rgb 84 54 2)
|> move (-20,-45)

]

card = group [
roundedRect 30 18 1
|> filled white
, roundedRect 30 18 1
|> outlined (solid 0.5) black
, rect 29 5
|> filled (rgb 145 224 230)
|> move (0,6)
, text "ID"
|> size 6
|> centered
|> filled black
|> move (0,4)
, circle 3
|> filled blue
|> move (-8,0)
, triangle 4
|> filled blue
|> move (-6,-7)
|> rotate (degrees -20)
, text "10/20/2017"
|> size 3
|> filled black
|> move (-1,-2)
, text "1234455000"
|> size 2.5
|> filled black
|> move (0,-7)

]

cardMachineBack = group [ -- back panel
rectangle 80 40
|> filled (rgb 83 84 87)
, rectangle 80 40
|> outlined (solid 1) black
]

cardMachineFront model = group [ -- screen panel
-- panel
roundedRect 80 35 5
|> filled grey
, roundedRect 80 35 5
|> outlined (solid 1) black
-- screen
, rectangle 60 10
|> filled green
|> move (0,7)
, text (screenText model)
|> size 10
|> centered
|> filled black
|> move (0,4)
, rectangle 60 10
|> outlined (solid 1) black
|> move (0,7)
-- fail light
, circle 3
|> filled (lightFail model)
|> move (25,-10)
, circle 3
|> outlined (solid 1) black
|> move (25,-10)
-- pass light
, circle 3
|> filled (lightPass model)
|> move (33,-10)
, circle 3
|> outlined (solid 1) black
|> move (33,-10)
-- arrow
, group [
roundedRect 47 3 2
|> filled black
, rightTriangle 10 6
|> filled black
|> move (20,-1.5)
] |> move (-13,-13)
] |> move (0,14)

lightFail model = if model.taskComplete == False && model.stopTime /= 0 && model.positionCard
then rgb 255 3 28
else rgb 82 15 17

lightPass model = if model.taskComplete
then rgb 0 255 26
else rgb 36 94 42

-- Changes text for Slow/Fast card, and when task is complete
screenText model = if model.taskComplete
then "Successful!"
else ( if model.swipeCheck == False
then model.screenText
else ( if model.timeElapsed < 1
then "Too Fast"
else "Too Slow" ) )

{- Other functions -}

getX (x, y) = x

button name = group [
roundedRect 58 22 5
|> filled lightBlue
, text name
|> centered
|> size 6.5
|> filled black
]