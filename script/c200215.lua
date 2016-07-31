 
--符器-绯想之剑
function c200215.initial_effect(c)
	--des1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(200215,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,200215+EFFECT_COUNT_CODE_OATH)
--	e1:SetCost(c200215.cost)
	e1:SetTarget(c200215.destg)
	e1:SetOperation(c200215.desop)
	c:RegisterEffect(e1)
	--des2
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(200215,1))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,200215+EFFECT_COUNT_CODE_OATH)
--	e1:SetCost(c200215.cost)
	e1:SetTarget(c200215.destg2)
	e1:SetOperation(c200215.desop)
	c:RegisterEffect(e1)
end
function c200215.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,200215)<=0 end
	Duel.RegisterFlagEffect(tp,200215,RESET_PHASE+PHASE_END,0,1)
end
function c200215.filter(c)
	return c:IsSetCard(0x701) and c:IsFaceup()
end
function c200215.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c200215.filter,tp,LOCATION_ONFIELD,0,1,nil)
		and Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,c200215.filter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,2,0,0)
end
function c200215.filter2(c)
	local x=c:GetOriginalCode()
	return c:IsFaceup() and ((x>=200001 and x<=200020) or (x==200115) or (x==200215) or (x==200302) or (x==25016))
end
function c200215.destg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c200215.filter2,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) and 
		Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_ONFIELD,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,c200215.filter2,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,2,2,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,3,0,0)
end
function c200215.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		Duel.Destroy(tg,REASON_EFFECT)
	end
end