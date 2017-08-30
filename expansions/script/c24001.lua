 
---废狱-可怕的水井妖怪·琪斯美
function c24001.initial_effect(c)
    --search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(24001,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetTarget(c24001.tg)
	e2:SetOperation(c24001.op)
	c:RegisterEffect(e2)
end
function c24001.filter(c)
	return c:IsSetCard(0x625) and c:IsAbleToHand() and c:IsLevelBelow(4)
end
function c24001.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c24001.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c24001.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c24001.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
