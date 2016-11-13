--凛冬之草莓十字
function c13055.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_ATTACK,0x11e0)
	e1:SetTarget(c13055.target)
	e1:SetOperation(c13055.activate)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetTarget(c13055.thtg)
	e2:SetOperation(c13055.thop)
	c:RegisterEffect(e2)
end
function c13055.filter(c)
	return c:IsLevelAbove(7) and c:IsSetCard(0x208) and c:IsDestructable()
end
function c13055.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler())
		and Duel.IsExistingMatchingCard(c13055.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c13055.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)>0 then
		local g=Duel.SelectMatchingCard(tp,c13055.filter,tp,LOCATION_HAND,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end
function c13055.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c13055.thop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetTurnCount()*200
	local lp=Duel.GetLP(1-tp)
	if ct>=lp then ct=lp-100 end
	Duel.SetLP(1-tp,lp-ct)
end
