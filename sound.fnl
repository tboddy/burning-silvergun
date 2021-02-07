; ------------------------------------
; vars
; ------------------------------------

(var current-sound nil)

(local sfx-names [])
(local sfx-files {})

(local bgm-names [:start :stage-intro :stage-loop])
(local bgm-files {})

(local bgm-volume 1)


; ------------------------------------
; extern
; ------------------------------------


(. {

 :playing-bgm false

 :init (fn []
  (for [i 1 (length bgm-names)]
   (local name (. bgm-names i))
   (tset bgm-files name (love.audio.newSource (.. "bgm/" name ".mp3") :static))
   (local file (. bgm-files name))
   (file:setVolume bgm-volume)
   (when (= name :stage-loop) (file:setLooping true))))

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

 :stop-bgm (fn [])

 })