--谎言『狼之舌』
function c25071.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c25071.target)
	e1:SetOperation(c25071.activate)
	c:RegisterEffect(e1)
end
function c25071.filter(c)
	return c:IsFaceup()
end
function c25071.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and c25071.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c25071.filter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(25071,0))
	local g=Duel.SelectTarget(tp,c25071.filter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,6,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function c25071.activate(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=tg:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_RETURN)
		local og=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_GRAVE)
		local ct1=og:FilterCount(Card.IsControler,nil,tp)
		local ct2=og:FilterCount(Card.IsControler,nil,1-tp)
		if ct2>2 and Duel.IsExistingMatchingCard(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,e:GetHandler()) then
			dg=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,e:GetHandler())
			Duel.Destroy(dg,REASON_EFFECT)
			Duel.Damage(1-tp,1000,REASON_EFFECT)
		end
		if ct1>2 then
			Duel.Draw(tp,1,REASON_EFFECT)
			Duel.Draw(1-tp,1,REASON_EFFECT)
		end
	end
end
