--Gust
function c70062.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(70062,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,70062)
	e1:SetTarget(c70062.tg)
	e1:SetOperation(c70062.op)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_TO_GRAVE)
	c:RegisterEffect(e2)
end
function c70062.filter(c)
	return c:IsSetCard(0x721) and c:IsAbleToHand()
end
function c70062.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c70062.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c70062.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c70062.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
