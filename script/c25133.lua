 
--假面丧心舞 暗黑能乐
function c25133.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c25133.cost)
	e1:SetTarget(c25133.target)
	e1:SetOperation(c25133.activate)
	c:RegisterEffect(e1)
end
function c25133.cfilter(c)
	return c:IsSetCard(0x414) and c:IsType(TYPE_EQUIP)
end
function c25133.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(c25133.cfilter,tp,LOCATION_GRAVE,0,nil)
		local ct=g:GetClassCount(Card.GetCode) 
		return ct>1 and g:GetCount()>3 end
	local g=Duel.GetMatchingGroup(c25133.cfilter,tp,LOCATION_GRAVE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:Select(tp,4,4,nil)
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end
function c25133.filter(c)
	return c:IsSetCard(0x223) and c:IsFaceup()
end
function c25133.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c25133.filter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(25133,0))
	local g1=Duel.SelectTarget(tp,c25133.filter,tp,LOCATION_MZONE,0,1,1,nil)
	e:SetLabelObject(g1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g2=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,g2:GetFirst())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c25133.activate(e,tp,eg,ep,ev,re,r,rp)
	local hc=e:GetLabelObject()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=g:GetFirst()
	if tc==hc then tc=g:GetNext() end
	if hc:IsFaceup() and hc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local atk=tc:GetBaseAttack()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(atk)
		hc:RegisterEffect(e1)
		local dg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,tc)
		Duel.Destroy(dg,REASON_EFFECT,LOCATION_REMOVED)
	end
end
