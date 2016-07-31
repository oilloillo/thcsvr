 
--符器-龙星
function c200218.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c200218.target)
	e1:SetOperation(c200218.activate)
	c:RegisterEffect(e1)
end
function c200218.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
end
function c200218.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsLocation(LOCATION_MZONE) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e2:SetValue(1)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		local e1=Effect.CreateEffect(c)
		e1:SetCategory(CATEGORY_TOHAND)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
		e1:SetCode(EVENT_BATTLED)
		e1:SetTarget(c200218.rettg)
		e1:SetOperation(c200218.retop)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c200218.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	local t=e:GetHandler():GetBattleTarget()
	if chk==0 then	return t and t:IsRelateToBattle() and t:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,t,1,0,0)
end
function c200218.retop(e,tp,eg,ep,ev,re,r,rp)
	local t=e:GetHandler():GetBattleTarget()
	if t and t:IsRelateToBattle() and t:IsAbleToHand() then
		Duel.SendtoHand(t,nil,REASON_EFFECT)
	end
end