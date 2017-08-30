--罪符『彷徨大罪』
function c25070.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_BATTLE_DESTROYED)
	e1:SetCondition(c25070.condition)
	e1:SetTarget(c25070.target)
	e1:SetOperation(c25070.activate)
	c:RegisterEffect(e1)
end
function c25070.condition(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return tc:GetReasonPlayer()~=tp and tc:IsLocation(LOCATION_GRAVE) and tc:IsReason(REASON_BATTLE)
end
function c25070.filter(c)
	return c:IsAttackPos() and c:IsDestructable()
end
function c25070.thfilter(c)
	return c:IsAbleToHand() and c:IsSetCard(0x740)
end
function c25070.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c25070.filter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c25070.filter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,1-tp,g:GetCount()*100)
end
function c25070.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c25070.filter,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		local ct=Duel.Destroy(g,REASON_EFFECT)
		Duel.Damage(1-tp,ct*100,REASON_EFFECT)
		local tg=Duel.GetMatchingGroup(c25070.thfilter,tp,LOCATION_DECK,0,nil)
		if tg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(25070,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=tg:Select(tp,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
