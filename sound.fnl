; ------------------------------------
; vars
; ------------------------------------

(var current-sound nil)

(local sfx-names [:bullet1 :bullet2 :bullet3 :explosion1 :explosion2 :gameover :menuchange :playerhit :playershot :start :bonus])
(local sfx-files {})
(local sfx-volume 0.5)

(local bgm-names [:start :stage-intro :stage-loop])
(local bgm-files {})
(local bgm-volume 1)



; ------------------------------------
; extern
; ------------------------------------


(. {

 :playing-bgm false

 :init (fn []

  (for [i 1 (length sfx-names)]
   (local name (. sfx-names i))
   (tset sfx-files name (love.audio.newSource (.. "sfx/" name ".wav") :static))
   (local file (. sfx-files name))
   (file:setVolume sfx-volume)
   (when (= name :playershot) (file:setVolume 0.3))
   (when (or (= name :bullet1) (= name :bullet2) (= name :bullet3)) (file:setVolume 0.4))

   )

  (for [i 1 (length bgm-names)]
   (local name (. bgm-names i))
   (tset bgm-files name (love.audio.newSource (.. "bgm/" name ".mp3") :static))
   (local file (. bgm-files name))
   (file:setVolume bgm-volume)
   (when (= name :stage-loop) (file:setLooping true)))

  )

 :update (fn []
  (set sound.playing-bgm false)
  (for [i 1 (length bgm-names)]
   (local name (. bgm-names i))
   (local file (. bgm-files name))
   (when (file:isPlaying) (set sound.playing-bgm true))))

 :play-bgm (fn [bgm-name]
  (for [i 1 (length bgm-names)]
   (local name (. bgm-names i))
   (local file (. bgm-files name))
   (when (file:isPlaying) (file:stop)))
  (local play-file (. bgm-files bgm-name))
  (play-file:play))

 :stop-bgm (fn []
  (for [i 1 (length bgm-names)]
   (local name (. bgm-names i))
   (local file (. bgm-files name))
   (when (file:isPlaying) (file:stop))))

 :play-sfx (fn [name]
  (local file (. sfx-files name))
  (when (file:isPlaying) (file:stop))
  (file:play))

 })