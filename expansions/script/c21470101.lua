 
--狐狸逡巡的借书屋
function c21470101.initial_effect(c)
	c:SetUniqueOnField(1,0,21470101)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c21470101.act)
	c:RegisterEffect(e1)
	--code
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CHANGE_CODE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetValue(21470005)
	c:RegisterEffect(e2)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_TOGRAVE)
	e1:SetDescription(aux.Stringid(21470101,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetRange(LOCATION_SZONE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1)
	e1:SetTarget(c21470101.stg)
	e1:SetOperation(c21470101.sop)
	c:RegisterEffect(e1)
	--act qp in hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x742))
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetCondition(c21470101.con)
	c:RegisterEffect(e1)--[[
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(c21470101.checkop)
	c:RegisterEffect(e2)]]
	--activate trap in hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(c21470101.con)
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x742))
	c:RegisterEffect(e1)
end
function c21470101.act(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c21470101.condition2)
	e1:SetOperation(c21470101.operation2)
	e:GetHandler():RegisterEffect(e1)
end
function c21470101.condition2(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsSetCard(0x742)
		and (re:IsActiveType(TYPE_TRAP) and re:GetHandler():GetTurnID()==Duel.GetTurnCount() and not re:GetHandler():IsStatus(STATUS_SET_TURN))
		or (Duel.GetTurnPlayer()~=tp and re:GetActiveType()==TYPE_QUICKPLAY+TYPE_SPELL and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsStatus(STATUS_ACT_FROM_HAND))
end
function c21470101.operation2(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(21470101,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c21470101.cfilter(c,tp)
	return c:IsControler(tp) and not c:IsReason(REASON_DRAW)
end
function c21470101.filter(c)
	return c:IsSetCard(0x742) and c:IsAbleToHand()
end
function c21470101.stg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c21470101.cfilter,1,nil,tp) and Duel.IsExistingMatchingCard(c21470101.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c21470101.cfilter2(c,tp)
	return c:GetControler()==tp and not c:IsLocation(LOCATION_HAND)
end
function c21470101.sop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.IsExistingMatchingCard(c21470101.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) then
		if not eg:IsExists(c21470101.cfilter2,1,nil,tp) and Duel.SendtoGrave(eg,REASON_EFFECT)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,c21470101.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end--[[
function c21470101.tg(e,c)
	return c:IsSetCard(0x742)
end
function c21470101.actcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFlagEffect(tp,21470101)==0
end
function c21470101.checkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()==tp then return end
	if re:GetActiveType()==TYPE_QUICKPLAY+TYPE_SPELL and re:IsHasType(EFFECT_TYPE_ACTIVATE) 
		and re:GetHandler():IsStatus(STATUS_ACT_FROM_HAND) and re:GetHandler():IsSetCard(0x742) then
		Duel.RegisterFlagEffect(tp,21470101,RESET_PHASE+PHASE_END,0,1)
	end
end]]
function c21470101.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(21470101)<=0
end