--require "expansions/nef/nef"
--幻想舒风『妖怪之山·秋』
function c23300.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c23300.target)
	e1:SetOperation(c23300.activate)
	c:RegisterEffect(e1)
end
function c23300.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c23300.filter1(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c23300.filter2(c)
	return c:IsFacedown() and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c23300.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c23300.filter1,tp,0,LOCATION_ONFIELD,1,nil)
		or Duel.IsExistingTarget(c23300.filter2,tp,0,LOCATION_ONFIELD,1,nil) end
	local y,m,d = Nef.GetDate()
	if (m==10 or m==11) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g=Duel.SelectTarget(tp,c23300.filter,tp,0,LOCATION_ONFIELD,1,2,nil)
	else
		if Duel.IsExistingTarget(c23300.filter1,tp,0,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(23300,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
			local g=Duel.SelectTarget(tp,c23300.filter1,tp,0,LOCATION_ONFIELD,1,1,nil)
			if Duel.IsExistingTarget(c23300.filter2,tp,0,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(23300,1)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
				local g2=Duel.SelectTarget(tp,c23300.filter2,tp,0,LOCATION_ONFIELD,1,1,nil)
				g:Merge(g2)
			end
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
			local g=Duel.SelectTarget(tp,c23300.filter2,tp,0,LOCATION_ONFIELD,1,1,nil)
		end
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,2,0,0)
	end
end
function c23300.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
	end
end
