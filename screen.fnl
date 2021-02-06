(var container nil)

(. {

	:init (fn []
		(set container (love.graphics.newCanvas g.win-width g.height))
		(container:setFilter :nearest :nearest)
		(love.window.setMode (* g.win-width g.scale) (* g.height g.scale) {:vsync false :x 480 :y 256})
		(love.graphics.setLineStyle :rough)
		(love.graphics.setLineWidth 1))

	:start (fn []
		(container:renderTo love.graphics.clear)
		(local canvas-opts {})
		(table.insert canvas-opts container)
		(tset canvas-opts :stencil true)
		(love.graphics.setCanvas canvas-opts))

	:end (fn []
		(love.graphics.setCanvas)
		(local window-x (if g.fullscreen (- (/ (love.window.getWidth) 2) (* (/ g.width 2) g.scale)) 0))
		(local window-y (if g.fullscreen (- (/ (love.window.getHeight) 2) (* (/ g.height 2) g.scale)) 0))
		(love.graphics.draw container window-x window-y 0 g.scale g.scale))

})