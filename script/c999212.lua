--光符「天照」　
--require "expansions/nef/nef"
function c999212.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c999212.activate)
	c:RegisterEffect(e1)
end
function c999212.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_ONFIELD)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c999212.uptg)
	e1:SetValue(300)
	c:RegisterEffect(e1)
	--defup
	local e0=e1:Clone()
	e0:SetCode(EFFECT_UPDATE_DEFENCE)
	e0:SetValue(300)
	c:RegisterEffect(e0)
	--sp1
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetDescription(aux.Stringid(999212,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_ONFIELD)
	e2:SetCountLimit(1,999211)
	e2:SetCondition(c999212.spcon1)
	e2:SetTarget(c999212.sptarget1)
	e2:SetOperation(c999212.spop1)
	c:RegisterEffect(e2)
	--sp2
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetDescription(aux.Stringid(999212,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c999212.encon)
	e3:SetTarget(c999212.entarget)
	e3:SetOperation(c999212.enop)
	c:RegisterEffect(e3)
end
function c999212.chkfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c999212.uptg(e,c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c999212.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(c999212.chkfilter,tp,LOCATION_MZONE+LOCATION_EXTRA,0,nil) > 2
end
function c999212.spfilter1(c,e,tp,lv)
	local temp = c:GetLevel()
	if temp == 0 then temp = c:GetRank() end
	if temp == 0 then return false end
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsSetCard(0x208) and temp<=lv
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c999212.sptarget1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		local lv = Duel.GetMatchingGroupCount(c999212.chkfilter,tp,LOCATION_MZONE+LOCATION_EXTRA,0,nil)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c999212.spfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp,lv) 
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c999212.spop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local lv = Duel.GetMatchingGroupCount(c999212.chkfilter,tp,LOCATION_MZONE+LOCATION_EXTRA,0,nil)
	local g=Duel.SelectMatchingCard(tp,c999212.spfilter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,lv)
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end
function c999212.encon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(c999212.chkfilter,tp,LOCATION_MZONE+LOCATION_EXTRA,0,nil) >4 and not e:GetHandler():IsStatus(STATUS_CHAINING)
end
function c999212.entarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and 
		Duel.IsPlayerCanSpecialSummonMonster(tp,999212,0,0x21,2000,0,4,RACE_BEAST,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,2000,0)
end
function c999212.enop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,999212,0,0x21,2000,0,4,RACE_BEAST,ATTRIBUTE_LIGHT) then return end
	c:AddTrapMonsterAttribute(TYPE_EFFECT,ATTRIBUTE_LIGHT,RACE_BEAST,4,2000,0)
	Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
	c:TrapMonsterBlock()
end