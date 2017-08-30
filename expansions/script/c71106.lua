--No Name 仁·拉塞尔
function c71106.initial_effect(c)
    --search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71106,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_REMOVE)
	e2:SetCountLimit(1,71106)
	e2:SetTarget(c71106.shtg)
	e2:SetOperation(c71106.shop)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(71106,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetCountLimit(1,71106)
	e3:SetTarget(c71106.shtg2)
	e3:SetOperation(c71106.shop2)
	c:RegisterEffect(e3)
end
	function c71106.filter(c)
	return c:IsSetCard(0x711) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c71106.shtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71106.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c71106.shop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c71106.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
	function c71106.filter2(c)
	return c:IsCode(71107) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c71106.shtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71106.filter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c71106.shop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c71106.filter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end