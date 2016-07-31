 
--毒爪「剧毒夷灭」
function c27036.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetCost(c27036.cost)
	e1:SetTarget(c27036.target)
	e1:SetOperation(c27036.activate)
	c:RegisterEffect(e1)
end
function c27036.filter(c)
	return c:IsSetCard(0x208) and c:IsAttackAbove(2000)
end
function c27036.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c27036.filter,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,c27036.filter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c27036.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() and chkc:IsDestructable() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,800)
end
function c27036.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) then return end
	if Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>=2 and Duel.IsChainDisablable(0) and Duel.SelectYesNo(1-tp,aux.Stringid(27036,0)) then
		Duel.DiscardHand(1-tp,aux.TRUE,2,2,REASON_EFFECT+REASON_DISCARD,nil)
	else
		Duel.Destroy(tc,REASON_EFFECT)
		Duel.Damage(1-tp,800,REASON_EFFECT)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCountLimit(1)
		e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e2:SetCondition(c27036.damcon)
		e2:SetOperation(c27036.damop)
		Duel.RegisterEffect(e2,tp)
	end
end
function c27036.damcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c27036.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,27036)
	Duel.Damage(1-tp,400,REASON_EFFECT)
end
