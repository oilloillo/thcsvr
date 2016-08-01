--
require "expansions/script/nef/nef"
Uds={}
local Udsflag = true
Uds.dataList = {}
Uds.cardList = {}

--rewrite
function Auxiliary.Stringid(code,id)
	if Udsflag==true then
		Udsflag = false
		Uds.regCardData()
		Uds.regSelectCard()
	end
	return code*16+id
end

function Uds.regCardData()
	-- Uds.dataList = {
	-- 	[1] = {desc=aux.Stringid(37001,1), code=37001, cost=6},
	-- 	[2] = {desc=aux.Stringid(37001,2), code=37002, cost=6},
	-- 	[3] = {desc=aux.Stringid(37001,3), code=37003, cost=3},
	-- 	[4] = {desc=aux.Stringid(37001,4), code=37004, cost=3},
	-- 	[5] = {desc=aux.Stringid(37001,5), code=37005, cost=2},
	-- 	[6] = {desc=aux.Stringid(37001,6), code=37006, cost=5},
	-- 	[7] = {desc=aux.Stringid(37001,7), code=37007, cost=5},
	-- 	[8] = {desc=aux.Stringid(37001,8), code=37008, cost=4},
	-- 	[9] = {desc=aux.Stringid(37001,9), code=37009, cost=9},
	-- 	[10] = {desc=aux.Stringid(37001,10), code=37010, cost=4},
	-- }
	Uds.dataList = {
		[37001] = 6,
		[37002] = 6,
		[37003] = 3,
		[37004] = 3,
		[37005] = 2,
		[37006] = 5,
		[37007] = 5,
		[37008] = 4,
		[37009] = 9,
		[37010] = 4,
		[37011] = 3,
		[37012] = 2,
	}
end

function Uds.regSelectCard()
	local e1=Effect.GlobalEffect()
    e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e1:SetCode(EVENT_ADJUST)
    -- e1:SetCode(EVENT_PHASE+PHASE_DRAW)
    e1:SetOperation(Uds.rscop)
	Duel.RegisterEffect(e1,0)
end

function Uds.rscop(e,tp,eg,ep,ev,re,r,rp)
	-- 
	if not Duel.SelectYesNo(tp,aux.Stringid(37000,2)) or not Duel.SelectYesNo(1-tp,aux.Stringid(37000,2)) then e:Reset()
	return end
	for k,v in pairs(Uds.dataList) do
		local token0=Duel.CreateToken(0, k)
		local token1=Duel.CreateToken(1, k)
		Duel.Remove(token0,POS_FACEDOWN,REASON_RULE)
		Duel.Remove(token1,POS_FACEDOWN,REASON_RULE)
	end

	local function checkCost(c, availableCost, trick)
		local code = c:GetCode()
		if code == 37000 then return trick < 2 end
		return Uds.dataList[code] and Uds.dataList[code] <= availableCost
	end
	-- 初始选卡
	for player=0,1 do
		local availableCost=10
		local trick = 0
		while availableCost>0 do
			if Duel.GetMatchingGroupCount(checkCost, player, LOCATION_REMOVED, 0, nil, availableCost, trick)>0 then
				local g=Duel.SelectMatchingCard(player, checkCost, player, LOCATION_REMOVED, 0, 1, 1, nil, availableCost, trick)
				local tc=g:GetFirst()
				if tc:GetCode()~=37000 then
					Uds.initCard(tc:GetCode(),player)
					availableCost = availableCost - Uds.dataList[tc:GetCode()]
				else
					trick = trick + 1
				end
			else
				availableCost = 0
			end
		end
		-- -- 初始化table
		-- local availableCost=10
		-- local t={}
		-- for k,v in pairs(Uds.dataList) do
		-- 	t[k]=v
		-- end
		
		-- while availableCost>0 and #t>0 do
		-- 	Duel.Hint(HINT_MESSAGE,player,aux.Stringid(37000,0))
		-- 	local sel=Duel.SelectOption(player,Nef.unpackOneMember(t, "desc"))+1
		-- 	local code=t[sel].code
		-- 	Uds.initCard(code,player)
		-- 	-- 维护table
		-- 	availableCost=availableCost-t[sel].cost
		-- 	for k=#t,1,-1 do
		-- 		v=t[k]
		-- 		if v.cost > availableCost then
		-- 			table.remove(t, k)
		-- 		end
		-- 	end
		-- end
		-- local token=Duel.CreateToken(player,37000)
		-- Duel.Remove(token,POS_FACEUP,REASON_RULE)
		-- Duel.RaiseSingleEvent(e:GetHandler(),EVENT_REMOVE,e,REASON_RULE,player,player,0)
		-- for i=1,2 do
		-- 	if Duel.SelectYesNo(player,aux.Stringid(37000,1)) then
		-- 		local token=Duel.CreateToken(player,37000)
		-- 		Duel.Remove(token,POS_FACEDOWN,REASON_RULE)
		-- 	end
		-- end
	end
	--销毁本效果
	e:Reset()
end

function Uds.initCard(code, player)
	if Uds.cardList[code] == nil then
		-- 初始化数据结构
		Uds.cardList[code] = {}  
		Uds.cardList[code][0] = 0
		Uds.cardList[code][1] = 0
	end

	-- 初始化符卡
	-- local token=Duel.CreateToken(player,code)
	-- Duel.Remove(token,POS_FACEDOWN,REASON_RULE)
	
	-- 存储使用次数
	Uds.cardList[code][player] = Uds.cardList[code][player] + 1 
end

function Uds.regUdsEffect(e,code)
	local e1=e:Clone()
	e1:SetLabel(code)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetOperation(Uds.setop)
	Duel.RegisterEffect(e1,0)
	local e2=e1:Clone()
	Duel.RegisterEffect(e2,1)
end

function Uds.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)==0 then return end
	if Uds.cardList[e:GetLabel()] == nil then return end -- 排除没有被初始化的符卡
	if Uds.cardList[e:GetLabel()][e:GetOwnerPlayer()] < 1 then return end -- 该玩家发动次数不足
	if not Duel.SelectYesNo(tp,aux.Stringid(e:GetLabel(),0)) then return end
	-- 维护发动次数
	Uds.cardList[e:GetLabel()][e:GetOwnerPlayer()] = Uds.cardList[e:GetLabel()][e:GetOwnerPlayer()] - 1
	-- 创建符卡
	local token=Duel.CreateToken(e:GetOwnerPlayer(),e:GetLabel())
	Duel.MoveToField(token, e:GetOwnerPlayer(), e:GetOwnerPlayer(), LOCATION_SZONE, POS_FACEDOWN, false)
end
