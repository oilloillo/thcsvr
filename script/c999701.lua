--✿伊吹萃香✿
--require "expansions/nef/nef"
local M = c999701
local Mid = 999701
function M.initial_effect(c)
	-- cross summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC_G)
        --修复了不受怪兽效果影响的素材不会送去墓地的bug（滑稽
        e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(M.crossCon)
	e1:SetOperation(M.crossOp)
	e1:SetValue(M.value)
	c:RegisterEffect(e1)
	-- search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(Mid,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetTarget(M.thtg)
	e2:SetOperation(M.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	-- level
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetOperation(M.selectLv)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
	-- limit
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e6:SetValue(M.synlimit)
	c:RegisterEffect(e6)
end

function M.filter(c, turner, mg)
	if turner then
		return c:IsSynchroSummonable(turner, mg) and mg:GetFirst():IsCanBeSynchroMaterial(c, turner) and mg:GetNext():IsCanBeSynchroMaterial(c, turner)
	else
		return c:IsXyzSummonable(mg) and Duel.CheckXyzMaterial(c, nil, mg:GetFirst():GetLevel(), 2, 2, mg) and mg:GetFirst():IsCanBeXyzMaterial(c) and mg:GetNext():IsCanBeXyzMaterial(c)
		-- return c:IsType(TYPE_XYZ) and Duel.CheckXyzMaterial(c, aux.TRUE, mg:GetFirst():GetLevel(), 2, 2, mg) and mg:GetFirst():IsCanBeXyzMaterial(c) and mg:GetNext():IsCanBeXyzMaterial(c) 
	end
end

function M.crossCon(e,c,og)
	if c == nil then return true end
	local tp = c:GetControler()
	local g = Duel.GetMatchingGroup(Card.IsFaceup, tp, LOCATION_MZONE, 0, c)
	local tc = g:GetFirst()
	while tc do 
		local mg = Group.FromCards(c, tc)
		if Duel.IsExistingMatchingCard(M.filter, tp, LOCATION_EXTRA, 0, 1, nil, c, mg) and 
			Duel.IsExistingMatchingCard(M.filter, tp, LOCATION_EXTRA, 0, 1, nil, nil, mg) then
			return true
		end 
		tc = g:GetNext()
	end
	return false
end

function M.crossOp(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
	local tp = c:GetControler()
	local g = Duel.GetMatchingGroup(Card.IsFaceup, tp, LOCATION_MZONE, 0, c)
	local selg = Group.CreateGroup()
	local tc = g:GetFirst()
	while tc do 
		local temp = Group.FromCards(c, tc)
		if Duel.IsExistingMatchingCard(M.filter, tp, LOCATION_EXTRA, 0, 1, nil, c, temp) and 
			Duel.IsExistingMatchingCard(M.filter, tp, LOCATION_EXTRA, 0, 1, nil, nil, temp) then
			selg:AddCard(tc)
		end 
		tc = g:GetNext()
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local mg = Group.Select(selg, tp, 1, 1, c)
	mg:AddCard(c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sync = Duel.SelectMatchingCard(tp, M.filter, tp, LOCATION_EXTRA, 0, 1, 1, nil, c, mg)
	local xyzc = Duel.SelectMatchingCard(tp, M.filter, tp, LOCATION_EXTRA, 0, 1, 1, nil, nil, mg)
				
	sg:Merge(sync)
	sg:Merge(xyzc)
	sync:GetFirst():SetMaterial(mg)
	xyzc:GetFirst():SetMaterial(mg)
	
	Duel.HintSelection(mg)
	Duel.SendtoGrave(mg, REASON_MATERIAL+REASON_SYNCHRO+REASON_XYZ)
	sync:GetFirst():CompleteProcedure()
	xyzc:GetFirst():CompleteProcedure()
end

-- M.lvList = { -- stringID = lv
--  [1] = 1,
-- 	[2] = 2,
-- 	[3] = 4,
-- 	[4] = 8,
-- }

function M.value(e, c)
	return c:IsType(TYPE_SYNCHRO) and SUMMON_TYPE_SYNCHRO or SUMMON_TYPE_XYZ
end

function M.thfilter(c)
	return c:IsSetCard(0xaa5) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end

function M.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	--必发不检查是否存在
	if chk==0 then return true end--Duel.IsExistingMatchingCard(M.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function M.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,M.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function M.selectLv(e,tp,eg,ep,ev,re,r,rp)
	if not Nef.skList then 
		Nef.skList = {} 
		Nef.skList[0] = {[1] = 1}
		Nef.skList[1] = {[1] = 1}
		Nef.skList.isSummon = {}
	end
	Nef.skList.isSummon[tp] = true
	local list = {}
	local i = 1
	while Nef.skList[tp][i] do
		list[i] = {desc = aux.Stringid(Mid, i), lv = Nef.skList[tp][i]}
		i = i + 1
	end
	if i < 3 then return end
	local opt = Duel.SelectOption(tp, Nef.unpackOneMember(list, "desc"))+1
	local lv = list[opt].lv
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetValue(lv)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e:GetHandler():RegisterEffect(e1)
end

function M.synlimit(e,c)
	if not c then return false end
	return not c:IsRace(RACE_ZOMBIE)
end
