--梦幻馆的完美主义者✿幽香
function c14058.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(14058,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(c14058.condition)
	e1:SetTarget(c14058.target)
	e1:SetOperation(c14058.operation)
	c:RegisterEffect(e1)
	--adup
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetCondition(c14058.adcon)
	e4:SetValue(c14058.atkval)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_UPDATE_DEFENSE)
	e5:SetValue(c14058.defval)
	c:RegisterEffect(e5)
end
function c14058.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_ADVANCE
end
function c14058.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_ONFIELD) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c14058.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c14058.afilter(c)
	return c:IsFaceup() and c:IsCode(14035)
end
function c14058.adcon(e)
	local c=e:GetHandler()
	local ph=Duel.GetCurrentPhase()
	if not (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL) then return false end
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return Duel.IsExistingMatchingCard(c14058.afilter,c:GetControler(),LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) 
	and ((a==e:GetHandler() and d) or d==e:GetHandler())
end
function c14058.atkval(e,c)
	return c:GetAttack()
end
function c14058.defval(e,c)
	return c:GetDefense()
end
