 
--绯想✿铃仙·优昙华院·稻叶
function c200012.initial_effect(c)
	--[[code
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetValue(21012)
	c:RegisterEffect(e1)]]
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetValue(c200012.tgvalue)
	c:RegisterEffect(e1)
	--[[destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetTarget(c200012.destg)
	e3:SetOperation(c200012.desop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)]]
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetRange(LOCATION_MZONE)
--	e1:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e1:SetCountLimit(1)
	e1:SetTarget(c200012.stg)
	e1:SetOperation(c200012.sop)
	c:RegisterEffect(e1)
	--field
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(200012,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetOperation(c200012.op1)
	c:RegisterEffect(e1)
end--[[
function c200012.filter(c)
	return c:IsFaceup() and c:IsDestructable()
end
function c200012.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and c200012.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c200012.filter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c200012.filter,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c200012.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsLocation(LOCATION_SZONE) and tc:IsRelateToEffect(e) and tc:IsDestructable() then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end]]
function c200012.tgvalue(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end
function c200012.cfilter(c,tp)
	return c:IsControler(1-tp) and c:IsPreviousLocation(LOCATION_DECK) and not c:IsReason(REASON_DRAW)
end
function c200012.filter2(c)
	return c:IsCode(200212) and c:IsAbleToHand()
end
function c200012.stg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c200012.cfilter,1,nil,tp) end --and Duel.IsExistingMatchingCard(c200012.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c200012.sop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c200012.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c200012.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c200012.op1(e,tp,eg,ep,ev,re,r,rp)
	local token=Duel.CreateToken(tp,200112)
	Duel.MoveToField(token,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
--	Duel.RaiseEvent(token,EVENT_CHAIN_SOLVED,token:GetActivateEffect(),0,tp,tp,Duel.GetCurrentChain())
end