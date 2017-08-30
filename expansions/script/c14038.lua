--恶魔姐妹的杀戮时间
function c14038.initial_effect(c)
	--des
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(14038,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c14038.destg)
	e1:SetOperation(c14038.desop)
	c:RegisterEffect(e1)
	--chiren
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(14038,1))
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c14038.condtion)
	e2:SetOperation(c14038.activate)
	c:RegisterEffect(e2)
end
function c14038.filter(c)
	return c:IsSetCard(0x139) and c:IsFaceup()
end
function c14038.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c14038.filter,tp,LOCATION_ONFIELD,0,1,nil)
		and Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,c14038.filter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_MZONE,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,2,0,0)
end
function c14038.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		Duel.Destroy(tg,REASON_EFFECT)
	end
end
function c14038.cfilter(c)
	return c:IsSetCard(0x138) and c:IsFaceup()
end
function c14038.condtion(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==Duel.GetMatchingGroupCount(c14038.cfilter,tp,LOCATION_MZONE,0,nil)
		and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>0
end
function c14038.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,14038,RESET_PHASE+PHASE_END,0,1)
end
