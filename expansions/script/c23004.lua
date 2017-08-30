 
--丰收之神 秋瓤子
function c23004.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(23004,0))
	e1:SetCategory(CATEGORY_SEARCH)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CHAIN_UNIQUE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_DECK)
	e1:SetCost(c23004.cost)
	e1:SetTarget(c23004.tg)
	e1:SetOperation(c23004.op)
	c:RegisterEffect(e1)
end
function c23004.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,23004)==0 end
	Duel.RegisterFlagEffect(tp,23004,RESET_PHASE+PHASE_END,0,1)
end
function c23004.filter(c)
	return (c:IsCode(23019) or c:IsCode(23001)) and c:IsAbleToHand()
end
function c23004.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c23004.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c23004.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c23004.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
