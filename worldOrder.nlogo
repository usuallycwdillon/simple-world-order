;; A NetLogo simulation model of a simple world order developing
;; This simulation models world order as a system of processes that involve states, rather than a system of states
;;
;; Author: Clarence Dillon, George Mason University
;; 22 May 2016
 

globals[
  prob-war                                  ;; is the probability that a war will break out between any two states
  proc-id                                   ;; this is just a tag to keep track of which process was most recently calling
  overall-stability                         ;; a count of how many ticks have passed with no wars on-going
  temperature                               ;; a list of the last 50 changes in probability of war
  long-xx                                   ;;\ 
  long-e                                    ;; \
  long-x                                    ;;  \ __ these measure the ratio of successful/total processes from this outcome space 
  long-w                                    ;;  /    so that we can see how stable the system is.
  long-z                                    ;; /
  long-a                                    ;;/ 
  procs-created                             ;;\ __ these are denominators for the measures
  states-created                            ;;/    above; not just counts, how many were created
]


;; --- types of agents: states, institutions and processes -----------------------------------------------------------------------------------------------
;; States
breed [states state]
states-own[                                 ;; In addition to the following, states can be participants in processes (participate)  
  resources                                 ;; some integer initially less than 100
  productivity                              ;; some integer less than 10
  enough                                    ;; some amount 20-50% of starting resources; the lower limit of resources needed to maintain the state 
  my-wars                                   ;; a list of wars the state is involved with
  needs-peace?                              ;; some state behaviors are just modeled as T/F based on probabilities and needs: does the state need peace?
  undertaking-action?                       ;; is the state currently undertaking action?
  will-contribute?                          ;; is the state willing to contribute to an institution or process
  prop-war                                  ;; a relative measure of the ratio of time states spend with an ongoing war vs some other status
]

;; Institutions
breed [institutions institution]
institutions-own [
  longevity                                 ;; for how many ticks has the institution existed?
  cost                                      ;; the cost of maintaining this institution
  influence                                 ;; the amount by which this institution lowers the probability of war for its members
  proc-s?                                   ;; whether the institution has become a persistent manifestation of the process that spawned it
]

;; Processes
breed [procs proc]
procs-own [                                 ;; state k for the system can be presumed as the states exist first
  pol-c?                                    ;; a process has started with a war/conflict but it may not include all states
  pol-n?                                    ;; beligerents agree that the war needs to end
  pol-p?                                    ;; the states involved in the process have 'chosen' to end the process or make it peaceful
  pol-u?                                    ;; all states involved in the process agree to undertake action for peace, so the process spawns an institution
  pol-s?                                    ;; the institution persists and P(war) reduces for members
  is-new?                                   ;; is this the process that was just made?
]
;; --------------------------------------------------------------------------------------------------------------------------------------------------------


;; --- types of links -----------------------------
;; Processes can form institutions; stay linked
directed-link-breed [forms form]

;; States partipate in processes
undirected-link-breed [participates participate]

;; States involved in processes become members of
;; institutions formed by the proceess
directed-link-breed [members member]
;;-------------------------------------------------

to make-movie
  ;; prompt user for movie location
  user-message "First, save your new movie file (choose a name ending with .mov)"
  let path user-new-file
  if not is-string? path [ stop ]  ;; stop if user canceled

  ;; run the model
  setup
  movie-start path
  movie-grab-view
  movie-grab-interface
  while [going? = True]
    [ go
      ;;movie-grab-view
      movie-grab-interface 
      ]

  ;; export the movie
  movie-close
  user-message (word "Exported movie to " path)
end
 


;; Setup procedure 
to setup
  clear-all
  ask patches [set pcolor grey + 4]
  set-default-shape turtles "circle"
  repeat num-states [make-state]
  layout-circle states (num-states / 2)
  set prob-war initial-prob-war
  set temperature []
  set long-xx 0
  set long-e 0
  set long-x 0
  set long-w 0
  set long-z 0
  set long-a 0
  reset-ticks
  set going? True
end


