 
--弹幕公主 小兔姬
function c13006.initial_effect(c)
	--confirm
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(13006,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(2)
	e1:SetTarget(c13006.target)
	e1:SetOperation(c13006.operation)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(13006,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CHAIN_UNIQUE)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1,13006)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c13006.descon)
	e2:SetCost(c13006.cost)
	e2:SetTarget(c13006.destg)
	e2:SetOperation(c13006.desop)
	c:RegisterEffect(e2)
end
function c13006.filter(c,tp)
	return (c:IsType(TYPE_SPELL+TYPE_TRAP) or c:IsPreviousLocation(LOCATION_SZONE)) and c:GetReasonPlayer()==tp
end
function c13006.cfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsFacedown()
end
function c13006.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() and chkc:IsFacedown() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFacedown,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEDOWN)
	Duel.SelectTarget(tp,Card.IsFacedown,tp,0,LOCATION_ONFIELD,1,1,nil)
end
function c13006.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFacedown() then
		Duel.ConfirmCards(tp,tc)
	end
end
function c13006.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c13006.filter,1,nil,tp) and not Duel.IsExistingMatchingCard(c13006.cfilter,tp,LOCATION_ONFIELD,0,1,nil) and Duel.GetTurnPlayer()==tp
end
function c13006.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,300) end
	Duel.PayLPCost(tp,300)
end
function c13006.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,0,1,0,0)
end
function c13006.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
	if g:GetCount()==0 then return end
	local sg=g:RandomSelect(1-tp,1)
	Duel.Destroy(sg,REASON_EFFECT)
end
