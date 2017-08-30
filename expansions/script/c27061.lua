--邪符『养小鬼』
function c27061.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c27061.cost)
	e1:SetTarget(c27061.target)
	e1:SetOperation(c27061.activate)
	c:RegisterEffect(e1)
end
function c27061.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupEx(tp,Card.IsReleasable,1,nil) end
	local rg=Duel.SelectReleaseGroupEx(tp,Card.IsReleasable,1,1,nil)
	Duel.Release(rg,REASON_COST)
	if rg:GetFirst():IsLevelBelow(4) then
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
end
function c27061.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsDestructable() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c27061.tgfilter(c)
	return c:IsRace(RACE_ZOMBIE) and c:IsAbleToGrave() and c:IsSetCard(0x208)
end
function c27061.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
		if e:GetLabel()==1 and Duel.IsExistingMatchingCard(c27061.tgfilter,tp,LOCATION_DECK,0,1,nil)
			and Duel.SelectYesNo(tp,aux.Stringid(27061,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local g=Duel.SelectMatchingCard(tp,c27061.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
			if g:GetCount()>0 then
				Duel.SendtoGrave(g,REASON_EFFECT)
			end
		end
	end
end
