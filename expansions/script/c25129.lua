 
--凭依「喜怒哀乐附体」
function c25129.initial_effect(c)
	c:SetUniqueOnField(1,1,25129)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(25129,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c25129.target)
	e2:SetOperation(c25129.activate)
	c:RegisterEffect(e2)
end
function c25129.filter(c)
	return c:IsDestructable() and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsFaceup()
end
function c25129.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c25129.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c25129.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c25129.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c25129.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
