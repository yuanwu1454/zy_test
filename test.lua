module("test", package.seeall);
--[[
    更改device_id这个值会将对应的游客登陆产生游客 改变
    platform.lua中
    
]]--
--onKeyPressed

local nullFunc = function()
    print("nullFunc !!!")
end

local addButtonEvent =function(node, efunc)
    node:addTouchEventListener(function(ref, eventType)
        if cc.EventCode.BEGAN == eventType then
            -- self:onButtonEventTrigger(cc.EventCode.BEGAN)
          
        elseif cc.EventCode.MOVED == eventType then
            -- self:onButtonEventTrigger(cc.EventCode.MOVED)

        elseif cc.EventCode.ENDED == eventType then
            -- self:onButtonEventTrigger(cc.EventCode.ENDED)
            efunc()

        elseif cc.EventCode.CANCELLED == eventType then
            -- self:onButtonEventTrigger(cc.EventCode.CANCELLED)
        end
    end)     
end

local function addNormalTouchEvent(node,func)
    local listener1 = cc.EventListenerTouchOneByOne:create()
    listener1:setSwallowTouches(true)
    listener1:registerScriptHandler(function (touch,event)
        local p = node:getParent()
        while p ~= nil do 
            if p:isVisible() == false then return false end
            p = p:getParent()
        end
        
        if func ~= nil then return func("began",touch,event) end
    end,cc.Handler.EVENT_TOUCH_BEGAN)
    
    listener1:registerScriptHandler(function (touch ,event) 
        if func ~= nil then  func("move",touch,event) end
    end,cc.Handler.EVENT_TOUCH_MOVED)
    
    listener1:registerScriptHandler(function (touch ,event) 
        if func ~= nil then  func("end",touch,event) end
    end,cc.Handler.EVENT_TOUCH_ENDED)
    
    local eventDispatcher = node:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener1,node)
end


local function setPosOffset(node, offset)
    local x = node:getPositionX()
    local y = node:getPositionY()
    node:setPosition(x + offset.x, y + offset.y)
end


local handlerEx = function(obj, method, paras)
    -- print("handlerEx ...", method)
    return function(...)
        -- print(method)
        return method(obj, paras, ...)
    end
end

local import2 = function (moduleName, currentModuleName)
    local currentModuleNameParts
    local moduleFullName = moduleName
    local offset = 1

    while true do
        if string.byte(moduleName, offset) ~= 46 then -- .
            moduleFullName = string.sub(moduleName, offset)
            if currentModuleNameParts and #currentModuleNameParts > 0 then
                moduleFullName = table.concat(currentModuleNameParts, ".") .. "." .. moduleFullName
            end
            break
        end
        offset = offset + 1

        if not currentModuleNameParts then
            if not currentModuleName then
                local n,v = debug.getlocal(3, 1)
                currentModuleName = v
            end

            currentModuleNameParts = string.split(currentModuleName, ".")
        end
        table.remove(currentModuleNameParts, #currentModuleNameParts)
    end

    return require2(moduleFullName)
end


function test:reloadDescTbl()
    local descTbl = {
        -- 第1行 第1列 描述 功能
        -- {1,1,"关闭页面", closefunc},
        -- {1,3,"主大厅", handler(self, self.testMainGame)},
        -- {1,4,"重载牛牛", handler(self, self.reloadNiuNiu)},
        -- {1,5,"牛牛测试", handler(self, self.testNNGame)},
        -- {1,6,"重载龙虎斗", handler(self, self.reloadLHD)},
        -- {1,7,"龙虎斗测试", handler(self, self.testLHDGame)},
        -- {1,8,"重载百人炸金花", handler(self, self.reloadBRGame)},
        -- {1,9,"百人炸金花测试", handler(self, self.testBRGame)},
        -- {1,10,"重载百人牛牛", handler(self, self.reloadBRNNGame)},
        -- {1,11,"百人牛牛测试", handler(self, self.testBRNNGame)},
        -- {1,12,"重载炸金花", handler(self, self.reloadZJH)},
        -- {1,13,"炸金花测试", handler(self, self.testZJHGame)},
        {1,2,"进入百家乐桌子", handler(self, self.testBaccaratGame)},
        {1,3,"百家乐洗牌动画", handler(self, self.testBaccaratShuffleAnim)},
        {1,4,"百家乐洗牌投票", handler(self, self.testBaccaratShuffleVoteView)},
        {1,5,"百家乐页面函数", handler(self, self.testBaccaratSeat)},
        {1,6,"百家乐测试函数", handler(self, self.testBaccaratGameTestFunc)},
        {1,7,"重载百家乐", handler(self, self.reloadBaccaratGame)},
        -- {2,1,"MessageBox", handler(self, self.testMessageBoxLayer)},
        -- {2,2,"邮箱页面", handler(self, self.testMailView)},
        -- {2,3,"个人中心", handler(self, self.testPersonView)},
        -- {2,4,"客服弹窗页面", handler(self, self.testAgencyAlertView)},
        -- {2,5,"绑定手机页面", handler(self, self.testChangePwdLayer)},
        -- {2,6,"规则页面", handler(self, self.testRuleLayer)},
        -- {2,7,"周返现", handler(self, self.testRetMoneyLayer)},
        -- {2,8,"头像框背包", handler(self, self.testTxkBagView)},
        -- {2,9,"头像框购买", handler(self, self.testTxkBuyView)},
        {2,1,"设置与反馈", handlerEx(self, self.testCommonUI, {uiName = "settinghelp"})},
        {2,2,"房间内个人信息页面", handlerEx(self, self.testCommonUI, {uiName="roomprofile"})},
        {2,3,"大厅个人信息页面", handlerEx(self, self.testCommonUI, {uiName = "profileview"})},
        {2,4,"SeatClock页面", handlerEx(self, self.testCommonUI, {uiName = "seatClock"})},
        {2,5,"聊天页面", handlerEx(self, self.testCommonUI, {uiName = "chatPanel"})},
        {2,6,"百人场无座玩家页面", handlerEx(self, self.testCommonUI, {uiName = "noSeatLayer"})},
        
        {2,7,"倒计时", handlerEx(self, self.testCommonUI, {uiName = "seatAlarmClock"})},

        {3,1,"测试函数", handler(self, self.testFunc)},
    }
    self.descTbl = descTbl 
end


print("enter in test")
function test:onKeyPressed(code, event)
    -- print(" ++++ code >?>>>>>", code)
    self:reloadDescTbl()
    if (cc.KeyCode.KEY_F2 == code) then
        self:testCheatDebug()
    elseif (cc.KeyCode.KEY_F3 == code) then --测试gameUI功能
        require2("src.test")
    elseif (cc.KeyCode.KEY_F4 == code) then --使用上一轮使用的测试函数
        require2("src.test")
        self:testLastFunc()
    elseif (cc.KeyCode.KEY_Q == code) then --测试gameUI功能
        -- body
        -- self:testSettingLayer()
    elseif (cc.KeyCode.KEY_W == code) then --测试gameUI功能
        -- self:goToLoginLayer()
    elseif (cc.KeyCode.KEY_E == code) then --测试登陆界面ui
        -- testLoginFunc()
    elseif (cc.KeyCode.KEY_F3 == code) then --暂无

    elseif (cc.KeyCode.KEY_F4 == code) then --重连游戏
        -- self:testShopReview()
        -- testEnterGame()
    elseif (cc.KeyCode.KEY_F5 == code) then --登陆界面
        -- testLoginRoom()
    elseif (cc.KeyCode.KEY_F6 == code) then --登陆界面
        -- reconnectLoginRoom()
    elseif (cc.KeyCode.KEY_P == code) then --解散
        -- self:testAutoDismiss()
    elseif (cc.KeyCode.KEY_B == code) then
        -- self:backToBackGround()
        -- testBackLobby()
    elseif (cc.KeyCode.KEY_C == code) then --加入房间
        -- testJoinRoom()
    elseif (cc.KeyCode.KEY_V == code) then --创建房间
        -- self:testCreateRoom()
    elseif (cc.KeyCode.KEY_A == code) then --房间一键准备
        -- self:testPrepare()
    elseif (cc.KeyCode.KEY_R == code) then --一键注册
        -- self:autoRegister()
    elseif (cc.KeyCode.KEY_O == code) then --清空资源
        -- self:clearRecordLog()    
    elseif (cc.KeyCode.KEY_L == code) then --清空资源
        -- self:showLog()
--        self:showDebugView()
    elseif (cc.KeyCode.KEY_Y == code) then --测试函数
        self:test2Func()
    elseif (cc.KeyCode.KEY_Z == code) then --测试大厅中的单独UI功能
        -- self:testLayer()
    elseif (cc.KeyCode.KEY_S == code) then --初始化操作
    elseif (cc.KeyCode.KEY_G == code) then --进入某个游戏
        -- ModuleManager:removeExistView()
        -- self:testLogin()
        -- self:testMainGame()
        -- self:testZJHHallView()
        -- cc.Director:getInstance():endToLua()
        -- self:testGlobalView()
        -- self:backToBackGround()
    end
end

function test:initMainLoop( ... )
    self.mmid = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function ( ... )
        if FetchConsoleCmd then
            local string = FetchConsoleCmd()
            if string then
                local cmd = loadstring(string)
                if cmd  then
                    xpcall(cmd, __G__TRACKBACK__)
                end
            end
        end
    end, 1, false)
