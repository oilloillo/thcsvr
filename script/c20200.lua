--require "expansions/nef/nef"
--幻想朱桜『白玉楼·春』
function c20200.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_RECOVER)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c20200.target)
	e1:SetOperation(c20200.operation)
	c:RegisterEffect(e1)
end
function c20200.filter(c)
	return c:IsFaceup() and c:IsLevelBelow(8)
end
function c20200.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c20200.filter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(c20200.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g1=Duel.SelectTarget(tp,c20200.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g2=Duel.SelectTarget(tp,c20200.filter,tp,0,LOCATION_MZONE,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,2,0,0)
	local y,m,d = Nef.GetDate()
	if (m>=3 and m<=5) then
		Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
	end
end
function c20200.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local y,m,d = Nef.GetDate()
	if g:GetCount()==2 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
	if (m>=3 and m<=5) then
		Duel.Recover(tp,1000,REASON_EFFECT)
		local sg=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_REMOVED,0,1,1,nil)
		if sg:GetCount()>0 then
			Duel.SendtoGrave(sg,REASON_EFFECT+REASON_RETURN)
		end
	end
end
