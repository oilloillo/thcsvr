 
--绯想✿十六夜咲夜
function c200003.initial_effect(c)
	--[[code
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetValue(22020)
	c:RegisterEffect(e1)]]
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetTarget(c200003.target)
	e2:SetOperation(c200003.op)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--mon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(200003,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetTarget(c200003.tg2)
	e2:SetOperation(c200003.op2)
	c:RegisterEffect(e2)
end
function c200003.filter(c)
	return c:IsCode(200203) and c:IsAbleToHand()
end
function c200003.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c200003.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c200003.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c200003.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c200003.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		if Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
			Duel.ConfirmCards(1-tp,g)
			if Duel.SelectYesNo(tp,aux.Stringid(200003,0)) then
				Duel.BreakEffect()
				local token=Duel.CreateToken(tp,200103)
				Duel.MoveToField(token,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
--				Duel.RaiseEvent(token,EVENT_CHAIN_SOLVED,token:GetActivateEffect(),0,tp,tp,Duel.GetCurrentChain())
			end
		end
	end
--[[
	if Duel.IsExistingMatchingCard(c200003.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) 
--	and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil)
--	and Duel.SelectYesNo(tp,aux.Stringid(200003,0)) 
	then
--		Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_EFFECT+REASON_DISCARD)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c200003.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end]]
end
function c200003.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_ONFIELD end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
--	Duel.SetChainLimit(aux.FALSE)
end
function c200003.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsLocation(LOCATION_ONFIELD) then
		--forbidden
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE)
		e1:SetCode(EFFECT_FORBIDDEN)
		e1:SetTarget(c200003.bantg)
		e1:SetLabelObject(tc)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
		e2:SetTarget(c200003.bantg)
		e2:SetLabelObject(tc)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
end
function c200003.bantg(e,c)
	return c==e:GetLabelObject()
end