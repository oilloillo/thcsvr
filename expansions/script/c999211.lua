--光符「天照」
local M = c999211
local Mid = 999211
function M.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(M.activate)
	c:RegisterEffect(e1)
end

function M.activate(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetHandler()
	--atkup
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_ONFIELD)
	e1:SetTargetRange(LOCATION_MZONE, 0)
	e1:SetTarget(M.uptg)
	e1:SetValue(300)
	c:RegisterEffect(e1)
	--defup
	local e0 = e1:Clone()
	e0:SetCode(EFFECT_UPDATE_DEFENSE)
	e0:SetValue(300)
	c:RegisterEffect(e0)
	--sp1
	local e2 = Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetDescription(aux.Stringid(Mid, 0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_ONFIELD)
	e2:SetCountLimit(1, Mid)
	e2:SetCondition(M.spcon1)
	e2:SetTarget(M.sptarget1)
	e2:SetOperation(M.spop1)
	c:RegisterEffect(e2)
	--sp2
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetDescription(aux.Stringid(Mid, 1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(M.encon)
	e3:SetTarget(M.entarget)
	e3:SetOperation(M.enop)
	c:RegisterEffect(e3)
end
function M.chkfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function M.uptg(e,c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
--
function M.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(M.chkfilter,tp,LOCATION_MZONE+LOCATION_EXTRA,0,nil) > 2
end
function M.spfilter1(c,e,tp,lv)
	local temp = 99
	if c:IsType(TYPE_LINK) then 
		return false
	elseif c:IsType(TYPE_XYZ) then
		temp = c:GetRank()
	else
		temp = c:GetLevel()
	end
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsSetCard(0x208) and temp <= lv
		and c:IsCanBeSpecialSummoned(e, 0, tp, false, false) and Duel.GetLocationCountFromEx(tp) > 0
end
function M.sptarget1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk == 0 then 
		local lv = Duel.GetMatchingGroupCount(M.chkfilter, tp, LOCATION_MZONE+LOCATION_EXTRA, 0, nil)
		return Duel.GetLocationCountFromEx(tp) > 0
			and Duel.IsExistingMatchingCard(M.spfilter1, tp, LOCATION_EXTRA, 0, 1, nil, e, tp, lv) 
	end
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_EXTRA)
end
function M.spop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCountFromEx(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
	local lv = Duel.GetMatchingGroupCount(M.chkfilter, tp, LOCATION_MZONE+LOCATION_EXTRA, 0, nil)
	local g = Duel.SelectMatchingCard(tp, M.spfilter1, tp, LOCATION_EXTRA, 0, 1, 1, nil, e, tp, lv)
	Duel.SpecialSummon(g, 0, tp, tp, false, false, POS_FACEUP)
end
--
function M.encon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(M.chkfilter,tp,LOCATION_MZONE+LOCATION_EXTRA,0,nil)>4 and not e:GetHandler():IsStatus(STATUS_CHAINING)
end
function M.entarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and 
		Duel.IsPlayerCanSpecialSummonMonster(tp,Mid,0,0x21,2000,0,4,RACE_BEAST,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,2000,0)
end
function M.enop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,Mid,0,0x21,2000,0,4,RACE_BEAST,ATTRIBUTE_LIGHT) then return end
	c:AddMonsterAttribute(TYPE_EFFECT+TYPE_TRAP)
	Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP)
	c:AddMonsterAttributeComplete()
	Duel.SpecialSummonComplete()
end