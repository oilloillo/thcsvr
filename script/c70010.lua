 
--BlackHeart
function c70010.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2,c70010.ovfilter,aux.Stringid(70010,0))
	c:EnableReviveLimit()
	--destroy replace
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c70010.destg)
	e1:SetValue(c70010.value)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(70010,2))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c70010.cost)
	e2:SetTarget(c70010.target)
	e2:SetOperation(c70010.operation)
	c:RegisterEffect(e2)
end
function c70010.ovfilter(c)
	return c:IsFaceup() and c:IsCode(70007) and bit.band(c:GetSummonType(),SUMMON_TYPE_NORMAL)==SUMMON_TYPE_NORMAL
end
function c70010.dfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsSetCard(0x149) and not c:IsReason(REASON_REPLACE) and c:IsControler(tp)
end
function c70010.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not eg:IsContains(e:GetHandler())
		and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) and eg:IsExists(c70010.dfilter,1,nil,tp) end
	if Duel.SelectYesNo(tp,aux.Stringid(70010,1)) then
		e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
		return true
	else return false end
end
function c70010.value(e,c)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsSetCard(0x149) and not c:IsReason(REASON_REPLACE) and c:IsControler(e:GetHandlerPlayer())
end
function c70010.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x149) and c:GetDefence()>=1000
end
function c70010.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) and Duel.IsExistingMatchingCard(c70010.cfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	g=Duel.SelectMatchingCard(tp,c70010.cfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	tc=g:GetFirst()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_DEFENCE)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	e1:SetValue(-1000)
	tc:RegisterEffect(e1)
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c70010.filter(c,atk)
	return c:IsFaceup() and c:GetAttack()>atk
end
function c70010.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c70010.filter(chkc,c:GetAttack()) end
	if chk==0 then return Duel.IsExistingTarget(c70010.filter,tp,0,LOCATION_MZONE,1,nil,c:GetAttack()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c70010.filter,tp,0,LOCATION_MZONE,1,1,nil,c:GetAttack())
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,g,1,0,0)
end
function c70010.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetFirstTarget()
	local gat=g:GetAttack()
	if g:IsFaceup() and g:IsRelateToEffect(e) and gat>c:GetAttack() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		e1:SetValue(gat/2)
		g:RegisterEffect(e1)
	end
end
