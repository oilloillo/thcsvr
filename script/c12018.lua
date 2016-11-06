--封魔录扛把子✿里香
function c12018.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,12012,aux.FilterBoolFunction(Card.IsFusionSetCard,0x993),1,true,true)
	--immune
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetValue(c12018.efilter)
	c:RegisterEffect(e5)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_EQUIP)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(c12018.operation)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(12018,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c12018.descost)
	e3:SetTarget(c12018.destg)
	e3:SetOperation(c12018.desop)
	c:RegisterEffect(e3)
end
c12018.hana_mat={
aux.FilterBoolFunction(Card.IsCode,12012),
aux.FilterBoolFunction(Card.IsSetCard,0x993),
}
function c12018.efilter(e,te)
	if te:IsActiveType(TYPE_TRAP) then return true
	else return Nef.kangbazi(e,te) end
end
function c12018.afilter(c)
	return c:IsType(TYPE_UNION)
end
function c12018.operation(e,tp,eg,ep,ev,re,r,rp)
	if not eg:IsExists(c12018.afilter,1,nil) then return end
	local att=eg:SearchCard(c12018.afilter)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(att:GetTextDefense())
	att:RegisterEffect(e1)
end
function c12018.cfilter(c)
	return c:IsType(TYPE_UNION) and c:IsAbleToGraveAsCost()
end
function c12018.filter(c)
	return c:IsFaceup() and c:IsDestructable()
end
function c12018.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12018.cfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c12018.cfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c12018.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsDestructable() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(c12018.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c12018.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c12018.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
