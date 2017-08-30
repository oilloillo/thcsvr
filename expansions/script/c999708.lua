--萃梦想✿伊吹萃香
local M = c999708
local Mid = 999708
function M.initial_effect(c)
	c:EnableReviveLimit()
	-- xyzop
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(M.xyzcon)
	e1:SetOperation(M.xyzop)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(M.value)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetOperation(M.rankop)
	c:RegisterEffect(e3)
	-- xyz sync proc
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_SPSUMMON_PROC_G)
	--修复了不受怪兽效果影响的素材不会送去墓地的bug（滑稽
	e4:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(M.synCon)
	e4:SetOperation(M.synOp)
	e4:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e4)
end

function M.lvfilter(c, tp, xyzc, lv)
	if c:IsType(TYPE_TOKEN) or not c:IsCanBeXyzMaterial(xyzc) then return false end
	if not lv then
		return Duel.IsExistingMatchingCard(M.lvfilter, tp, LOCATION_MZONE, 0, 1, c, tp, xyzc, c:GetLevel())
	else
		return lv>0 and c:GetLevel() == lv 
	end
end

function M.xyzcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<-1 then return false end
	return Duel.IsExistingMatchingCard(M.lvfilter, tp, LOCATION_MZONE, 0, 1, nil, tp, c)
end

function M.xyzop(e,tp,eg,ep,ev,re,r,rp,c)
	local tp=c:GetControler()
	local mg = Duel.SelectMatchingCard(tp, M.lvfilter, tp, LOCATION_MZONE, 0, 1, 1, nil, tp, c)
	if mg:GetCount()<1 then return end

	local lv = mg:GetFirst():GetLevel()
	local mg2 = Duel.SelectMatchingCard(tp, M.lvfilter, tp, LOCATION_MZONE, 0, 1, 1, mg:GetFirst(), tp, c, lv)
	if mg2:GetCount()<1 then return end

	mg:Merge(mg2)
	if mg:GetCount()>1 then
		c:SetMaterial(mg)
		Duel.Overlay(c, mg)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_RANK)
		e1:SetValue(lv)
		e1:SetReset(RESET_EVENT+0x0fe0000)
		c:RegisterEffect(e1)
		c:RegisterFlagEffect(Mid, RESET_EVENT+0x0fe0000, 0, 1)
	end
end

function M.value(e,c)
	return c:GetRank()*200
end

function M.rankLvfilter(c)
	if c:IsOnField() or c:IsLocation(LOCATION_OVERLAY) then
		return c:GetLevel()
	else
		return c:GetPreviousLevelOnField()
	end
end

function M.rankop(e,c)
	local c = e:GetHandler()
	if c:GetFlagEffect(Mid) > 0 then return end
	if c:GetSummonType() ~= SUMMON_TYPE_XYZ then return end
	local mg = c:GetMaterial()
	local lv = math.floor(mg:GetSum(M.rankLvfilter)/2)
	if lv < 1 then return end 
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_RANK)
	e1:SetValue(lv)
	e1:SetReset(RESET_EVENT+0x0fe0000)
	c:RegisterEffect(e1)
end

function M.synLvfilter(c, syncard)
	if c:IsType(TYPE_XYZ) then
		return c:GetRank()
	else 
		return c:GetSynchroLevel(syncard)
	end
end

function M.filter(c, tp, mg, turner, e)
	local lv = c:GetLevel()-turner:GetRank()
	if lv < 1 then return false end
	return c:IsRace(RACE_ZOMBIE) and c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,true,false) and 
		mg:CheckWithSumEqual(M.synLvfilter, lv, 1, 99, c)
end

function M.synCon(e, c, og)
	if c == nil then return true end
	local tp = c:GetControler()
	local mg = Duel.GetMatchingGroup(Card.IsFaceup, tp, LOCATION_MZONE, 0, c)
	return Duel.IsExistingMatchingCard(M.filter, tp, LOCATION_EXTRA, 0, 1, nil, tp, mg, c, e)
end

function M.synOp(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
	local tp = c:GetControler()
	local g = Duel.GetMatchingGroup(Card.IsFaceup, tp, LOCATION_MZONE, 0, c)
	local syncG = Duel.SelectMatchingCard(tp, M.filter, tp, LOCATION_EXTRA, 0, 1, 1, nil, tp, g, c, e)
	if syncG:GetCount() < 1 then return end
	sg:Merge(syncG)
	sync = syncG:GetFirst()

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local lv = sync:GetLevel()-c:GetRank()
	local mg = g:SelectWithSumEqual(tp, M.synLvfilter, lv, 1, 99, sync)
	mg:AddCard(c)
	sync:SetMaterial(mg)
	Duel.SendtoGrave(mg, REASON_MATERIAL+REASON_SYNCHRO)
	sync:CompleteProcedure()
end
