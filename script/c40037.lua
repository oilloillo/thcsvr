 
--精灵魔装-冰之魔弓
function c40037.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(c40037.cost)
	e1:SetTarget(c40037.target)
	e1:SetOperation(c40037.operation)
	c:RegisterEffect(e1)
	--Atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(300)
	c:RegisterEffect(e2)
	--Equip limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EQUIP_LIMIT)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetValue(c40037.eqlimit)
	c:RegisterEffect(e3)
	--atk change
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(40037,0))
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1)
	e4:SetTarget(c40037.cgtg)
	e4:SetOperation(c40037.cgop)
	c:RegisterEffect(e4)
	--destroy
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(40037,1))
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1)
	e5:SetTarget(c40037.destg)
	e5:SetOperation(c40037.desop)
	c:RegisterEffect(e5)
end
function c40037.eqlimit(e,c)
	return c:IsSetCard(0x430) and c:IsAttribute(ATTRIBUTE_WATER)
end
function c40037.refilter(c)
	return c:IsCode(40025) and c:IsAbleToRemoveAsCost()
end
function c40037.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x430) and c:IsAttribute(ATTRIBUTE_WATER)
end
function c40037.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40037.refilter,tp,0x16,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c40037.refilter,tp,0x16,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c40037.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c40037.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c40037.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c40037.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c40037.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
    end
end
function c40037.aefilter(c)
	return c:IsFaceup() and not c:IsDisabled()
end
function c40037.cgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c40037.aefilter(chkc) and chkc:GetLocation()==LOCATION_ONFIELD and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(c40037.aefilter,tp,0,LOCATION_ONFIELD,1,nil) and Duel.GetCurrentPhase()==PHASE_BATTLE end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c40037.aefilter,tp,0,LOCATION_ONFIELD,1,1,nil)
end
function c40037.cgop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		if tc:IsType(TYPE_MONSTER) then
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			e2:SetValue(-500)
			tc:RegisterEffect(e2)
		end
	end
end
function c40037.desfilter(c)
	return c:IsDestructable() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c40037.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c40037.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c40037.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler())
		and Duel.GetTurnPlayer()~=tp end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c40037.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c40037.desop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