;; The 'go' procedure implements the canonical theory: states face challenges (in the form of wars), initiating a process. Through collective 
;; action of peace-making (not just ending wars; states must recognize the need for peace, undertake action to make peace, and have that action
;; be successful) the process becomes an institution which reduces the probability of war between members. So long as member-states are willing 
;; to maintain the institution, it persists. When the institution reduces the probability of war to 0, the process dies and only the institution 
;; remains. The network of states and institutions represents world order.
to go
  ask procs [set is-new? False]
  
  if any? procs [                                             ;; if there are any processes...    
    
                                                              ;; canonical S block:
    if any? procs with [pol-s? = True] [                      ;; specifically, if there are any processes in state 's' of political development...     
      ask procs with [pol-s? = True] [                        ;; ask them...
        let stability sum [influence] of out-form-neighbors
        let this-proc self 
        set prob-war (prob-war - effect)                      ;;         ...to reduce the overall probability of war in the system a tiny bit
        ask out-form-neighbors [                              ;;         ...to maintain the institutions
          collect-resources this-proc
          if abs(influence) > prob-war [set longevity longevity + 1];   ...to increment the longevity of institutions
          set influence influence - 0.005                     ;;         ...to increase the influence of institutions on war (negative)
          ask my-in-members [
            if thickness < 1.0 [                              ;; visually show state membership in institutions getting stronger, up to a point
              set thickness (thickness + 0.01)]
          ] 
        ]
        ask my-out-forms [
          if thickness < 1.0 [                                ;; visualize stability by increasing thickness of links from processes
            set thickness (thickness + 0.01)
          ]
        ]     
        if do-log? [                                          ;; to institutions
          print "This proc at S has become established: "
          print who]
        if prob-war + (sum [influence] of out-form-neighbors) <= 0 [ ;; if the global probaility of war and institutional stability make war improbable,
          ask participate-neighbors [set my-wars remove this-proc my-wars] ; remove this process from the list of 
          ask out-form-neighbors [set proc-s? True]                
          die                                                 ;; this is no longer a process, so much as it is just an institution; process dies
          set long-a long-a + 1                               ;; ** an institution has successfully become independent of it's formation process 
          let num-procs count procs
          layout-circle procs max-pxcor - 2
        ] 
      ]
    ]
    
    ;; canonical U block:
    if any? procs with [pol-u? = True and pol-s? = False] [
      ask procs with [pol-u? = True and pol-s? = False] [     ;; if involved states undertake collective action, it may or may not produce peace:
        ifelse pol-p? = True [                                ;; if it has already produced peace, let it persist and make things more stable. How?
          let this-proc self
          ;set long-z long-z + 1
          ask out-form-neighbors [                            ;; First, the out-form neighbors (institutions linked to this process) will collect
            collect-resources this-proc                       ;; resources from member-states; a willingness to maintain the institution. Then, 
            if abs(influence) > prob-war [set longevity longevity + 1] ; count that the institutions persist another turn. Finally, make it that institutions
            set influence influence - 0.005                   ;; have a progressively stabilizing effect.
          ]
          ask my-out-forms [set thickness thickness + 0.01]   ;; visually show the linkage between processes and their institutions getting stronger
          if all? my-out-forms [thickness >= 1] [set pol-s? True] ; when the linkages are strong enough, the process has become fully institutionalized
        ][
        try-peace                                             ;; this action by the process is a shortcut calculation; really this depends on the states 
        ]                                                     ;; but it represents the P or ~P contingency
      ]
    ]
    
    ;; canonical N block:
    if any? procs with [pol-n? = True and pol-u? = False] [
      ask procs with [pol-n? = True and pol-u? = False] [
        try-peace                                             ;; not all processes will survive (canonical outcome E or X) but if they do, 
        ask participate-neighbors [consider-action]           ;; all states involved in this process consider undertaking action        
        let involved-states participate-neighbors             
        let the-process self
        if all? participate-neighbors [undertaking-action? = True] [
          set pol-u? True                                     ;; undertake the action (and everything that goes with it)
          ask patch-at 0 0 [sprout-institutions 1 [           ;; create an institution 
            set size 2.2 
            set color 107
            set longevity 0
            set influence 0.01
            set proc-s? False
            create-form-from the-process                      ;; link the institution to this process
            create-members-from involved-states ]             ;; and make the states involved in the process become members of the institution
          ]
          let num-inst count institutions
          layout-circle institutions max-pxcor - 5
          ask participate-neighbors [
            create-members-to out-form-neighbors              ;; also pickup 
          ]
        ]           
      ]
      
    ]
    
    ;; canonical C block:
    if any? procs with [pol-c? = True and pol-n? = False] [
      ask procs with [pol-c? = True and pol-n? = False] [
        ask participate-neighbors [consider-need]             ;; all states involved in this process consider whether they need to make peace
        if all? participate-neighbors [needs-peace? = True] [
          set pol-n? True
        ]
      ]    
    ]
  ]
  
  ;; purge old institutions
  ask institutions [
    if longevity > 20 and abs(influence) > prob-war [
      die
    ]
  ]
  
  ;; regardless of processes or 
  ask one-of states [
    consider-war                                   
    set resources resources + productivity
    foreach my-wars [
      set resources resources - random 5
    ]
    
  ]
  
  if count procs with [pol-c? = True and pol-p? = False] = 0 [set overall-stability overall-stability + 1]
  if length temperature = 50 [set temperature but-first temperature]
  set temperature lput prob-war temperature
  if (overall-stability = 50) and (first temperature = prob-war)  [stop] 
  if prob-war <= 0 [stop]
  
  ;; update process longevity counts, by state (condition, not kingdom-state)
  
  if do-log? = True [ask states [print resources / enough]]
  
  tick

