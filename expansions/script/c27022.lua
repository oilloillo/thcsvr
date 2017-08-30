 
--仙符「日出之处的道士」
function c27022.initial_effect(c)
	aux.AddRitualProcEqual(c,c27022.ritual_filter)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(27022,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c27022.cost)
	e2:SetTarget(c27022.target)
	e2:SetOperation(c27022.activate)
	c:RegisterEffect(e2)
end
function c27022.ritual_filter(c)
	return c:IsSetCard(0x208) and c:IsRace(RACE_ZOMBIE) and c:IsLevelAbove(4) and bit.band(c:GetType(),0x81)==0x81
end
function c27022.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,27022)==0 and e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	Duel.RegisterFlagEffect(tp,27022,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c27022.filter(c)
	return c:IsSetCard(0x246) and not c:IsCode(27022) and c:IsAbleToHand()
end
function c27022.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c27022.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c27022.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c27022.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
