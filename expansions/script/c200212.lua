 
--符器-腐蚀药
function c200212.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DAMAGE)
	e1:SetTarget(c200212.target)
	e1:SetOperation(c200212.operation)
	c:RegisterEffect(e1)
end
function c200212.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,564)
	local ac=Duel.AnnounceCard(tp)
	e:SetLabel(ac)
	e:GetHandler():SetHint(CHINT_CARD,ac)
end
function c200212.operation(e,tp,eg,ep,ev,re,r,rp)
	local ac=e:GetLabel()
	local g=Duel.GetMatchingGroup(Card.IsCode,tp,0,LOCATION_HAND,nil,ac)
	local hg=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	Duel.ConfirmCards(tp,hg)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:Select(tp,1,1,nil)
		if Duel.SendtoGrave(sg,REASON_EFFECT)>0 then Duel.Damage(1-tp,500,REASON_EFFECT) end
	else
		Duel.Damage(tp,1000,REASON_EFFECT) 
		local cg=Duel.GetMatchingGroup(Card.IsCode,tp,0,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,nil,ac)
		local sg=cg:Filter(Card.IsAbleToHand,nil)
		if sg:GetCount()>0 and Duel.SelectYesNo(1-tp,aux.Stringid(200212,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOHAND)
			local tc=sg:Select(1-tp,1,1,nil)
			if Duel.SendtoHand(tc,1-tp,REASON_EFFECT)>0 then 
				Duel.ConfirmCards(tp,tc)
			end
		end
	end
	Duel.ShuffleHand(1-tp)
end