end

to go-once
  go
end

to make-state
  create-states 1 [
    set size 2
    set color 36
    set resources 100 + random 100
    set productivity 5 + random 20
    set enough ((random-float 0.3) + 0.2) * resources
    set my-wars []
    set needs-peace? False
    set undertaking-action? False
    set will-contribute? False
  ]
end

to make-institution 
  create-institutions 1 [
    set size 2.2
    set color 107
    set longevity 0
    set cost 1 + random 2
    set influence -0.01 
  ]
end

to start-process 
  create-procs 1 [
    set pol-c? True        
    set pol-n? False  
    set pol-p? False  
    set pol-u? False  
    set pol-s? False
    set color 17     
  ]
end

;; TODO: make this probabilistic and reduce thickness of links when not paid
to collect-resources [process]
  ask in-member-neighbors [
    ifelse (resources - enough) > [cost] of myself [          ;; if a state can afford to maintain the institution
      set resources resources - [cost] of myself              ;; then they support it
      ][                                                      ;; if the state cannot afford to maintain the institution
      ifelse random-float 1.0 < .5 [                          ;; then there is 50/50 chance that the state will: 
        ask process [set pol-s? False]                        ;; destabilize the process, 
        ask my-participates [die]                             ;; disengage from the process and 
        ask my-in-members [die]                               ;; disengage from the institution   
        ][
        ask process [die]                                     ;; otherwise the whole process dies
        ]
      ]
  ]
end

; from the perspective of the processes, not the states
to try-peace                                                  ;; a probabilistic calculation whether the process becomes peaceful,  
  let p-p random-float 0.5                                    ;; depening on how many states are involved and whether the states involved
  let war-size count participate-neighbors                    ;; have all recognized a need for peace and undertaken action to acheive it.  
  let this-proc self
  ifelse pol-u? = True [                                      ;; starting with the latter case, assume there is a 90% possibility for peace
    ifelse (.9 ^ war-size) > p-p [                            ;; in processes with states undertaking action, this could mean progress
      set pol-p? True
      ask participate-neighbors [set my-wars remove this-proc my-wars]
      ask my-participates [set color 57]
    ][
    set long-w long-w + 1
    ]                    
  ][
  ifelse (.67 ^ war-size) > p-p [                             ;; for states not undertaking action to make peace, the development process dies
    ask participate-neighbors [set my-wars remove this-proc my-wars]
    die                                                       ;; if they do make peace. 
    set long-x long-x + 1
  ][
    let make-another?  False
    let my-spot patch-at 0 0 
  ask states [if resources <= 0 [
    set my-spot patch-here
    if do-log? = True [print who]
    if do-log? = True [print my-spot]
    set make-another? True
    die
    set long-e long-e + 1
  ]
  ]
  if make-another? = True [  
    ask my-spot [sprout-states 1[
      set size 2
      set color 36
      set resources 10 + random 100
      set productivity random 10
      set enough ((random-float 0.3) + 0.2) * resources
      set my-wars []
      set needs-peace? False
      set undertaking-action? False
      set will-contribute? False 
      set states-created states-created + 1
      ]        
    ]
    layout-circle states (num-states / 2)
  ]
  ]   
  ]
  if do-log? = True [print p-p]
