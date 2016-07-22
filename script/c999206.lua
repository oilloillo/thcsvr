--三种神器之　乡
function c999206.initial_effect(c)
	c:EnableReviveLimit()
	--pend
	aux.EnablePendulumAttribute(c)
	-- fusion
	aux.AddFusionProcCodeFun(c,999203,aux.FilterBoolFunction(Card.IsSetCard,0xaa1),1,true,true)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetCountLimit(1,999206)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c999206.sprcon)
	e1:SetOperation(c999206.sprop)
	e1:SetValue(SUMMON_TYPE_FUSION)
	c:RegisterEffect(e1)
	-- fusion summon success 2
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c999206.drcon)
	e3:SetTargetRange(LOCATION_ONFIELD,0)
	e3:SetTarget(c999206.indes)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	-- pend summon success 1
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(999206,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(c999206.dspcon)
	e4:SetTarget(c999206.dsptg)
	e4:SetOperation(c999206.dspop)
	c:RegisterEffect(e4)
end
function c999206.spfilter1(c,tp,flag,fc)
	local loc = 0
	if flag>0 then
		loc = LOCATION_MZONE+LOCATION_EXTRA
	else
		loc = (c:IsLocation(LOCATION_MZONE) and LOCATION_MZONE+LOCATION_EXTRA or LOCATION_MZONE)
	end

	return c:IsCode(999203) and c:IsAbleToDeckAsCost() and c:IsCanBeFusionMaterial(fc)
		and Duel.IsExistingMatchingCard(c999206.spfilter2,tp,loc,0,1,c,fc)
end

function c999206.spfilter2(c,fc)
	return c:IsSetCard(0xaa1) and c:IsCanBeFusionMaterial(fc) and c:IsAbleToDeckAsCost()
end

function c999206.sprcon(e,c)
	if c==nil then return true end 
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c999206.spfilter1,tp,LOCATION_MZONE+LOCATION_EXTRA,0,1,nil,tp,Duel.GetLocationCount(tp,LOCATION_MZONE),c)
end
function c999206.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectMatchingCard(tp,c999206.spfilter1,tp,LOCATION_MZONE+LOCATION_EXTRA,0,1,1,nil,tp,Duel.GetLocationCount(tp,LOCATION_MZONE),c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local loc = 0
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		loc = LOCATION_MZONE+LOCATION_EXTRA
	else
		if g1:GetFirst():IsLocation(LOCATION_MZONE) then
			loc = LOCATION_MZONE+LOCATION_EXTRA
		else
			loc = LOCATION_MZONE
		end
	end
	local g2=Duel.SelectMatchingCard(tp,c999206.spfilter2,tp,loc,0,1,1,g1:GetFirst())
	g1:Merge(g2)
	local tc=g1:GetFirst()
	while tc do
		if not tc:IsFaceup() then Duel.ConfirmCards(1-tp,tc) end
		tc=g1:GetNext()
	end
	Duel.SendtoDeck(g1,nil,2,REASON_COST)
end
function c999206.drcon(e,tp,eg,ep,ev,re,r,rp)
	local sumtype = e:GetHandler():GetSummonType()
	return sumtype == SUMMON_TYPE_FUSION
end
-- function c999206.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
-- 	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
-- 	Duel.SetTargetPlayer(tp)
-- 	Duel.SetTargetParam(1)
-- 	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
-- end
-- function c999206.drop(e,tp,eg,ep,ev,re,r,rp)
-- 	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
-- 	Duel.Draw(p,d,REASON_EFFECT)
-- end
function c999206.indes(e,c)
	return c:IsFaceup() and c:IsSetCard(0xaa1)
end
function c999206.dspcon(e,tp,eg,ep,ev,re,r,rp)
	local sumtype = e:GetHandler():GetSummonType()
	return sumtype == SUMMON_TYPE_PENDULUM
end
function c999206.dspfilter(c,e,tp)
	return c:IsSetCard(0xaa1) and c:GetSequence()>5 and c:GetSequence()<8 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c999206.dsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c999206.dspfilter,tp,LOCATION_SZONE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_SZONE)
end
function c999206.dspop(e,tp,eg,ep,ev,re,r,rp)
	local max = Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g = Duel.GetMatchingGroup(c999206.dspfilter, tp, LOCATION_SZONE, 0, nil, e, tp)
	max = (max>g:GetCount() and g:GetCount() or max)
	if max<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg = g:Select(tp, max, max, nil)
	if sg:GetCount()>0 then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end