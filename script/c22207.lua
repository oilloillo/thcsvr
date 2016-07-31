 
--图书馆大危机！！
function c22207.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c22207.target)
	e1:SetOperation(c22207.activate)
	c:RegisterEffect(e1)
end
function c22207.filter(c)
	return c:IsSetCard(0x177) and c:IsAbleToHand()
end
function c22207.mfilter(c)
	return c:IsSetCard(0x813) and c:IsRace(RACE_SPELLCASTER) and c:IsAbleToHand()
end
function c22207.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22207.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c22207.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c22207.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local ct1=Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD+LOCATION_HAND,0)
		local ct2=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD+LOCATION_HAND)
		if ct2-ct1>0 and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 and Duel.SelectYesNo(tp,aux.Stringid(22207,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=Duel.SelectMatchingCard(tp,c22207.mfilter,tp,LOCATION_DECK,0,1,1,nil)
			if sg:GetCount()>0 and Duel.SendtoHand(sg,nil,REASON_EFFECT)>0 then
				Duel.ConfirmCards(1-tp,sg)
				Duel.Draw(tp,1,REASON_EFFECT)
			end
		end
	end
end