end

;; a method for states to consider whether to start/join a war
to consider-war                                              ;; first, calculate the probability of _this_ war, depending on influece of institutions of
                                                             ;; whic states are members                
  let p-w random-float 1.0                                   ;; pick a random number in the range (0 and 1]
  let target one-of states                                   ;; pick one other state
  let prob-this-war 0                                        ;; intially, there is no probability of _this_ war between this state and the target state
                                                             ;; and if both states are members of the same institututions, the overall prob-war gets 
  ifelse any? institutions with [                            ;; reduced by the combined influence of those insitutions  
    (member? self in-member-neighbors) and (member? target in-member-neighbors)
    ][
  let order institutions with [
    (member? self in-member-neighbors) and (member? target in-member-neighbors)
  ]
  set prob-this-war prob-war + sum [influence] of order
    ][
  set prob-this-war prob-war ; if they share no institutions the probability of this war is the overall probability of war for the system
    ]
  let coin-toss random 1
  ifelse ([length my-wars] of target > 0 and coin-toss = 0) [  ;; if the target is already at war, consider joining in war against them
    if (1 - p-w) < prob-this-war [
      if do-log? = True [print [participate-neighbors] of target]
      if any? [participate-neighbors with [pol-c? = True and pol-p? = False] ] of target  [
        let their-proc one-of [participate-neighbors with [pol-c? = True and pol-p? = False] ] of target     ; if they're at war, there should be a process 
        create-participate-with their-proc [set color 27]
        set my-wars fput their-proc my-wars
        set needs-peace? False
        set undertaking-action? False
        set will-contribute? False
      ]
    ]
  ][ 
  if (1 - p-w) < prob-this-war [
    let who-called self
    ask patch-at-heading-and-distance -90 2 [sprout-procs 1 [ ; start a new process if starting a new war
      set size 1.8
      set color 57
      set pol-c? True        
      set pol-n? False  
      set pol-p? False  
      set pol-u? False  
      set pol-s? False 
      set is-new? True
      let this-proc self
      create-participate-with target [set color 27]
      create-participate-with who-called [set color 27]
      ask who-called [set my-wars fput this-proc my-wars]
      ask target [set my-wars fput this-proc my-wars] 
      if do-log? = True [print participate-neighbors]
      set procs-created procs-created + 1
    ]
    ]
    let num-procs count procs
    layout-circle procs max-pxcor - 2
  ]
  ]
end

;; the probability that a state needs peace or is willing to consider action increases as their resources dwindle
;; from the cost of wars

to consider-need ; a method for states to consider whether they need peace
  let p-n random-float 1.0
  let need ((1 + resources) / (1 + enough) ) * random-float 1.0
  let make-another? False
  let my-spot patch-here
  ifelse p-n < need [
    set needs-peace? True
  ][
  if resources <= 0 [
    set my-spot patch-here
    if do-log? = True [print who]
    if do-log? = True [print my-spot]
    set make-another? True
    die
    set long-xx long-xx + 1
  ]
  ]
  if make-another? = True [  
    ask my-spot [sprout-states 1[
      set size 2
      set color 36
      set resources 10 + random 100
      set productivity random 10
      set enough ((random-float 0.3) + 0.2) * resources
      set my-wars []
      set needs-peace? False
      set undertaking-action? False
      set will-contribute? False 
      set states-created states-created + 1
    ]        
    ]
    layout-circle states (num-states / 2)
  ]
end

to consider-action ; a method for state to consider whether to take action
  let p-a random-float 1.0
  let need ((1 + resources) / (1 + enough)) * random-float 1.0
  if p-a < need [set undertaking-action? True]
