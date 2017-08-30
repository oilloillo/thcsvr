 
--湖的冰妖精☆琪露诺✿
function c29001.initial_effect(c)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(29001,0))
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c29001.cost)
	e3:SetTarget(c29001.sctg)
	e3:SetOperation(c29001.scop)
	c:RegisterEffect(e3)
end
function c29001.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,29001)==0 end
	Duel.RegisterFlagEffect(tp,29001,RESET_PHASE+PHASE_END,0,1)
end
function c29001.filter(c)
	return c:IsCode(22004) and c:IsAbleToHand()
end
function c29001.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29001.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c29001.scop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c29001.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
