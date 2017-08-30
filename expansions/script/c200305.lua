 
--浪漫洋溢的选择
function c200305.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c200305.condition)
	e1:SetTarget(c200305.target)
	e1:SetOperation(c200305.activate)
	c:RegisterEffect(e1)
end
function c200305.filter(c)
	local x=c:GetOriginalCode()
	return x>=200001 and x<=200020 and c:IsAbleToHand()
end
function c200305.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c200305.filter,tp,LOCATION_DECK,0,nil)
	return g:GetClassCount(Card.GetOriginalCode)>1
end
function c200305.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c200305.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c200305.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c200305.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 then
	--[[
		local rand=math.random(1,g:GetCount())
		local tc=g:GetFirst()
		while rand>1 do
			tc=g:GetNext()
			rand=rand-1
		end]]
		tc=g:RandomSelect(tp,1)
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
