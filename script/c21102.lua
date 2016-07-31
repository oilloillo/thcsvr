 
--永夜返 -三日月-
function c21102.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c21102.target)
	e1:SetOperation(c21102.operation)
	c:RegisterEffect(e1)
end
function c21102.filter(c)
	return c:IsSetCard(0x257) and c:IsSSetable()
end
function c21102.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return true end
	local lc=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local mx=Duel.GetMatchingGroupCount(Card.IsFacedown,tp,0,LOCATION_ONFIELD,nil)
	if chk==0 then return lc>0 and mx>0
		and Duel.IsExistingTarget(c21102.filter,tp,LOCATION_GRAVE,0,1,nil) end
	if mx>lc then mx=lc end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectTarget(tp,c21102.filter,tp,LOCATION_GRAVE,0,1,mx,nil)
	Duel.SetOperationInfo(0,nil,g,g:GetCount(),0,0)
end
function c21102.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		Duel.SSet(tp,tg)
		Duel.ConfirmCards(1-tp,tg)
    end
end
