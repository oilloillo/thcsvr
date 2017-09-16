--冬符『花之凋零』
local M = c999511
local Mid = 999511
function M.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetDescription(aux.Stringid(Mid, 0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_ATTACK, 0x11e0)
	e1:SetCost(M.cost)
	e1:SetTarget(M.target)
	e1:SetOperation(M.activate)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(Mid, 1))
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCondition(M.descon)
	e2:SetCost(M.descost)
	e2:SetTarget(M.destg)
	e2:SetOperation(M.desop)
	c:RegisterEffect(e2)
end

function M.filter(c,e)
	return c:IsCanBeEffectTarget(e) and c:IsSetCard(0x208) and c:IsDestructable() and c:IsFaceup() and not c:IsType(TYPE_LINK)
end

function M.lvfilter(c)
	if c:IsType(TYPE_XYZ) then 
		return c:GetRank()
	else
		return c:GetLevel()
	end
end

function M.desfilter(c,lv)
	return c:IsDestructable() and c:IsFaceup() and c:IsSetCard(0x208) and M.lvfilter(c)<=lv
end

function M.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(M.filter, tp, LOCATION_MZONE, LOCATION_MZONE, nil, e)
	if g:GetCount()<1 then return end
	local minlv=0
	local ming=g:GetMinGroup(M.lvfilter)
	minlv=M.lvfilter(ming:GetFirst())-Duel.GetTurnCount()
	if minlv<1 then minlv=1 end
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable, tp, LOCATION_HAND, 0, minlv, nil) end
	local ct=Duel.DiscardHand(tp, Card.IsDiscardable, minlv, 99, REASON_COST+REASON_DISCARD)
	e:SetLabel(ct)
end

function M.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g = Duel.GetMatchingGroup(M.filter, tp, LOCATION_MZONE, LOCATION_MZONE, nil, e)
	if g:GetCount() < 1 then return end
	local ming = g:GetMinGroup(M.lvfilter)
	local ct = Duel.GetTargetCount(M.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,M.lvfilter(ming:GetFirst()))
	if chk == 0 then return ct >0  end
	local lv = e:GetLabel()+Duel.GetTurnCount()
	ct = Duel.GetTargetCount(M.desfilter, tp, LOCATION_MZONE, LOCATION_MZONE, nil, lv)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g = Duel.SelectTarget(tp, M.desfilter, tp, LOCATION_MZONE, LOCATION_MZONE, ct, ct, nil, lv)
	Duel.SetOperationInfo(0, CATEGORY_DESTROY, g, g:GetCount(), 0, 0)
end

function M.activate(e,tp,eg,ep,ev,re,r,rp)
	local tg = Duel.GetChainInfo(0, CHAININFO_TARGET_CARDS)
	local rg = tg:Filter(Card.IsRelateToEffect, nil, e)
	if rg:GetCount() > 0 then 
		Duel.Destroy(rg, REASON_EFFECT)
	end
end

function M.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk == 0 then return not e:GetHandler():IsLocation(LOCATION_REMOVED) and e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(), POS_FACEUP, REASON_COST)
end

function M.descon(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetHandler()
	return c:IsPreviousPosition(POS_FACEDOWN) and bit.band(r, 0x40) == 0x40 
		and rp ~= tp and c:GetPreviousControler() == tp
end

function M.desfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0x208) and c:IsDestructable()
end

function M.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsOnField() and M.desfilter2(chkc) end
	if chk == 0 then return Duel.IsExistingTarget(M.desfilter2, tp, LOCATION_ONFIELD, LOCATION_ONFIELD, 1, e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g = Duel.SelectTarget(tp, M.desfilter2, tp, LOCATION_ONFIELD, LOCATION_ONFIELD, 1, 1, e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end

function M.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc, REASON_EFFECT)
	end
end