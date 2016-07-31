 
--策士之九尾
function c20035.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0x208),2)
	c:EnableReviveLimit()
	--pos change
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(20035,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCountLimit(1)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetTarget(c20035.tg)
	e1:SetOperation(c20035.op)
	c:RegisterEffect(e1)
	--disable trap/spell
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetOperation(c20035.spr)
	c:RegisterEffect(e4)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(20035,1))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetHintTiming(0,TIMING_CHAIN_END)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c20035.condition)
	e2:SetCost(c20035.cost)
	e2:SetOperation(c20035.operation)
	c:RegisterEffect(e2)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c20035.val)
	c:RegisterEffect(e3)
end
function c20035.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g1=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g2=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g1,2,0,0)
end
function c20035.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		Duel.ChangePosition(tg,POS_FACEUP_DEFENCE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
	end
end
function c20035.spr(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsPreviousLocation(LOCATION_ONFIELD) then return end
	c:RegisterFlagEffect(20035,RESET_EVENT+0x1fe0000,0,0)
end
function c20035.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev) and e:GetHandler():GetFlagEffect(20035)>0
end
function c20035.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c20035.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c20035.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xa225)
end
function c20035.filter(c)
	return c:GetLevel()+c:GetRank()
end
function c20035.val(e,c)
	local g=Duel.GetMatchingGroup(c20035.atkfilter,c:GetControler(),LOCATION_MZONE,0,nil)
	if g:GetCount()==0 then return end
	local tc=g:GetMaxGroup(c20035.filter):GetFirst()
	return (tc:GetLevel()+tc:GetRank())*100
end
