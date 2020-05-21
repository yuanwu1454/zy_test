local M = {}

function M:testSeatClockView()
    local SeatClock             = require2("app.bean.room.view.SeatClock")
    local layer = test:createGLtestLayer(255, args)
    self._seatClock = SeatClock.new("#baccarat_avatar_seat_clock.png", 64, 64)
    :addTo(layer, 2)
    :pos(display.width/2, display.height/2)
    self._seatClock:setSpeakTime(20)
    self._seatClock:startCount(20)
end

function M:testChatPanel()
    local ChatPanel = require2("app.bean.room.view.ChatPanel")
    local layer = test:createGLtestLayer(255, args)
    self._chatPanel = ChatPanel.new({}, g.vars.user.chatBtnIndex, true, false):pos(-ChatPanel.WIDTH * 0.5 , ChatPanel.HEIGHT * 0.5):addTo(layer)
    self._chatPanel:setHideCallback(handler(test, test.nullFunc))
    self._chatPanel:setLocalZOrder(999) 
    transition.moveTo(self._chatPanel, {time = 0.4, x = ChatPanel.WIDTH * 0.5 , easing = "circleOut"})
end

function M:testNoseatLayer()
    local layer = test:createGLtestLayer(255, args)
    local HundredPlayerWithoutSeatView 	= require2("app.bean.roomHundred.view.HundredPlayerWithoutSeatView")
    self._noSeatPlayersView = HundredPlayerWithoutSeatView.new({}, isNewProtocol):pos(-HundredPlayerWithoutSeatView.WIDTH * 0.5 - 5, HundredPlayerWithoutSeatView.HEIGHT * 0.5 + 5):addTo(layer)
    transition.moveTo(self._noSeatPlayersView, {time = 0.4, x = HundredPlayerWithoutSeatView.WIDTH * 0.5 + 5, easing = "circleOut"})
end

function M:testSettingAndHelpView()
    local SettingAndHelpView = require2("app.bean.setting.view.SettingAndHelpView")
    SettingAndHelpView.new():show()
end

function M:testRoomProfileInfoView()
    local Player 	    		= require2("app.bean.room.model.Player")
    local player = Player.new()
	player:setUid( g.vars.user.uid)
	player:setGender(g.vars.user.gender)
	player:setUserName(g.vars.user.name)
	player:setSPic(g.vars.user.sPic)
	player:setUserChips(g.vars.user.chips)

    local view = require2("app.bean.room.view.RoomProfileView")
    view.new(player, false, true, false):show()
end

function M:testProfileView()
    local view = require2("app.bean.profile.view.ProfileView")
    view.new(g.vars.user.uid):show()
end
function M:testSeatAlarmClock()
    local layer = test:createGLtestLayer(255, args)
    local SeatAlarmClock 	= require2("app.bean.room.view.SeatAlarmClock")
    self._noSeatPlayersView = SeatAlarmClock.new(SeatAlarmClock.TABLE_TYPE_BACCARAT)
    :pos(display.width/2, display.height/2)
    :addTo(layer)
end

return M