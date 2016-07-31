 
--阳离子地球毁灭四次元爆弹
function c13080.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_BATTLE_DESTROYED)
	e1:SetTarget(c13080.target)
	e1:SetOperation(c13080.activate)
	c:RegisterEffect(e1)
end
function c13080.cfilter(c,tp)
	return c:GetOriginalCode()==(13021) and c:GetPreviousControler()==tp
end
function c13080.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c13080.cfilter,1,nil,tp) end
	local g=Duel.GetFieldGroup(tp,0xe,0xe)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c13080.filter(c)
	return not c:IsPublic() and c:IsCode(13016)
end
function c13080.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c13080.filter,tp,LOCATION_HAND,0,nil)
	if Duel.IsChainDisablable(0) and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(13080,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local sg=g:FilterSelect(tp,c13080.filter,1,1,nil)
		Duel.ConfirmCards(tp,sg)
		Duel.ShuffleHand(tp)
		Duel.SetLP(1-tp,Duel.GetLP(1-tp)-8000)
	else
		local g=Duel.GetFieldGroup(tp,0xe,0xe)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		Duel.SetLP(1-tp,Duel.GetLP(1-tp)-8000)
		Duel.SetLP(tp,Duel.GetLP(tp)-8000)
	end
end
