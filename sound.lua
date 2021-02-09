local sfxVolume, bgmVolume, sfxFiles, bgmFiles, sfxNames, bgmNames = 0.5, 1, {}, {},
	{'bullet1', 'bullet2', 'bullet3', 'explosion1', 'explosion2', 'gameover', 'menuchange', 'playerhit', 'playershot', 'start', 'bonus'},
	{'start', 'stage-intro', 'stage-loop'}


--------------------------------------
-- load
--------------------------------------

local processFiles = function(isBgm)
	local names, files, dir, ext = sfxNames, sfxFiles, 'sfx', 'wav'
	if isBgm then
		names = bgmNames
		files = bgmFiles
		dir = 'bgm'
		ext = 'mp3'
	end
	for i = 1, #names do
		files[names[i]] = love.audio.newSource(dir .. '/' .. names[i] .. '.' .. ext, 'static')
		files[names[i]]:setVolume(sfxVolume)
		if isBgm and names[i] == 'stage-loop' then files[names[i]]:setLooping(true)
		elseif not isBgm then
			if names[i] == 'playershot' then files[names[i]]:setVolume(0.3)
			elseif names[i] == 'bullet1' or names[i] == 'bullet2' or names[i] == 'bullet3' then files[names[i]]:setVolume(0.4) end
		end
	end
end


return {


	------------------------------------
	-- load
	------------------------------------

	load = function(self)
		processFiles()
		processFiles(true)
		self:playBgm('start')
	end,


	------------------------------------
	-- events
	------------------------------------

	stopBgm = function()
		for i, file in ipairs(bgmFiles) do if file:isPlaying() then file.stop() end end
	end,

	playBgm = function(self, name)
		self.stopBgm()
		bgmFiles[name]:play(name)
	end,

	playSfx = function(self, name)
		if sfxFiles[name]:isPlaying() then sfxFiles[name]:stop() end
		sfxFiles[name]:play()
	end,


	------------------------------------
	-- loop
	------------------------------------

	update = function(self)
		self.playingBgm = false
		for i, file in ipairs(bgmFiles) do if file:isPlaying() then self.playingBgm = true end end
	end


}