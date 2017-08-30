 
--绯想✿东风谷早苗
function c200016.initial_effect(c)
	--code
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(23019)
	c:RegisterEffect(e1)
	--field
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(200016,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetTarget(c200016.ftg)
	e2:SetOperation(c200016.fop)
	c:RegisterEffect(e2)	
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH)
	e2:SetDescription(aux.Stringid(200016,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c200016.cost2)
	e2:SetTarget(c200016.tg2)
	e2:SetOperation(c200016.op2)
	c:RegisterEffect(e2)
	--search2
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_DECK)
	e1:SetTarget(c200016.tg)
	e1:SetOperation(c200016.op)
	c:RegisterEffect(e1)
end
function c200016.ftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAttackPos() end
end
function c200016.fop(e,tp,eg,ep,ev,re,r,rp)
	local token=Duel.CreateToken(tp,200116)
	Duel.MoveToField(token,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
--	Duel.RaiseEvent(token,EVENT_CHAIN_SOLVED,token:GetActivateEffect(),0,tp,tp,Duel.GetCurrentChain())
end
function c200016.cfilter(c)
	return c:IsAbleToDeckAsCost() and c:IsType(TYPE_MONSTER)
end
function c200016.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c200016.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c200016.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.SendtoDeck(g,nil,1,REASON_COST)
end
function c200016.filter(c)
	local x=c:GetOriginalCode()
	return x>=200001 and x<=200020 and c:IsAbleToHand() and x~=200016
end
function c200016.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c200016.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c200016.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c200016.filter,tp,LOCATION_DECK,0,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c200016.filter,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c200016.filter2(c)
	return c:IsCode(200216) and c:IsAbleToHand()
end
function c200016.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c200016.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c200016.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c200016.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c200016.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end