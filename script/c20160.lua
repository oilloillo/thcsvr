 
--枪符「萌萌大千枪」
function c20160.initial_effect(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c20160.target)
	e1:SetOperation(c20160.operation)
	c:RegisterEffect(e1)
end
function c20160.cfilter(c)
	return c:IsSetCard(0x186) and c:IsFaceup()
end
function c20160.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroupCount(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and g<3
		--and Duel.IsExistingMatchingCard(c20160.cfilter,tp,LOCATION_MZONE,0,2,e:GetHandler())
		end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c20160.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(tp,1,REASON_EFFECT)==0 then return end
	local tc=Duel.GetOperatedGroup():GetFirst()
	Duel.ConfirmCards(1-tp,tc)
	if tc:IsSetCard(0x186) then
		if Duel.GetMatchingGroupCount(Card.IsDestructable,tp,0,LOCATION_ONFIELD,nil)>0 and Duel.SelectYesNo(tp,aux.Stringid(20160,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local dg=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
			Duel.Destroy(dg,REASON_EFFECT)
		end
	else
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
	Duel.ShuffleHand(tp)
end