end

local function unLoadPackage(tbl)
    for i, v in ipairs(tbl) do
        package.loaded[v] = nil
    end    
end
local _require = require
function require2( ... )
    print("require2 ", ...)
    package.loaded[...] = nil
    return _require(...)
end

_G.require2 = require2
local accTbl = {
    {"QQQ001", "111111"},
    {"QQQ002", "111111"},
    {"QQQ003", "111111"},
    {"QQQ004", "111111"},
}

local C_Director = cc.Director:getInstance()
local C_WinSize = cc.Director:getInstance():getWinSize()
function test:init()
    local function onKeyCallback(code, event)
        print("code")
        self:onKeyPressed(code, event)
    end
    local keyListener = cc.EventListenerKeyboard:create()
    keyListener:registerScriptHandler(onKeyCallback, 12)
    local eventDispatcher = cc.Director:getInstance():getEventDispatcher()
    eventDispatcher:removeEventListenersForType(3);
    eventDispatcher:addEventListenerWithFixedPriority(keyListener, 1)
end
    
function test:showDebugView()
    local scene = C_Director:getRunningScene()
    local colorLayer = cc.LayerColor:create(cc.c4b(0, 0, 0, 50))
    scene:addChild(colorLayer)
    local btn = ccui.Button:create()
    dump(btn:getContentSize())
    dump(btn:getSize())
    dump(btn:getPosition3D())
    btn:setTitleText("ABC")
    btn:setContentSize(cc.size(100, 100))
    btn:setSize(cc.size(100, 100))
    btn:setPosition(cc.p(100, 100))
    btn:setTitleFontSize(30)
    dump(btn:getContentSize())
    dump(btn:getSize())
    dump(btn:getPosition3D())
    colorLayer:addChild(btn)
    local scrollview = ccui.ScrollView:create()
    scrollview:setContentSize(cc.size(display.height, display.width/2))
    scrollview:setPosition(cc.p(100, 100))
    colorLayer:addChild(scrollview)
end

local function filter_spec_chars(s)
    
end

function test:reloadNNGame()
    self:unloadGames("game_niuniu")
    require("src.games." .. "game_niuniu" .. "." .. "init")
end

--这个是扎金牛
function test:testZJNGame()
    self:_testGame("game_zhajinniu", "zhajinniugame", "init")
end

function test:testZJNGame2()
    ModuleManager.zhajinniugame.view:test()
end

--水果机
function test:testFruitMachine()
    self:_testGame("game_fruitmachine", "fruitMachineGame", "init")
end

--消消乐
function test:testXiaoxiaole()
    if LayerManager.XiaoXiaoLeLayer then
        for i, v in ipairs(LayerManager.XiaoXiaoLeLayer:getChildren()) do
            v:removeFromParent(true)
        end
    end
    if ModuleManager and ModuleManager.xiaoXiaoLeGame then
        ModuleManager.xiaoXiaoLeGame.view = nil
    end
    self:_testGame("game_xiaoxiaole", "xiaoXiaoLeGame", "init")
    -- self:testArmature2()
end

function test:testSolitaire()
    -- body
    -- if LayerManager.SolitaireLayer then
    --     for i, v in ipairs(LayerManager.SolitaireLayer:getChildren()) do
    --         v:removeFromParent(true)
    --     end
    -- end
    -- if ModuleManager and ModuleManager.solitaireGame then
    --     ModuleManager.solitaireGame.view = nil
    -- end

    if LayerManager.SolitaireLayer then
        for i, v in ipairs(LayerManager.SolitaireLayer:getChildren()) do
            v:removeFromParent(true)
        end
    end
    if ModuleManager and ModuleManager.solitaireGame then
        ModuleManager.solitaireGame.view = nil
    end
    self:_testGame("game_solitaire", "solitaireGame", "init")
end

function test:_testGame(path, controller, initPath, bReload)
    if bReload then
        if ModuleManager[controller].view then
            print("当前的 RELOAD VIEW 依然存在 请退到大厅后 再进行reload")
            self:testMainGame()
            Util:runOnce(0.1, function ( ... )
                self:_testGame(path, controller, initPath, true)
            end)
            return 
        end
    end

    if bReload then
    else
        ModuleManager:removeExistView()
    end
    if ModuleManager[controller] then
        ModuleManager[controller]:remove()
    end
    self:unloadGames(path)
    -- print("asfdasdrqwerzxcv")
    require("src.games." .. path .. "." .. initPath)
    -- print("zxcvasdfqwer")
    if bReload then
    else
        ModuleManager[controller]:show()
        -- print(">>>>>>>>>", ModuleManager[controller].view)
        -- print(">>>>>>>>>", ModuleManager[controller].view.test)
        if ModuleManager[controller].view and ModuleManager[controller].view.test then
            ModuleManager[controller].view:test()
        end
    end
end

function test:_testLayer4(path, paras)
    local view = require2(path)
    local _view = view.new(paras)
    _view:show(paras)
end

--1. 对root 节点进行全删除
--2. 对root 节点进行查找指定节点 然后进行自删除
--3. 对root 节点进行查找指定节点 然后调用对应的节点方法 进行删除
function test:_testLayer(path)
    ModuleManager:removeExistView()
    local moduleLayer = require2(path)
    local root = moduleLayer:getRoot()
    --只是简单的去掉而已 不调用对应节点的关闭方法
    for i, v in ipairs(root:getChildren()) do
        if v.__cname == moduleLayer.__cname then
            v:removeFromParent(true)
        end
    end
    local moduleView = moduleLayer.new()
    return moduleView
end

function test:_testLayer2(path)
    local moduleLayer =  require2(path)
    local root = moduleLayer:getRoot()
    root:removeAllChildren()
    local moduleView = moduleLayer.new()
    return moduleView
end

function test:_testLayer3(path, closefunc)
    local moduleLayer =  require2(path)
    local root = moduleLayer:getRoot()
    --只是简单的去掉而已 不调用对应节点的关闭方法
    for i, v in ipairs(root:getChildren()) do
        if v.__cname == moduleLayer.__cname then
            if closefunc then
                v[closefunc]()
            else
                if v.super.__cname == "View" then
                    v:removeFromParent(true)
                elseif v.super.__cname == "PopupWindow" then
                    v:close()
                end      
            end
        end
    end
    local moduleView = moduleLayer.new()
    return moduleView
end

function  test:testChangePwdLayer( ... )
    CommonWidget.ComboList = require2("src.modules.common.widget.comboList")
    local ChangePwd = require2("src.modules.common.changePwd.ReviewChangePwdView")
    local paras = {actType = 1, showType = 6}
    local changePwdView = ChangePwd.new(paras)
    changePwdView:show(paras)
end

