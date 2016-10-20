Beat Mangler X
Jacob Joaquin & Jean-Luc Cohen-Sinclair
October 3, 2010
jacobjoaquin@gmail.com
csoundblog.com

<CsoundSynthesizer>
<CsInstruments>
sr = 44100
kr = 44100
ksmps = 1
nchnls = 2
0dbfs = 1.0

; Table numbers for loop samples
# define loop_left  # 100 #
# define loop_right # 101 #

; Initial global sample information
gibit init 0
gichnls init 0
gilength init 0
gisr init 0
gisize init 0

; Random seed. A value of 0 will use the system clock.
seed 0

instr 1

    gS_sample = p4  ; File name of loop
    isize = p5      ; Size of sample to use. 1 = full sample, 0.5 = half
    ioffset = p6    ; Sample start offset. 0 = start, 0.5 = half way in

    ; Get sample properties
    gibit filebit gS_sample                      ; Bit rate
    gichnls filenchnls gS_sample                 ; Number of channels
    gilength filelen gS_sample                   ; Length in seconds
    ioffset = gilength * ioffset                 ; Offset of sample
    gilength = gilength * isize                  ; Adjust length to user
                                                 ;     specified size
    gisr filesr gS_sample                        ; Sample rate
    gisize = 2 ^ ceil(logbtwo(gilength * gisr))  ; Table size
    gilength_s = gilength * gisr                 ; Length in samples

    itemp ftgen $loop_left, 0, gisize, 1, gS_sample, 0, 4, 1

    ; Load sample into a table
    if gichnls == 1 then
        itemp ftgen $loop_right, 0, gisize, 1, gS_sample, ioffset, 4, 1
    else
        itemp ftgen $loop_right, 0, gisize, 1, gS_sample, ioffset, 4, 2
    endif

    turnoff
endin

instr 2


    //Start Serial Communication
    iSerialPort	serialBegin	"/dev/cu.usbmodem1421", 9600

    //Read the values into a slower k-rate variable
    kType	serialRead iSerialPort

    printk2 kType



    idur = p3            ; Duration
    iamp = p4            ; Amplitude
    ires = p5            ; Resolution of mangler, number of steps
    ienv_fn = p6         ; Step envelope shape from function table
    istep_odds = p7      ; Odds the step will be chosen at random (0..1)
    istutter_min = p8    ; Min number of stutters per stutter
    istutter_max = p9    ; Max number of stutters per stutter
    istutter_odds = p10  ; Odds that new step will stutter (0..1)

    ; Initialize values
    kstep init 0
    kstutter init 1
    kstutter2 init 1
    kstep_counter init 0

    ; Master phasor
    aphasor phasor 1 / idur          ; Master
    astepper = (aphasor * ires) % 1  ; Step phasor, synced to master

    ; Trigger new steps.
    kstepper downsamp astepper
    ktrigger trigger kstepper, 0.5, 1

    ; Set conditions of new step
    if ktrigger == 1 then
        ; Keep track of current step
        kstep_counter = kstep_counter + 1

        ; Random step
        kstep = kstep_counter
        krandom random 0, 1
        if krandom < istep_odds then
            kstep random 0, ires
            kstep = floor(kstep)
        endif

        ; Stutter left
        kstutter = 1
        krandom random 0, 1
        if krandom < istutter_odds then
            krandom2 random istutter_min, istutter_max
            kstutter = 1 / floor(krandom2)
        endif

        ; Stutter right
        kstutter2 = 1
        krandom random 0, 1


    endif

    if(kType == 49.00000)then
      if krandom < istutter_odds then
          krandom2 random istutter_min, istutter_max
          kstutter2 = 1 / floor(krandom2) + 16
      endif
    endif

    ; Add stutter, bias and convert step phasor units to samples
    aplay_head = (astepper % kstutter + kstep) / ires * gilength_s
    aplay_head2 = (astepper % kstutter2 + kstep) / ires * gilength_s

    ; Play sample
    aleft table3 aplay_head, $loop_left
    aright table3 aplay_head2, $loop_right

    ; Amplitude envelope of step
    a_amp table3 astepper, ienv_fn, 1
    a_amp = a_amp * iamp

    ; Output
    outs aleft * a_amp, aright * a_amp
endin

</CsInstruments>
<CsScore>

; Shapes for step envelope
f 1 0 8192 7 1 8192 0
f 2 0 8192 7 1 4096 0 4096 0
f 3 0 8192 7 1 8192 1

; Tempo
t 0 180

; Load loop
;i 1 0 1 "amen.wav" 0.5 0    ; Use measure 1 of loop
i 1 0 1 "amen.wav" 0.5 0.5  ; Use measure 2 of loop

; Play mangled loop
i 2 0 4 0.5  16 3 0     2 4  0
i 2 + . .    .  . 0.25  . .  0
i 2 + . .    .  . 0     . .  0.25
i 2 + . .    .  . 0.85  . .  0.125
i 2 + . 0.5  8  1 0.25  2 5  0.125
i 2 + . .    .  . .     . .  .
i 2 + . .    .  . 0.25 . .  0.5
i 2 + . 0.8  16 2 0.25  7 16 1
i 2 + . 0.5  16 3 0     2 4  0.125
i 2 + . .    .  . 0.25  . .  .
i 2 + . .    .  . 0     . .  .
i 2 + . 0.7  16 2 0     . .  0
i 2 + . 0.5  16 3 0     2 7  0.125
i 2 + . .    .  . 0.25  . .  .
i 2 + . .    .  . .     . .  .
i 2 + . .    .  . 0.25 . .  .
i 2 + . 0.5  16 1 0     2 9  1
i 2 + . .    .  . .     . .  .
i 2 + . .    .  . .     . .  .
i 2 + . 0.8  16 2 0     2 7  0
i 2 + . 0.5  16 1 0     2 9  1
i 2 + . .    .  . .     . .  .
i 2 + . .    .  . .     . .  .
i 2 + . .    .  . 0.25  4 13 .
i 2 + . 0.5  16 3 0     2 5  0
i 2 + . .    .  . 1     . .  .
i 2 + . .    .  . 0     . .  .
i 2 + . 0.7  16 2 1     7 12 0.75
i 2 + . 0.5  16 3 0     2 5  0.125
i 2 + . .    .  . 1     . .  0
i 2 + . .    .  . 0     . .  0.125
i 2 + . .    .  . 1     . .  0
i 2 + . 0.35 8  1 0     2 2  0
i 2 + . <    .  . <     . <  <
i 2 + . <    .  . <     . <  <
i 2 + . <    .  . <     . <  <
i 2 + . <    .  . <     . <  <
i 2 + . <    .  . <     . <  <
i 2 + . <    .  . <     . <  <
i 2 + . 0.01 .  . 1     . 9  1

</CsScore>
</CsoundSynthesizer>
