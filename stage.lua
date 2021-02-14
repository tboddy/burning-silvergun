--------------------------------------
-- waves
--------------------------------------

local function waveOne()
	enemy:spawn('smallblue', g.height / 2)
end


--------------------------------------
-- spawn against clock
--------------------------------------

local sectionClock, currentEnemySection = 0, 1

local spawnWave = function(wave, time) if sectionClock == time then wave() end end

local enemySections = {
	function()
		spawnWave(waveOne, 10)
	end
}

local function updateEnemies()
	if enemySections[currentEnemySection] then enemySections[currentEnemySection]() end
	sectionClock = sectionClock + 1
end


return {

	update = function()
		updateEnemies()
	end

}