function  test:goToLoginLayer()
    print("goToLoginLauer>>>>>")
    qf.event:dispatchEvent(ET.LOGIN_WAIT_EVENT,{method="show",txt=GameTxt.main001})
    cc.UserDefault:getInstance():setStringForKey(SKEY.LOGIN_TYPE, VAR_LOGIN_TYPE_NO_LOGIN)
    cc.UserDefault:getInstance():setStringForKey("loginBody", "")
    cc.UserDefault:getInstance():flush()
    qf.event:dispatchEvent(ET.GLOBAL_CANCELLATION)

    -- PopupManager:removeAllPopup()
    -- ModuleManager:removeByCancellation()
    -- game.cancellationLogin()
end

function test:testAgreementLayer() --测试协议页面
    -- local layer = require2("src.modules.common.agreement.NewAgreementView")
    -- local layerView = layer.new()
    -- layerView:show()

    qf.event:dispatchEvent(ET.AGREEMENT, {cb = function ()
        -- self.root:setVisible(true)
    end})

end

function test:testGlobalToast()
    qf.event:dispatchEvent(ET.GLOBAL_TOAST, {txt = "1212sfsfd"})
end

function test:testProto()
    -- qf.event:dispatchEvent(ET.GLOBAL_TOAST,{txt = "123123123123"})
    local body = {}
    local key = "bg+t%je3i0wd=9%@p@=-miicg&1!%4#n"
    body.phone = "18620999580"
    body.code = "1231"
    body.zone = "86"
    body.sign = QNative:shareInstance():md5(key.."|"..body.phone.."|"..body.code.."|"..body.zone)
    body.new_password = "2323412"
    GameNet:send({cmd=CMD.SAFE_CHANGE_PASSWORD,body=body,timeout=nil,callback=function(rsp)
        loga("changed safeBox pwd rsp "..rsp.ret)
        if rsp.ret ~= 0 then
            qf.event:dispatchEvent(ET.GLOBAL_TOAST,{txt = Cache.Config._errorMsg[rsp.ret]})
            -- qf.event:dispatchEvent(ET.GLOBAL_TOAST,{txt = "设置安全密码失败"})
        else
            -- qf.event:dispatchEvent(ET.GLOBAL_TOAST,{txt = "设置安全密码成功"})
        end
    end})
end

function test:testArmature()

    local armatureDataManager = ccs.ArmatureDataManager:getInstance()
    armatureDataManager:addArmatureFileInfo(XXLRes.greatEfx)
    local turnicon = ccs.Armature:create("duihuan")
    self.exchangeBtn:addChild(turnicon, 0)
    turnicon:setPosition(self.shopBtn:getContentSize().width * 0.5, self.shopBtn:getContentSize().height * 0.5)
    turnicon:getAnimation():playWithIndex(0)

    -- LayerManager.PopupLayer:addChild(resultLayer)
end
function test:testArmature2()
    local armatureDataManager = ccs.ArmatureDataManager:getInstance()
    local res = "game_xiaoxiaole/armature_anim/great/great.ExportJson"
    armatureDataManager:addArmatureFileInfo(res)
    local name = "great"
    local face = ccs.Armature:create(name)
    face:getAnimation():playWithIndex(0)
    LayerManager.XiaoXiaoLeLayer:addChild(face)
    -- ModuleManager
end

function testJson()
    local tbl = {a = 1, b = 2}
    for i = 1, 300 do
        tbl[i] = i 
    end
    local jStr = json.encode(tbl)
    io.writefile("jsontest.json", jStr)
end

local function checkLuaFile(fname)
    return string.find(fname, ".lua")
end

