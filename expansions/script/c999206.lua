--三种神器之　乡
local M = c999206
local Mid = 999206
function M.initial_effect(c)
	c:EnableReviveLimit()
	--pend
	aux.EnablePendulumAttribute(c)
	-- fusion
	aux.AddFusionProcCodeFun(c,999203,aux.FilterBoolFunction(Card.IsFusionSetCard,0xaa1),1,true,true)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetCountLimit(1,Mid)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(M.sprcon)
	e1:SetOperation(M.sprop)
	e1:SetValue(SUMMON_TYPE_FUSION)
	c:RegisterEffect(e1)
	-- fusion summon success 2
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(M.drcon)
	e3:SetTargetRange(LOCATION_ONFIELD,0)
	e3:SetTarget(M.indes)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	-- pend summon success 1
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(Mid,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(M.dspcon)
	e4:SetTarget(M.dsptg)
	e4:SetOperation(M.dspop)
	c:RegisterEffect(e4)
end
M.hana_mat={
aux.FilterBoolFunction(Card.IsFusionCode,999203),
aux.FilterBoolFunction(Card.IsFusionSetCard,0xaa1),
}

function M.spfilter1(c, tp, fc)
	local flag = Duel.GetLocationCountFromEx(tp, tp, c) < 1
	return c:IsCode(999203) and c:IsAbleToDeckAsCost() and c:IsCanBeFusionMaterial(fc)
		and Duel.IsExistingMatchingCard(M.spfilter2, tp, LOCATION_MZONE+LOCATION_EXTRA, 0, 1, c, fc, flag)
end

function M.spfilter2(c, fc, flag)
	if flag and Duel.GetLocationCountFromEx(tp, tp, c) < 1 then return false end
	return c:IsSetCard(0xaa1) and c:IsCanBeFusionMaterial(fc) and c:IsAbleToDeckAsCost()
end

function M.sprcon(e, c)
	if c == nil then return true end 
	local tp = c:GetControler()
	return Duel.IsExistingMatchingCard(M.spfilter1, tp, LOCATION_MZONE+LOCATION_EXTRA, 0, 1, nil, tp, c)
end

function M.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TODECK)
	local g1 = Duel.SelectMatchingCard(tp, M.spfilter1, tp, LOCATION_MZONE+LOCATION_EXTRA, 0, 1, 1, nil, tp, c)
	
	local flag = Duel.GetLocationCountFromEx(tp, tp, g1:GetFirst()) < 1

	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TODECK)
	local g2 = Duel.SelectMatchingCard(tp, M.spfilter2, tp, LOCATION_MZONE+LOCATION_EXTRA, 0, 1, 1, g1:GetFirst(), c, flag)
	
	g1:Merge(g2)

	local tc = g1:GetFirst()
	while tc do
		if not tc:IsFaceup() then Duel.ConfirmCards(1-tp, tc) end
		tc = g1:GetNext()
	end
	Duel.SendtoDeck(g1, nil, 2 ,REASON_COST)
end
function M.drcon(e,tp,eg,ep,ev,re,r,rp)
	local sumtype = e:GetHandler():GetSummonType()
	return sumtype == SUMMON_TYPE_FUSION
end
-- function M.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
-- 	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
-- 	Duel.SetTargetPlayer(tp)
-- 	Duel.SetTargetParam(1)
-- 	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
-- end
-- function M.drop(e,tp,eg,ep,ev,re,r,rp)
-- 	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
-- 	Duel.Draw(p,d,REASON_EFFECT)
-- end
function M.indes(e,c)
	return c:IsFaceup() and c:IsSetCard(0xaa1)
end
function M.dspcon(e,tp,eg,ep,ev,re,r,rp)
	local sumtype = e:GetHandler():GetSummonType()
	return sumtype == SUMMON_TYPE_PENDULUM
end
function M.dspfilter(c,e,tp)
	return c:IsSetCard(0xaa1) and c:GetSequence()>5 and c:GetSequence()<8 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function M.dsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(M.dspfilter,tp,LOCATION_SZONE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_SZONE)
end
function M.dspop(e,tp,eg,ep,ev,re,r,rp)
	local max = Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g = Duel.GetMatchingGroup(M.dspfilter, tp, LOCATION_SZONE, 0, nil, e, tp)
	max = (max>g:GetCount() and g:GetCount() or max)
	if max<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg = g:Select(tp, max, max, nil)
	if sg:GetCount()>0 then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end