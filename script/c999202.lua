--三种神器之　玉
--require "expansions/nef/nef"
function c999202.initial_effect(c)
	--pendulum summon
	local argTable = {1}
	Nef.EnablePendulumAttributeSP(c,1,aux.TRUE,argTable,false)
	--Dual
	Nef.EnableDualAttribute(c, TYPE_PENDULUM)	
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--ChangeToDual
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(999202,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_ONFIELD+LOCATION_PZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetCondition(c999202.dualcon)
	e2:SetTarget(c999202.dualtg)
	e2:SetOperation(c999202.dualop)
	c:RegisterEffect(e2)
	--toPZone
	local e3 = Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(999202,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(aux.IsDualState)
	e3:SetCost(c999202.tpcost)
	e3:SetTarget(c999202.tptar)
	e3:SetOperation(c999202.tpop)
	c:RegisterEffect(e3)
end
function c999202.dualfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_DUAL) and not c:IsDualState()
end
function c999202.filter(c)
	return c:IsCode(999204) and not c:IsDisabled()
end
function c999202.dualcon(e)
	local c = e:GetHandler()
	local tp = c:GetControler()
	return c:GetSequence()==6 or c:GetSequence()==7 
		or Duel.IsExistingMatchingCard(c999202.filter,tp,LOCATION_MZONE,0,1,nil)
end
function c999202.dualtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c999202.dualfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c999202.dualfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c999202.dualfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c999202.dualfilterTarget(e,c)
	local tc=e:GetHandler()
	return c==tc and c:IsType(TYPE_DUAL)
end
function c999202.dualop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local e1=Effect.CreateEffect(tc)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c999202.dualfilterTarget)
	e1:SetCode(EFFECT_DUAL_STATUS)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_OPPO_TURN+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e1)
end
function c999202.tpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c999202.tptar(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local flag = Duel.GetFieldCard(tp, LOCATION_SZONE, 6) and Duel.GetFieldCard(tp, LOCATION_SZONE, 7)
	if chk==0 then return not flag and Duel.IsExistingMatchingCard(c999202.tpfilter, tp, LOCATION_DECK, 0, 1, nil) end
end
function c999202.tpfilter(c)
	return c:IsSetCard(0xaa1) and c:IsType(TYPE_PENDULUM) and not c:IsCode(999202)
end
function c999202.tpop(e,tp,eg,ep,ev,re,r,rp)
	local flag1 = Duel.GetFieldCard(tp, LOCATION_SZONE, 6)
	local flag2 = Duel.GetFieldCard(tp, LOCATION_SZONE, 7)
	if flag1 and flag2 then return end
	if not flag1 and Duel.IsExistingMatchingCard(c999202.tpfilter, tp, LOCATION_DECK, 0, 1, nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g = Duel.SelectMatchingCard(tp,c999202.tpfilter,tp,LOCATION_DECK,0,1,1,nil)
		Duel.MoveToField(g:GetFirst(), tp, tp, LOCATION_SZONE, POS_FACEUP, true)
	end
	if not flag2 and Duel.IsExistingMatchingCard(c999202.tpfilter, tp, LOCATION_DECK, 0, 1, nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g = Duel.SelectMatchingCard(tp,c999202.tpfilter,tp,LOCATION_DECK,0,1,1,nil)
		Duel.MoveToField(g:GetFirst(), tp, tp, LOCATION_SZONE, POS_FACEUP, true)
	end
end