end
@#$#@#$#@
GRAPHICS-WINDOW
592
25
1186
640
36
36
8.0
1
8
1
1
1
0
0
0
1
-36
36
-36
36
0
0
1
ticks
30.0

BUTTON
14
10
96
77
Setup
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

PLOT
20
489
587
639
Probability of War
Time
War Likelihood
0.0
5.0
0.0
10.0
true
true
"" ""
PENS
"P(war)" 1.0 0 -817084 true "" "plot prob-war"
"Reduced P(war)" 1.0 0 -10649926 true "" "plot ((sum [influence] of institutions) / (1 + count institutions)) * -1"

BUTTON
96
10
178
43
go
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
96
43
178
76
go once
go-once
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
298
10
470
43
initial-prob-war
initial-prob-war
0
10
5
.1
1
NIL
HORIZONTAL

SLIDER
178
10
299
43
num-states
num-states
5
40
30
5
1
NIL
HORIZONTAL

MONITOR
459
222
587
267
Ongoing processes
count procs
17
1
11

SWITCH
178
42
299
75
do-log?
do-log?
1
1
-1000

MONITOR
459
178
586
223
Instutions Count
count institutions
17
1
11

PLOT
18
310
458
489
Wars
Time
Wars
0.0
20.0
0.0
4.0
true
false
"" ""
PENS
"count" 1.0 0 -2674135 true "" "plot count procs with [pol-c? = True and pol-p? = False]"

MONITOR
460
267
586
312
Stabilizing
count institutions with [proc-s? = True]
0
1
11

MONITOR
521
355
585
400
At Peace
count procs with [pol-p? = True]
0
1
11

MONITOR
525
311
585
356
Trying
count procs with [pol-u? = True]
0
1
11

MONITOR
459
311
526
356
See Need
count procs with [pol-n? = True and pol-u? = False]
0
1
11

MONITOR
459
355
526
400
In Conflict
count procs with [pol-c? = True and pol-p? = False]
0
1
11

MONITOR
458
445
586
490
New States
states-created
0
1
11

MONITOR
459
400
586
445
New Procs
procs-created
0
1
11

SLIDER
298
42
470
75
effect
effect
.001
.02
0.005
.001
1
NIL
HORIZONTAL

TEXTBOX
19
84
456
309
To run: click 'Setup' then 'go'.  Expect 200-3,000 ticks until the system stabilizes.\n\nWhat you see:\n - Brown dots represent states\n - Green dots represent processes\n - Blue dots are institutions formed from processes\n -- links connecting states to processes are orange when the process is conflict (a war) and they turn green if/when the process becomes peaceful\n -- grey links from states to institutions and from processes to institutions get fatter as time goes on until they are persistent \n - the graph re-draws (1) if states get destroyed (a new one spawns) (2) if processes emerge, fail, or become fully institutionalized (3) a new institution forms or fails.\n\nSimulation stops when the system has been stable for 50 ticks\n
12
0.0
1

BUTTON
469
10
575
76
Make movie
make-movie
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SWITCH
470
75
575
108
going?
going?
0
1
-1000

BUTTON
471
107
574
140
Cancel
movie-cancel
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

PLOT
20
639
586
772
Institution Count
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot count institutions"

@#$#@#$#@
## WHAT IS IT?

This is a demonstration of international (world) order forming. It demonstrates the process of formation but is not a model of the _reasons_ it forms. 

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270

@#$#@#$#@
NetLogo 5.2.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="experiment" repetitions="30" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="3600"/>
    <metric>count institutions</metric>
    <metric>count procs with [pol-c? = True and pol-p? = False]</metric>
    <metric>states-created</metric>
    <metric>procs-created</metric>
    <enumeratedValueSet variable="initial-prob-war">
      <value value="0.1"/>
      <value value="0.5"/>
      <value value="1"/>
      <value value="2"/>
      <value value="5"/>
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="effect">
      <value value="0.001"/>
      <value value="0.005"/>
      <value value="0.01"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-states">
      <value value="20"/>
      <value value="30"/>
      <value value="40"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180

@#$#@#$#@
0
@#$#@#$#@