local function attrdir(path)
    local fileList = {}
    local _attrdir
    _attrdir = function (_path)
        for file in lfs.dir(_path) do
            if file ~= "." and file ~= ".." then
                local f = _path.. '/' ..file
                local attr = lfs.attributes (f)
                if attr.mode == "directory" then
                    _attrdir(f)--如果是目录，则进行递归调用
                else
                    if checkLuaFile(file) then
                        fileList[#fileList + 1] = _path ..  '/' .. file
                    end
                end
            end
        end
    end
    _attrdir(path)
    return fileList
end


function test:unloadGames(path)
    print("unloadGames")
    local filelist = attrdir("../src/games/" .. path)
    print("1234123421341234")
    dump(filelist)
    function require2( ... )
        package.loaded[...] = nil
        return require(...)
    end

    for i, v in ipairs(filelist) do
        local iSrt = string.find(v, "src")
        local filepath = string.sub(v, iSrt, -5)
        filepath = string.gsub(filepath, "/", ".")
        print("filepath >>>>>>>>>>>>>>>>>", filepath)
        package.loaded[filepath] = nil
    end
end
print(">>>>>>>>> testinit")
test:init()

function test:readFile(fileName)
    print(">>>>>>>>>>>>>>>>>", fileName)
    local str = ""
    if io.exists(fileName) then
        local file = io.open(fileName, "r")
        for line in file:lines() do  
            str = str..line
        end
        file:close()
    end
    return str
end

function test:writeFile(str, filename, mode)
    local file = io.open(filename, mode or "a")
    file:write(str)
    file:close()
end

function test:autoLogin(loginDel)
    self._loginDel = loginDel
    if cc.PLATFORM_OS_WINDOWS == G_Platform and test._autoLoginFlag then
        local idx = checknumber(test.getCurPlayerAccIdx())
        if idx > #accTbl then
            idx = 1
        elseif idx == 0 then
            idx = 1
        end
        loginDel.studio.EditBox_Acc:setText(accTbl[idx][1])
        loginDel.studio.EditBox_Pwd:setText(accTbl[idx][2])
        if idx >= #accTbl then
            idx = 1
        else
            idx = idx + 1
        end
        test.setCurPlayerAccIdx(idx)
        performWithDelay(loginDel, function ()
            loginDel:doButtonLoginClick()
        end, 0.01)
        test._autoLoginFlag = false
    end
end

function test:showLog()
    if qf.device.platform ==  "windows" then
        self:showLogTxt()
    else
        self:showDebugView()
    end
end

function test:showLogTxt()
    local file = self.logPath .. self.logFileName
    os.execute("cmd /c" .. file)
end

function test:testVertifyCode()
    -- local del  = LayerManager.PopupLayer
    -- local del  = C_Director:getRunningScene()
    local del  = LayerManager.Global
    local codeLayer = del:getChildByName("vertifyCodeLayer")
    if codeLayer and tolua.isnull(codeLayer) == false then
        print("remove codeLayer")
        codeLayer:removeFromParent()
    end
    print("qwerqwerxcvasdfqwer")
    local scene = C_Director:getRunningScene()
    local colorLayer = cc.LayerColor:create(cc.c4b(0, 0, 0, 255))
    colorLayer:setContentSize(cc.size(C_WinSize.width, C_WinSize.height))
    colorLayer:setName("vertifyCodeLayer")
    colorLayer:setOpacity(255)
    del:addChild(colorLayer, 9999)

    local btn = ccui.Button:create("res/cn/ui/global/close.png","","")

    --必须放一个图片上去
    btn:setContentSize(cc.size(100, 100))
    btn:setSize(cc.size(100, 100))
    btn:setPosition(cc.p(C_WinSize.width- 100, C_WinSize.height - 100))
    btn:setTitleFontSize(30)
    btn:setTouchEnabled(true)
    btn:setEnabled(true)
    colorLayer:addChild(btn)
    addButtonEvent(btn, function ()
        local codeLayer = del:getChildByName("vertifyCodeLayer")
        if codeLayer and tolua.isnull(codeLayer) == false then
            codeLayer:removeFromParent()
        end
    end)
    local str = "独步成双一见双雕"
    local r = math.random
    local rColor = function()
        return cc.c3b(r(0,255), r(0,255), r(0,255))
    end
    local rfColor = function ( ... )
        return cc.c4f(math.random(),math.random(),math.random(),1)
    end
    local rPos = function ()
        return cc.p(r(100, C_WinSize.width-100), r(100, C_WinSize.height-100))
    end
    local list = string.utf8List(str)
    for i, v in ipairs(list) do
        local text= ccui.Text:create(v, GameRes.font1,50)
        text:setRotation(r(0, 360))
        text:setColor(rColor())
        colorLayer:addChild(text)
        text:setPosition(rPos())
        text:setTouchEnabled(true)
        addButtonEvent(text, function ( ... )
            print(">>>>>>>>>>>>>>>", v)
        end)
    end

    --颜色必须用浮点型来使用 不然没有效果
    local drawNode = cc.DrawNode:create();
    drawNode:setPosition(cc.p(0,0))
    drawNode:setAnchorPoint(0,0)
    for i = 1, 10 do
        drawNode:drawSegment(rPos(), rPos(), r(1, 2), rfColor())
        drawNode:drawDot(rPos(), r(3, 5), rfColor())
    end
    colorLayer:addChild(drawNode)

    addNormalTouchEvent(colorLayer, function(method, touch, event)
        if method == "began" then
            return true
        end
    end)
end

--切后台
function test:backToBackGround()
    print("backtoBackGround")
    if self._backGround == "hide" then
        self._backGround = "show"
    else
        self._backGround = "hide"
    end
    --     if PopupManager:getPopupWindow(PopupManager.POPUPWINDOW.newShop) then
    --     return
    -- end
    qf.event:dispatchEvent(ET.APPLICATION_ACTIONS_EVENT,{type=self._backGround})
end

function test:testWaitEvent()
    qf.event:dispatchEvent(ET.GLOBAL_WAIT_EVENT,{method="hide"})
    qf.event:dispatchEvent(ET.GLOBAL_WAIT_EVENT,{method="show",txt=Util:getRandomMotto(), offset ={x=-400}})
end

function test:testChangePortraitOrLandScape()
    print(cc.GLViewProtocol)
    dump(cc.GLViewProtocol)
    local glView = cc.Director:getInstance():getOpenGLView()
    local policy = glView:getResolutionPolicy()
    local designSize = glView:getDesignResolutionSize()

    local frameSize = glView:getFrameSize()
    if true then
        glView:setFrameSize(frameSize.height, frameSize.width)
    end

    glView:setDesignResolutionSize(designSize.width, designSize.height, policy)

end

function test:testScheduler( ... )
    local scheduler = cc.Director:getInstance():getScheduler()
    scheduler:scheduleScriptFunc(
        function ()
            print("66666")
        end,
    1, true)
end

function test:testdiv( ... )
    local a = 1
    print(1/nil)
    print(nil/1)
end

function test:check2Signs(content)
    local s1 = string.find(content, "%%")
    print(">>>>s1,", s1)
    if s1 == -1 or s1 == nil then
        return false
    end
    local content2 = string.sub(content, s1+1, -1)
    -- print("content >>>>", content)
    -- print("content2 >>>>", content2)
    local s2 = string.find(content2, "%%")
    if s2 == -1 or s2 == nil then
        return false
    end
    return s1, s1  + s2
end

function test:testFunc( ... )
    -- self:testIrregularShapeClickEvent()
    -- print("zxvczxcvasdf")
    print(json.encode(g.vars.user))
end

function test:testFormatBigInt()
    g.util.func = require2("src.app.util.functions")
    local sum = 1
    for i = 1, 10 do
        sum = sum * 10
        print(sum)
        print(g.util.func.formatBigInt(sum, 3))
    end
    print(g.util.func.formatBigInt(2500000, 3))
end


function test:testCommonTipView( ... )
end

function test:testJsonXpcall( ... )
    xpcall(
        function()
            local s = self:testFunc()
        end,
        function() 
            print("sdfas123123fdqwer")
        end
    )
    print("sadfasdfasdf")
end

function test:testfilter()
end

function test:testLogin()
end

function test:testCoroutine( ... )
end

function test:testGlobalView()
end
local key_name = "last_choice"
function test:getLastChoiceTbl()
    local jStr = cc.UserDefault:getInstance():getStringForKey(key_name, "")
    local lastTbl = {}
    local tbl = {}
    if jStr ~= "" then
        tbl = json.decode(jStr)
    end
    -- dump(tbl)
    for _, name in ipairs(tbl) do
        for _, v in ipairs(self.descTbl) do
            if v[3] == name then
                lastTbl[#lastTbl + 1] = v
                break
            end
        end
    end
    -- dump(lastTbl)
    return lastTbl
end


function test:testCheatDebug( ... )
    local color = cc.c4b(0, 0, 0, 255)
    local args = {color = color}
    local colorLayer = self:createGLtestLayer(255, args)


    local lastPos = nil
    local diffX = 0
    addNormalTouchEvent(colorLayer, function ( method, touch, event )
        if method == "began" then
            lastPos = touch:getLocation()
            return true
        elseif method == "move" then
            movedPos = touch:getLocation()
            local tempDiffX = diffX + (movedPos.x - lastPos.x)
            if tempDiffX > 0 then
            else
                for i, v in ipairs(colorLayer:getChildren()) do
                    setPosOffset(v, cc.p(movedPos.x - lastPos.x, 0))
                end
                diffX = tempDiffX
            end
            lastPos = movedPos
        elseif method == "end" then
        end
    end)

    local hideGameFunc = function ( ... )
        for i, v in ipairs(colorLayer:getChildren()) do
            v:setVisible(false)
        end
        colorLayer:getEventDispatcher():removeEventListenersForTarget(colorLayer)
        addNormalTouchEvent(colorLayer, function ( method, touch, event )
            if method == "began" then
                return true
            end

            if method == "end" then
                local location = touch:getLocation()
                -- dump(location)
                local diff = 100
                if ((math.abs(location.x - C_WinSize.width/2) < diff) and  (math.abs(location.y - C_WinSize.height/2) < diff)) then
                    colorLayer:removeFromParent()
                end
            end
        end)
    end
    local ROW, COL = 7, 10
    local uWidth, uHeight = C_WinSize.width/COL, C_WinSize.height/ROW

    local r = math.random
    local closefunc = function ()
        if colorLayer and tolua.isnull(colorLayer) ==  false then
            colorLayer:removeFromParent()
        end
    end

    local cheatOnNumber = 3
    for i = 1, cheatOnNumber do
        if self["cheatOn" .. i] == nil then
            self["cheatOn" .. i] = true
        end
    end
    local getDebugDesc = function (cheatOnIdx)
        local tbl = {
            {"开启debug", "关闭debug"},
            {"开启提示", "关闭提示"},
            {"开启自动", "关闭自动"},
        }
        local ret = tbl[cheatOnIdx]
        return self["cheatOn" .. cheatOnIdx] and ret[1] or ret[2] 
    end

    local debugFunc = function (cheatOnIdx)
        return function (sender)
            self["cheatOn" .. cheatOnIdx] = not self["cheatOn" .. cheatOnIdx]
            sender:getChildByName("text"):setString(getDebugDesc(cheatOnIdx))
        end
    end
    local descTbl = self.descTbl

    local max_num = 5

    local saveLastChoiceTbl = function (name) 
        local jStr = cc.UserDefault:getInstance():getStringForKey(key_name, "")
        local lastTbl = {}
        local tbl = {}
        if jStr ~= "" then
            tbl = json.decode(jStr)
        end
        local iFind
        for i, v in ipairs(tbl) do
            if v == name then
                iFind = i
                break
            end
        end

        if iFind then
            table.remove( tbl, iFind)
            table.insert(tbl, 1, name)
        else
            table.insert(tbl, 1, name)
        end
        local jStr = json.encode(tbl)
        cc.UserDefault:getInstance():setStringForKey(key_name, jStr)
    end

    local addBlock = function (v, pos)
        local j, i, txt, func, bNotClose = unpack(v)
        local color = cc.c3b(r(0,255), r(0,255), r(0,255))
        local layout = self:getLayout({size = cc.size(uWidth,uHeight), ap = cc.p(0,0), color = color, pos = pos, func = function (layout)
            if func then
                func(layout)
            end
            if not bNotClose then
                closefunc()
            end            
            -- print("txt>>>", txt)
            saveLastChoiceTbl(txt)
        end, text = txt, ftAdapt = true})
        colorLayer:addChild(layout)
    end
    for _,v in ipairs(descTbl) do
        local j, i, txt, func, bClose = unpack(v)
        addBlock(v, cc.p(uWidth*(i-1), uHeight*(ROW -j))) 
    end

    local LastTbl = self:getLastChoiceTbl()

    for i, v in ipairs(LastTbl) do
        print("asdf", i)
        if i > max_num then
            break
        end
        addBlock(v, cc.p(uWidth*(i-1), 0))
    end
end

function test:testLastFunc()
    local LastTbl =  self:getLastChoiceTbl()

    if LastTbl and LastTbl[1] then
        local j, i, txt, func, bNotClose = unpack(LastTbl[1])
        if func then
            print("func >>>>>", func)
            func(layout)
        end
        if not bNotClose then
            local del = cc.Director:getInstance():getRunningScene()
            local codeLayer = del:getChildByName("GLLayer")
            if codeLayer and tolua.isnull(codeLayer) == false then
                codeLayer:removeFromParent()
            end
        end
    end
end

function test:createGLtestLayer(opa, args)
    local del = cc.Director:getInstance():getRunningScene()
    -- local del  = LayerManager.Global
    local codeLayer = del:getChildByName("GLLayer")
    if codeLayer and tolua.isnull(codeLayer) == false then
        codeLayer:removeFromParent()
    end
    del:setLocalZOrder(99009)
    local color = cc.c4b(255, 255, 255, 255)
    if args then
        color = args.color
    end
    local colorLayer = cc.LayerColor:create(color)
    colorLayer:setContentSize(cc.size(C_WinSize.width, C_WinSize.height))
    colorLayer:setName("GLLayer")
    opa = opa or 255
    colorLayer:setOpacity(opa)
    del:addChild(colorLayer, 9999)

    local btn = ccui.Text:create("close", "", 50)
    btn:setPosition(cc.p(C_WinSize.width- 100, C_WinSize.height - 100))
    btn:setEnabled(true)
    btn:setTouchEnabled(true)
    btn:setColor(cc.c3b(255,0,0))
    colorLayer:addChild(btn, 999999)
    addButtonEvent(btn, function ()
        local codeLayer = del:getChildByName("GLLayer")
        if codeLayer and tolua.isnull(codeLayer) == false then
            codeLayer:removeFromParent()
        end
    end)
    return colorLayer
end

function test:getLayout(args)
    local size = args.size or cc.size(100,100)
    local color = args.color or cc.c3b(255,0,0)
    local pos = args.pos or cc.p(0,0)
    local ap = args.ap or cc.p(0.5,0.5)  
    local opa = args.opa or 255
    local text = args.text

    local layout = ccui.Layout:create()
    layout:setAnchorPoint(ap)
    layout:setClippingEnabled(false)
    layout:setContentSize(size)
    layout:setBackGroundColor(color)
    layout:setPosition(pos)
    layout:setBackGroundColorType(ccui.LayoutBackGroundColorType.solid)
    layout:setBackGroundColorOpacity(opa)
    if args and args.func then
        addButtonEvent(layout, function ( ... )
            if args and args.func then
                args.func(layout) 
            end
        end)
        if layout.setEnabled then
            layout:setEnabled(true)
        end
        if layout.setTouchEnabled then
            layout:setTouchEnabled(true)
        end
    end
    if text then
        local fontSize = args.ftSize or 40
        local fontAdapt = args.ftAdapt
        local textUI = ccui.Text:create(text, "", 40)
        textUI:setName("text")
        textUI:setPosition3D(cc.p(size.width/2, size.height/2))
        textUI:setColor(cc.c3b(255-color.r, 255-color.g, 255-color.b))
        layout:addChild(textUI)
        local textSize =textUI:getContentSize()
        -- dump(textSize)
        if fontAdapt then
            local xScale = size.width / textSize.width
            local yScale = size.height / textSize.height
            local scale = xScale < yScale and xScale or yScale
            textUI:setScale(scale)
        end
    end
    return layout
end

function test:testCommonUI(paras, ab)
    local commonUI = require2("src.test.testCommonUI")
    if paras then
        if paras.uiName == "seatClock" then
            commonUI:testSeatClockView()
        elseif paras.uiName == "chatPanel" then
            commonUI:testChatPanel()
        elseif paras.uiName == "noSeatLayer" then
            commonUI:testNoseatLayer()()
        elseif paras.uiName == "settinghelp" then
            commonUI:testSettingAndHelpView()
        elseif paras.uiName == "roomprofile" then
            commonUI:testRoomProfileInfoView()
        elseif paras.uiName == "profileview" then
            commonUI:testProfileView()
        elseif paras.uiName == "seatAlarmClock" then
            commonUI:testSeatAlarmClock()
        end
    end
end

function test:testSettingAndHelpView()
    local SettingAndHelpView = require2("app.bean.setting.view.SettingAndHelpView")
    SettingAndHelpView.new():show()
end

function test:testBaccaratGame()
    self:loadBaccaratTexture()
    loadTexture("roomBase_tex.plist", "roomBase_tex.png")
	loadTexture("room_tex.plist", "room_tex.png")
	loadTexture("hundredRoom_tex.plist", "hundredRoom_tex.png")
    cc.Director:getInstance():getTextureCache():addImage("room_bg.jpg")
    local str = '{"regions":[{"minBet":1000,"regionId":1,"maxBet":10000000,"odds":95},{"minBet":1000,"regionId":2,"maxBet":10000000,"odds":100},{"minBet":1000,"regionId":3,"maxBet":4000000,"odds":800},{"minBet":1000,"regionId":4,"maxBet":4000000,"odds":1100},{"minBet":1000,"regionId":5,"maxBet":4000000,"odds":1100},{"minBet":1000,"regionId":6,"maxBet":1000000,"odds":1200}],"oddsCount":7,"odds":[95,100,800,1100,1100,1200,2000],"maxSeat":150,"betChips":[1000,10000,50000,100000,500000],"tableLevel":1,"players":[{"giftId":1103,"reserved":0,"playStatus":0,"userChips":11037260936,"seatId":5,"pic":"","gender":"f","avatarFrame":0,"uid":102972,"vip":3,"name":"102972","exp":27016}],"readyTime":5,"minBuyin":1000,"leftCardCount":365,"tableType":51,"maxBetChips":5000000,"betLevelCount":5,"classId":1,"leftNarrowTime":0,"playId":"1000-1588820289","regionCount":6,"playerCount":1,"leftBetTime":100,"multiple":0,"narrowTime":20,"tableName":"??????","potChips":0,"dealerId":3,"betTime":15,"totalPlayerCount":1,"tid":1000,"tableStatus":7}'
    g.vars.baccaratLoginResponse = json.decode(str)
    g.vars.baccaratLoginResponse.player = {}
    local packageRoot = g.app.packageRoot
    local _import = _G.import
    _G.import = import2
    require2('app.bean.baccaratRoom.view.BaccaratTableUIManager')
    require2(packageRoot .. ".scenes." .. "BaccaratScene")


    g.app:enterScene("BaccaratScene", {}, "fade", 0.5)

    _G.import = _import
end


function test:testBaccaratShuffleAnim()
    local layer = self:createGLtestLayer()
    local BaccaratShuffleAnim = require2("src.app.bean.baccaratRoom.view.BaccaratShuffleAnim")
	local anim = BaccaratShuffleAnim.new(nullFunc, {uid =  g.vars.user.uid})
		:pos(display.width/2, display.height/2)
        :addTo(layer, 100)
    anim:playShuffleAnim(3)
end


function test:testBaccaratShuffleVoteView()
    self:loadBaccaratTexture()
    local layer = self:createGLtestLayer()
    local view = require2("src.app.bean.baccaratRoom.view.BaccaratShuffleVoteView")
	local anim = view.new(true)
		:pos(display.width/2, display.height/2)
        :addTo(layer, 100)
end

function test:testBaccaratSeat()
    self:loadBaccaratTexture()
    local paras = {nil}
    local layer = self:createGLtestLayer()
    -- local view = require2("src.app.bean.baccaratRoom.view.BaccaratSeat")
    
    -- local config = require2("src.app.bean.baccaratRoom.view.BaccaratRegionConfig")
    -- local view = require2("src.app.bean.baccaratRoom.view.BaccaratRegion")
    -- paras = {1,1,}
    -- local view = require2("src.app.bean.baccaratRoom.view.BaccaratRuleView")

    
    local view = require2("src.app.bean.baccaratRoom.view.BaccaratResultView") 
    paras = {{selfTieWinDeltaChips = 1820000}, {gameResult = 0}, nullFunc}
    -- local view = require2("src.app.bean.baccaratRoom.view.BaccaratRoadDetailView")
    -- local view = require2("src.app.bean.baccaratRoom.view.BaccaratRoadInfoView")
    -- local view = require2("src.app.bean.baccaratRoom.view.BaccaratRoomMenu")

    -- require2("src.app.bean.baccaratRoom.view.RubCardLayer")
    -- local view = require2("src.app.bean.baccaratRoom.view.BaccaratMiCardView")
    -- paras = {
    --     {
    --         {cardCount=2,cardType=1, cards={67,29},taem=3},
    --         {cardCount=2,cardType=1, cards={39,25},taem=6}
    --     }, 
    --     2, 
    --     {
    --         canChange = 0, canFlop = 1, miCardUid = g.vars.user.uid, regionId=2
    --     },
    --     100
    -- }

    -- local view = require2("src.app.bean.baccaratRoom.view.BaccaratBetSlider")
    -- paras = {1000, 10000}


    local anim = view.new(unpack(paras))
		:pos(display.width/2, display.height/2)
        :addTo(layer, 100)
    -- anim:setMaxAndMin(10000000, 1000)

    -- 咪牌页面相关测试函数
    -- anim._isSelfMiCard = true
    -- anim:pos(0,0)
    -- anim:playShowAnim(false)
end

function test:testBaccaratGameTestFunc()
    self:testBaccaratGame()
    scheduler.performWithDelayGlobal(function()
        local scene = cc.Director:getInstance():getRunningScene()
        print("zxvczxcasdfwqer")
        if scene.name == "BaccaratScene" then
            -- 通知信息改变
            local tableUIManager = scene._tableUIManager
            -- g.vars.user.gender = "f"
            -- tableUIManager:_notiUserInfoUpdate()
            --自己下注
            -- self:testBaccaratMyBet(tableUIManager)
            -- 飞行筹码
            -- self:testBaccaratGameXiazhu(tableUIManager)
            -- 结束
            -- scheduler.performWithDelayGlobal(function() 
            --     self:testBaccaratGameGameEnd(tableUIManager)
            -- end, 2)
            -- 游戏开始
            -- self:testBaccaratGameStart(tableUIManager)
            -- print(tableUIManager.nodes.operateNode:isVisible())
            self:testBaccaratDealCard(tableUIManager)
            scene:performWithDelay(function() 
                tableUIManager._cardRegions[1]:turnOverOnePoker(56, 1)
                tableUIManager._cardRegions[1]:turnOverOnePoker(55, 2)
                tableUIManager._cardRegions[2]:turnOverOnePoker(52, 1)
                tableUIManager._cardRegions[2]:turnOverOnePoker(44, 2)
            end, 3)
            scene:performWithDelay(function() 
                self:testBaccaratDealCard2(tableUIManager)
            end, 5)
        end
	end, 0.7)
    
end


function test:testBaccaratGameXiazhu(tableUIManager)
    -- local str = '{"regions":[{"betChips":0,"totalBetChips":0,"regionId":1},{"betChips":1234000,"totalBetChips":1234000,"regionId":2},{"betChips":0,"totalBetChips":0,"regionId":3},{"betChips":0,"totalBetChips":0,"regionId":4},{"betChips":0,"totalBetChips":0,"regionId":5},{"betChips":0,"totalBetChips":0,"regionId":6}],"regionCount":6}'
    -- local str = '{"regions":[{"betChips":1234000,"totalBetChips":1234000,"regionId":1},{"betChips":1234000,"totalBetChips":1234000,"regionId":2},{"betChips":0,"totalBetChips":0,"regionId":3},{"betChips":0,"totalBetChips":0,"regionId":4},{"betChips":0,"totalBetChips":0,"regionId":5},{"betChips":0,"totalBetChips":0,"regionId":6}],"regionCount":6}'
    local str = '{"regions":[{"betChips":1234000,"totalBetChips":1234000,"regionId":1},{"betChips":1234000,"totalBetChips":1234000,"regionId":2},{"betChips":1234000,"totalBetChips":1234000,"regionId":3},{"betChips":1234000,"totalBetChips":1234000,"regionId":4},{"betChips":1234000,"totalBetChips":1234000,"regionId":5},{"betChips":1234000,"totalBetChips":1234000,"regionId":6}],"regionCount":6}'
    local evt = {data = json.decode(str)}
    tableUIManager:_onBaccaratNoSeatPlayerBet(evt)
end

function test:testBaccaratGameGameEnd(tableUIManager)
    local str = '{"regions":[{"playerCount":1,"odds":95,"isWin":1,"deltaChips":1721850,"lookerWinChips":0,"players":[{"betChips":883000,"uid":103137,"deltaChips":1721850}]},{"playerCount":0,"odds":100,"isWin":2,"deltaChips":0,"lookerWinChips":0,"players":{}},{"playerCount":0,"odds":800,"isWin":2,"deltaChips":0,"lookerWinChips":0,"players":{}},{"playerCount":0,"odds":1100,"isWin":2,"deltaChips":0,"lookerWinChips":0,"players":{}},{"playerCount":0,"odds":1100,"isWin":2,"deltaChips":0,"lookerWinChips":0,"players":{}},{"playerCount":0,"odds":1200,"isWin":2,"deltaChips":0,"lookerWinChips":0,"players":{}}],"playerCount":1,"maxWinPlayerCount":1,"players":[{"uid":103137,"displayId":5,"userChips":909196501,"deltaChips":838850,"playStatus":2}],"potChips":0,"regionCount":6,"maxWinPlayers":[{"pic":"","uid":103137,"gender":"f","name":"103137","winChips":838850}]}'
    -- local str = '{"regions":[{"playerCount":1,"odds":95,"isWin":2,"deltaChips":1721850,"lookerWinChips":0,"players":[{"betChips":883000,"uid":103137,"deltaChips":1721850}]},{"playerCount":0,"odds":100,"isWin":1,"deltaChips":0,"lookerWinChips":0,"players":{}},{"playerCount":0,"odds":800,"isWin":2,"deltaChips":0,"lookerWinChips":0,"players":{}},{"playerCount":0,"odds":1100,"isWin":2,"deltaChips":0,"lookerWinChips":0,"players":{}},{"playerCount":0,"odds":1100,"isWin":2,"deltaChips":0,"lookerWinChips":0,"players":{}},{"playerCount":0,"odds":1200,"isWin":2,"deltaChips":0,"lookerWinChips":0,"players":{}}],"playerCount":1,"maxWinPlayerCount":1,"players":[{"uid":103137,"displayId":5,"userChips":909196501,"deltaChips":838850,"playStatus":2}],"potChips":0,"regionCount":6,"maxWinPlayers":[{"pic":"","uid":103137,"gender":"f","name":"103137","winChips":838850}]}'
    local evt = {data = json.decode(str)}
    local str2 = '[{"cardType":1,"taem":3,"cardCount":3,"cards":[18,46,45]},{"cardType":1,"taem":3,"cardCount":3,"cards":[71,38,76]}]'
    tableUIManager._cardData = json.decode(str2)
    tableUIManager:_onBaccaratGameEnd(evt)
end

function test:testBaccaratGameStart(tableUIManager)
    local str = '{"playerCount":1,"totalPlayerCount":1,"players":[{"uid":103137,"userChips":902283351,"maxBetChips":902283351,"canStartVote":1,"multiple":0}],"leftCardCount":294,"playId":"1000-1589775737"}'
    local evt = {data = json.decode(str)}
    tableUIManager:_onBaccaratGameStart(evt)
end

function test:testBaccaratMyBet(tableUIManager)
    local str = '{"userTotalBet":1000000,"userChips":960183351,"betChips":1000000,"multiple":0,"seatId":5,"totalBet":1000000,"regionId":2,"maxBetChips":99000000,"uid":103137,"myBet":1000000}'
    local evt = {data = json.decode(str)}
    tableUIManager:_onBaccaratPlayerBet(evt)
end

function test:testBaccaratDealCard(tableUIManager)
    local str = '{"cardRegions":[{"cardType":1,"taem":5,"cardCount":2,"cards":[56,55]},{"cardType":1,"taem":4,"cardCount":2,"cards":[52,44]}],"leftCardCount":142,"cardRegionCount":2}'
    local evt = {data = json.decode(str)}
    tableUIManager:_onDealCard(evt)
end

function test:testBaccaratDealCard2(tableUIManager)
    local str = '{"cardRegions":[{"cardType":1,"taem":2,"cardCount":3,"cards":[77,50,78]},{"cardType":1,"taem":6,"cardCount":2,"cards":[61,22]}],"leftCardCount":390,"cardRegionCount":2}'
    local evt = {data = json.decode(str)}
    tableUIManager:_onDealCard(evt)
end



function test:loadBaccaratTexture()
    loadTexture("baccarat_road.plist", "baccarat_road.png")
    loadTexture("profile_tex.plist", "profile_tex.png")		
    loadTexture("card_tex.plist", "card_tex.png")
    loadTexture("room_tex.plist", "room_tex.png")
	loadTexture("roomBase_tex.plist", "roomBase_tex.png")
	loadTexture("baccarat_tex.plist", "baccarat_tex.png")
	loadTexture("baccarat_room_tex.plist", "baccarat_room_tex.png")
	loadTexture("baccarat_bet_chip.plist", "baccarat_bet_chip.png")
	loadTexture("baccarat_bet_tex.plist", "baccarat_bet_tex.png")
	loadTexture("baccarat_miCard_tex.plist", "baccarat_miCard_tex.png")
	loadTexture("baccarat_rule_tex.plist", "baccarat_rule_tex.png")
	loadTexture("large_card_tex.plist", "large_card_tex.png")
	loadArmatureTexture("DealerKiss", "armature/DealerKiss0.png", "armature/DealerKiss0.plist", "armature/DealerKiss.ExportJson")
	loadTexture("chatEmojiBubble_tex.plist", "chatEmojiBubble_tex.png")
    loadArmatureTexture("EmojiBubble", "emoji/05/EmojiBubble0.png", "emoji/05/EmojiBubble0.plist", "emoji/05/EmojiBubble.ExportJson")
end


function test:testIrregularShapeClickEvent()
    local testClick = require2("src.test.testClick")
    testClick:testIrregularShapeClickEvent()
end

function test:reloadBaccaratGame()
    local packageRoot = g.app.packageRoot
    local _import = _G.import
    _G.import = import2
    require2('app.bean.baccaratRoom.view.BaccaratTableUIManager')
    require2(packageRoot .. ".scenes." .. "BaccaratScene")
    _G.import = _import
end

function test:loadUserData()
    if g.vars.user == nil then
        -- local str = '{"loginKey":"b1ed8d80abc9bdbc61ab03cdda7ae4fc9348809c","newUser":0,"clientGuidingStep":0,"molSmsSwitch":1,"vpLevel":0,"localLogSwitch":0,"showWaterFestival":0,"guidePackageSwitch":0,"safeBoxChips":0,"flashSaleVersion":"","lotteryTimedSwitch":0,"enableMagic":1,"mttSwitch":0,"packageName":"com.flounder.nineke","lobbyBg":"","sumPaySwitch":0,"firstPayStageSwitch":1,"guideCodeLastTime":361030,"verName":"2.0.7.2","magicList":[{"magicId":1,"type":1,"order":"100","deltaLike":"2"},{"magicId":8,"type":1,"order":"105","deltaLike":"2"},{"magicId":3,"type":1,"order":"110","deltaLike":"-2"},{"magicId":13,"type":1,"order":"112","deltaLike":"2"},{"magicId":5,"type":1,"order":"113","deltaLike":"2"},{"magicId":11,"type":1,"order":"114","deltaLike":"-2"},{"magicId":12,"type":1,"order":"140","deltaLike":"-2"},{"magicId":4,"type":1,"order":"141","deltaLike":"-2"},{"magicId":19,"type":1,"order":"148","deltaLike":-2},{"magicId":20,"type":1,"order":"150","deltaLike":-2},{"magicId":16,"type":1,"order":"160","deltaLike":"-2"},{"magicId":10,"type":1,"order":"170","deltaLike":"-2"},{"magicId":101,"type":2,"order":10101,"deltaLike":0},{"magicId":102,"type":2,"order":10102,"deltaLike":0}],"baccaratSwitch":1,"novicePack":{"data":[{"status":1,"reward":"{\"chips\":10000,\"exp\":10}"},{"status":1,"reward":"{\"chips\":20000,\"magic\":10}"},{"status":0,"reward":"{\"chips\":30000,\"gem\":2}"}]},"rechargePacksInfo":{"enableJoin":1,"enablePop":0,"paymentId":2001,"channel":"BluePay","switch":"1","currency":"THB","chips":3000000,"name":"3M???","price":"5000"},"verCode":"217","name":"8531155","loginType":"device","giftId":"0","canGuideList":{"three":0,"texas":0,"two":0},"settingInfo":{"musicVolume":"70","version":"2.0.7.2","new":1,"soundVolume":"70","autoSeat":1,"url":"https:\/\/play.google.com\/store\/apps\/details?id=com.joyours.thai_nineke","track":1,"blindSound":1,"music":1,"slotsSound":"1","sound":1,"autoBuy":1,"name":"8531155","shake":1},"uid":8531155,"hasGuideReward":1,"cdn":"http:\/\/ninekecdn.th.joyours.com","ret":0,"like":"0","avatarFrame":0,"isChangeHeadPicPermited":true,"cocktailResources":{},"luckyOnePaySwitch":1,"pointExchangeRoot":"https:\/\/dbpri0d8pp767.cloudfront.net\/point_exchange\/dist\/index.html","wsproxy":[{"ip":"wss:\/\/httpsproxy.th.joyours.com\/fbninekesvrgame\/","port":443},{"ip":"wss:\/\/httpsproxy.th.joyours.com\/fbninekesvrgame\/","port":443}],"switchSongkran":0,"chatBubble":0,"enableLocalPay":0,"printSwitch":0,"minBetLimit":{"20000000":"1000","5000000":"200"},"hundredEnable":"1","LvlExpDic":[{"needExperience":15,"chips":0,"experience":0,"magic":0},{"needExperience":30,"chips":10000,"experience":15,"magic":0},{"needExperience":120,"chips":10000,"experience":45,"magic":0},{"needExperience":360,"chips":15000,"experience":165,"magic":0},{"needExperience":720,"chips":20000,"experience":525,"magic":10},{"needExperience":1200,"chips":30000,"experience":1245,"magic":0},{"needExperience":1300,"chips":30000,"experience":2445,"magic":0},{"needExperience":1500,"chips":30000,"experience":3745,"magic":10},{"needExperience":2000,"chips":30000,"experience":5245,"magic":0},{"needExperience":2500,"chips":50000,"experience":7245,"magic":10},{"needExperience":3000,"chips":50000,"experience":9745,"magic":0},{"needExperience":3500,"chips":50000,"experience":12745,"magic":0},{"needExperience":4000,"chips":50000,"experience":16245,"magic":0},{"needExperience":4500,"chips":50000,"experience":20245,"magic":0},{"needExperience":4800,"chips":50000,"experience":24745,"magic":15},{"needExperience":5000,"chips":50000,"experience":29545,"magic":0},{"needExperience":5200,"chips":50000,"experience":34545,"magic":0},{"needExperience":5300,"chips":50000,"experience":39745,"magic":0},{"needExperience":6000,"chips":50000,"experience":45045,"magic":0},{"needExperience":6500,"chips":80000,"experience":51045,"magic":20},{"needExperience":7000,"chips":80000,"experience":57545,"magic":0},{"needExperience":7500,"chips":80000,"experience":64545,"magic":0},{"needExperience":8000,"chips":80000,"experience":72045,"magic":0},{"needExperience":9000,"chips":80000,"experience":80045,"magic":0},{"needExperience":10000,"chips":80000,"experience":89045,"magic":25},{"needExperience":11000,"chips":80000,"experience":99045,"magic":0},{"needExperience":12000,"chips":80000,"experience":110045,"magic":0},{"needExperience":13000,"chips":80000,"experience":122045,"magic":0},{"needExperience":14000,"chips":80000,"experience":135045,"magic":0},{"needExperience":15000,"chips":100000,"experience":149045,"magic":30},{"needExperience":16000,"chips":100000,"experience":164045,"magic":0},{"needExperience":17000,"chips":100000,"experience":180045,"magic":0},{"needExperience":18000,"chips":100000,"experience":197045,"magic":0},{"needExperience":19000,"chips":100000,"experience":215045,"magic":0},{"needExperience":20000,"chips":100000,"experience":234045,"magic":30},{"needExperience":21000,"chips":200000,"experience":254045,"magic":0},{"needExperience":22000,"chips":200000,"experience":275045,"magic":0},{"needExperience":23000,"chips":200000,"experience":297045,"magic":0},{"needExperience":24000,"chips":200000,"experience":320045,"magic":0},{"needExperience":30000,"chips":200000,"experience":344045,"magic":30},{"needExperience":35000,"chips":300000,"experience":374045,"magic":0},{"needExperience":40000,"chips":300000,"experience":409045,"magic":0},{"needExperience":45000,"chips":300000,"experience":449045,"magic":0},{"needExperience":50000,"chips":300000,"experience":494045,"magic":0},{"needExperience":51000,"chips":300000,"experience":544045,"magic":40},{"needExperience":52000,"chips":400000,"experience":595045,"magic":0},{"needExperience":53000,"chips":400000,"experience":647045,"magic":0},{"needExperience":54000,"chips":400000,"experience":700045,"magic":0},{"needExperience":55000,"chips":400000,"experience":754045,"magic":0},{"needExperience":0,"chips":1000000,"experience":809045,"magic":50}],"treasureBox":{"timeRewardCountDown":0,"timeRewardRedDot":1,"ret":0,"redDot":0,"remain":-1,"taskDailyRedDot":0},"puzzleVersion":"","acceptable":1,"mPic":"","webViewMoveSwitch":1,"accelerator":[{"ip":"47.52.73.252","port":843},{"ip":"47.254.232.254","port":843},{"ip":"47.91.43.177","port":843},{"ip":"149.129.246.22","port":843}],"continueSignIn":{"totalDays":1,"curDay":2,"prizeInfo":[{"status":2,"reward":{"chips":5000}},{"status":1,"reward":{"chips":6000}},{"status":0,"reward":{"chips":7000}},{"status":0,"reward":{"chips":8000}},{"status":0,"reward":{"chips":10000}},{"status":0,"reward":{"chips":12000}},{"status":0,"reward":{"chips":15000}}],"fbMore":30,"advertise":{"status":1,"prize":"{\"chips\":5000}"},"contPrize":{"status":0,"reward":{"chips":10000}},"getStat":1,"type":"week","contDay":7,"svipMore":0},"molSwitch":1,"giftFile":"\/giftProp\/cache\/1b8cfe4f3d89efa86124092155151b91.js","game":[{"ip":"10.201.0.47","port":"7003"},{"ip":"10.201.0.47","port":"7004"}],"ple":0,"latestVer":"218","paymentJson":"\/item\/payments-7a842de2b0028a1e76b987cd3fb55cb7d097d06b.js","isNoviceActivity":0,"displayBroadcastNums":15,"cornucopia":[13,14,19,20,25,26,27,28,29,30,31,32,49,50,55,56,61,62,63,64,65,66,67,68,79,80,81,82,83,84],"songkranPointSwitch":0,"hasGuideRewardList":{"three":1,"texas":1,"two":1},"guideReward":"{\"chips\":10000}","redDot":{"boxEntr":0,"taskAchieve":{"weekly":0,"daily":0,"achieve":0},"mail":{"friend":0,"system":1},"activityCenter":1,"guidePackage":0,"inviteCode":0,"rouletteTwo":1,"feedback":0,"puzzleFragmentFromFriend":0,"waterFestival":0,"roulette":1,"guideCode":0,"newFeedback":0},"weekCardGetToday":0,"cdnUpload":"http:\/\/ninekeupload.joyours.com","bankruptGiftPackInfo":0,"os":"android","blueAwardRequestMachine":"http:\/\/ninekeupload.joyours.com","flashSaleSwitch":0,"storageSwitchArray":{},"weekCardSwitch":0,"clientNetworkCardSwitch":0,"raceShareBasePic":{"sng":["\/sng_share_base_1.jpg","\/sng_share_base_2.jpg","\/sng_share_base_3.jpg","\/sng_share_base_4.jpg"],"mtt":["\/mtt_share_base_1.jpg","\/mtt_share_base_2.jpg","\/mtt_share_base_3.jpg","\/mtt_share_base_4.jpg"]},"switchUserVp":1,"weekCardOpenDay":0,"loginTimeStamp":1589939761,"christmasSwitch":0,"signIn":{"4":{"status":"2","awardDaily":"{\"chips\":6000}"},"1":{"status":"0","awardDaily":"{\"chips\":3000}"},"5":{"status":"2","awardDaily":"{\"chips\":8000}"},"totalRewardList":{"7":"{\"chips\":20000}","3":"{\"chips\":10000}","5":"{\"chips\":15000}"},"6":{"status":"2","awardDaily":"{\"chips\":10000}"},"3":{"status":"2","awardDaily":"{\"chips\":5000}"},"7":{"status":"2","awardDaily":"{\"chips\":12000}"},"2":{"status":"0","awardDaily":"{\"chips\":4000}"},"totalDays":2},"fbMore":"30","mysteryPackageSwitch":0,"activityCocktailExchangeSwitch":0,"forceUpdateStore":"","debugLogBeforeDays":"2","magicSort":[1,8,3,13,5,11,12,4,19,20,16,10,101,102],"isInReview":0,"sPic":"","privateVipLimit":"1","broadcast":{"ip":"10.201.0.11","port":7013},"magicLimit":6,"switchPointExchangeVer2":1,"rii":0,"bPic":"","smartHelperEnable":1,"switchFragmentCollect":0,"switchTimeReward":1,"forceHotfix":"","mailCount":1,"exp":2,"cornucopiaSwitch":1,"festivalSwitch":0,"isExpire":0,"proxy":[{"ip":"150.109.183.226","port":843},{"ip":"150.109.183.226","port":443},{"ip":"150.109.179.223","port":843},{"ip":"150.109.179.200","port":843},{"ip":"150.109.179.200","port":443},{"ip":"150.109.179.223","port":443}],"isShow":"1","canGuide":0,"gameElite":{"minBet":10000,"svr":[{"ip":"10.201.0.47","port":"7004"}]},"magic":"0","firstChargeSwitch":0,"realRaceSwitch":0,"enableChat":"1","levelOpen":{},"gameSvr":{"blind":[{"ip":"10.201.0.47","port":"7401"}],"nineke":[{"ip":"10.201.0.47","port":"7003"},{"ip":"10.201.0.47","port":"7004"}],"pokdeng":[{"ip":"10.201.0.47","port":"7021"}],"hundred":[{"ip":"10.201.0.47","port":"7351"}]},"showPointActivity":0,"activityWaterLightCollectExchangeSwitch":0,"isPayDoubleConfirm":1,"pointVersion":"","chips":3950,"flashSaleVersionMd5":{"plistMd5":"","pngMd5":""},"raceSharePath":"\/images\/com.flounder.nineke","rechargeSwitch":0,"gem":"0","sumPayRedDot":0,"gender":"f","magicOrder":[1,8,3,5,4,10,6,7,2,9],"fb":{"pullLimit":"100","inviteLimit":"30","againTime":1589734800,"inviteSend":"600","inviteAccept":"50000"},"svipGiftList":{"4":1086,"8":1090,"1":1083,"5":1087,"9":1091,"6":1088,"3":1085,"7":1089,"2":1084},"speaker":"0","showPointActivityPrimary":0,"isNewUser":false,"activityIconSort":["songkranPoint","recharge","flashSale","luckyPay","bankrupt","pointsRedeem","rechargeTotal","secretShop","weekCard","cocktail"],"vipGiftList":{"gem":1128,"silver":1109,"gold":1110},"inviteStrangerStatus":{"status":1,"redDot":false},"discount":{"more":"12","firstPay":"100"},"chatLimit":5,"storageSwitchs":0}'
        -- g.vars.user = json.decode(str)
    end
end