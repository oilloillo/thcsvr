--齐射之草莓十字
function c13054.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c13054.target)
	e1:SetOperation(c13054.activate)
	c:RegisterEffect(e1)
	--sol
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetTarget(c13054.thtg)
	e2:SetOperation(c13054.thop)
	c:RegisterEffect(e2)
end
function c13054.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
function c13054.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c13054.filter,tp,LOCATION_ONFIELD,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.GetMatchingGroup(c13054.filter,tp,LOCATION_ONFIELD,0,c)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c13054.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=0
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		ct=math.ceil(Duel.Destroy(tg,REASON_EFFECT)/3)
		local dg=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,0xe,nil)
		if ct>0 and dg:GetCount()>0 then
			sg=dg:RandomSelect(tp,ct)
			Duel.Destroy(sg,REASON_EFFECT)
		end
	end
end
function c13054.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,1,nil) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,0)
	end
end
function c13054.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,1,12,nil)
	local ct=0
	if g:GetCount()>0 then
		ct=math.ceil(Duel.Remove(g,POS_FACEUP,REASON_EFFECT)/4)
		local dg=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,0xe,nil)
		if ct>0 and dg:GetCount()>0 then
			sg=dg:RandomSelect(tp,ct)
			Duel.Destroy(sg,REASON_EFFECT)
		end
	end
end
