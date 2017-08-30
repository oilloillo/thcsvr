--魔法使小姐✿雾雨魔理沙
function c11038.initial_effect(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11038,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(c11038.cost)
	e1:SetTarget(c11038.target)
	e1:SetOperation(c11038.operation)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11038,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c11038.spcost)
	e2:SetTarget(c11038.atktg1)
	e2:SetOperation(c11038.spop)
	c:RegisterEffect(e2)
end
function c11038.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c11038.filterp(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsFaceup()
end
function c11038.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c11038.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c11038.filter(chkc) and chkc~=e:GetHandler() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(c11038.filter,tp,0,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	if Duel.IsExistingTarget(c11038.filterp,tp,0,LOCATION_ONFIELD,1,e:GetHandler()) then
		local g=Duel.SelectTarget(tp,c11038.filterp,tp,0,LOCATION_ONFIELD,1,1,e:GetHandler())
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	else
		local g=Duel.SelectTarget(tp,c11038.filter,tp,0,LOCATION_ONFIELD,1,1,e:GetHandler())
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	end
end
function c11038.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c11038.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c11038.atktg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
end
function c11038.spfilter(c,e,tp,lv)
	return c:GetLevel()~=lv and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c11038.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	local lv=tc:GetLevel()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(ct*400)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local g=Duel.SelectMatchingCard(tp,c11038.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp,lv)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
