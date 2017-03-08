--神话幻想～Infinite Being
function c15040.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,15040+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c15040.cost)
	e1:SetTarget(c15040.target)
	e1:SetOperation(c15040.activate)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,15040+EFFECT_COUNT_CODE_OATH)
	e2:SetCost(c15040.condition)
	e2:SetCost(c15040.cost)
	e2:SetTarget(c15040.tg)
	e2:SetOperation(c15040.op)
	c:RegisterEffect(e2)
end
function c15040.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 and Duel.GetCurrentPhase()==PHASE_MAIN1 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c15040.filter(c)
	return c:IsRace(RACE_CREATORGOD) and c:IsAbleToHand()
end
function c15040.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c15040.filter(chkc) and chkc:IsControler(tp) and chkc:IsLocation(0x30) end
	if chk==0 then return Duel.IsExistingTarget(c15040.filter,tp,0x30,0,1,nil) and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectTarget(tp,c15040.filter,tp,0x30,0,1,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,g1:GetCount(),0,0)
end
function c15040.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()==0 then return end
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
	for i=1,3 do
		Duel.RegisterFlagEffect(tp,150000,RESET_PHASE+PHASE_END,0,1)
	end
end
function c15040.cfilter(c)
	return (c:IsAttribute(ATTRIBUTE_DEVINE) or c:IsAttribute(ATTRIBUTE_LIGHT) or c:IsAttribute(ATTRIBUTE_DARK)) and c:IsFaceup()
end
function c15040.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(c15040.cfilter,tp,LOCATION_MZONE,0,nil)==1
end
function c15040.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c15040.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c15040.cfilter,tp,LOCATION_MZONE,0,nil)
	if g:GetCount()~=1 then return end
	local tc=g:GetFirst()
	if tc:GetAttribute()==ATTRIBUTE_DEVINE then
		if Duel.SelectYesNo(tp,aux.Stringid(15040,0)) then
			Duel.SetLP(tp,Duel.GetLP(1-tp))
		end
	else
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(1000)
		tc:RegisterEffect(e1)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_UPDATE_DEFENSE)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		e3:SetValue(1000)
		tc:RegisterEffect(e3)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e2:SetValue(1)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
	end
	for i=1,3 do
		Duel.RegisterFlagEffect(tp,150000,RESET_PHASE+PHASE_END,0,1)
	end
end
