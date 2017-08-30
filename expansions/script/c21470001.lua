 
--铃奈庵
function c21470001.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c21470001.act)
	c:RegisterEffect(e1)
	--activate in set turn
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c21470001.con)
	e2:SetTargetRange(LOCATION_SZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x742))
	c:RegisterEffect(e2)
	--activate trap in hand
--[[	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(c21470001.con)
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x742))
	c:RegisterEffect(e1)]]
	--sol
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(21470001,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_TO_GRAVE)
--	e3:SetCondition(c21470001.condition)
	e3:SetTarget(c21470001.target)
	e3:SetOperation(c21470001.operation)
	c:RegisterEffect(e3)
end
function c21470001.act(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c21470001.condition2)
	e1:SetOperation(c21470001.operation2)
	e:GetHandler():RegisterEffect(e1)
end
function c21470001.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(21470001)<=0 --and Duel.GetTurnPlayer()==e:GetHandler():GetControler()
end
function c21470001.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c21470001.filter(c)
	return c:IsCode(21470005) and c:IsAbleToHand()
end
function c21470001.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c21470001.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c21470001.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c21470001.condition2(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_TRAP) and re:GetHandler():GetTurnID()==Duel.GetTurnCount() and re:GetHandler():IsSetCard(0x742) and re:GetHandler():IsStatus(STATUS_SET_TURN) and re:GetHandler():GetFlagEffect(21470008)==0
end
function c21470001.operation2(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(21470001,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end