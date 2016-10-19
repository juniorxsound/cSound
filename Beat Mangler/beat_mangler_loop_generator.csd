Beat Mangler Loop Generator (class version)
Jacob Joaquin & Jean-Luc Cohen-Sinclair
November 1, 2010
jacobjoaquin@gmail.com
csoundblog.com
//

<CsoundSynthesizer>
<CsOptions>
-odac
</CsOptions>
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
    ibpm = p4         ; Beats per minute
    iloop_beats = p5  ; Number of beats in loop
    in_loops = p6     ; Number of loops to generate

    idur = 60 / ibpm * iloop_beats  ; Convert BPM to duration
    i_counter init 0                ; Loop iterator
    istart init 0                   ; Start time of loop

    ; Set static values for 'Beat Mangler X'
    iamp = 1
    istutter_min = 2
    istutter_max = 7

    start_loop:

        ; Randomize 'Beat Mangler X' parameter
        istart = i_counter * idur
        ires = 8
        ienv_fn = int(rnd(3)) + 1
        istep_odds = rnd(0.5)
        istutter_odds = rnd(0.5)

        ; Create 'Beat Mangler X' string event
        Sevent sprintf "i 3 %f %f %f %f %d %f %d %d %f %f", istart, idur, \
                       iamp, ires, ienv_fn, istep_odds, istutter_min,     \
                       istutter_max, istutter_odds, i_counter

        ; Generate event
        scoreline_i Sevent

    loop_lt i_counter, 1, in_loops, start_loop

    ; Turn on instr 4 to keep Csound engine running
    event_i "i", 4, 0, idur * in_loops

    ; Turnoff this instrument
    turnoff
endin

instr 3
    idur = p3            ; Duration
    iamp = p4            ; Amplitude
    ires = p5            ; Resolution of mangler, number of steps
    ienv_fn = p6         ; Step envelope shape from function table
    istep_odds = p7      ; Odds the step will be chosen at random (0..1)
    istutter_min = p8    ; Min number of stutters per stutter
    istutter_max = p9    ; Max number of stutters per stutter
    istutter_odds = p10  ; Odds that new step will stutter (0..1)
    i_index = p11        ; Index of generated audio file

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
        if krandom < istutter_odds then
            krandom2 random istutter_min, istutter_max
            kstutter2 = 1 / floor(krandom2)
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
    aleft = aleft * a_amp
    aright = aright * a_amp
    Sfile sprintf "./output/bmx_%d.aif", i_index
    fout Sfile, 2, aleft, aright
endin

instr 4
    ; Keep Csound engine running
endin

</CsInstruments>
<CsScore>

; Shapes for step envelope
f 1 0 8192 7 1 8192 0
f 2 0 8192 7 1 4096 0 4096 0
f 3 0 8192 7 1 8192 1

; Load loop
i 1 0 1 "amen.wav" 0.5 0    ; Use measure 1 of loop
;i 1 0 1 "amen.wav" 0.5 0.5  ; Use measure 2 of loop

; Generate 100 loops at 180 BPMs
i 2 0 1 180 4 100

</CsScore>
</CsoundSynthesizer>
