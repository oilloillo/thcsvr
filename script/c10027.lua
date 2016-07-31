 
--弑神炮
function c10027.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetTarget(c10027.target)
	e1:SetOperation(c10027.operation)
	c:RegisterEffect(e1)
	--Atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetCondition(c10027.atkcon)
	e2:SetValue(c10027.atkval)
	c:RegisterEffect(e2)
	--Equip limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EQUIP_LIMIT)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetValue(c10027.eqlimit)
	c:RegisterEffect(e3)
	--Atkup
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetValue(700)
	c:RegisterEffect(e4)
	--cannot disable
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CANNOT_DISABLE)
	c:RegisterEffect(e5)
end
function c10027.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x200)
end
function c10027.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c10027.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10027.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c10027.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c10027.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
    end
end
function c10027.eqlimit(e,c)
	return c:IsSetCard(0x200)
end
function c10027.atkfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DEVINE)
end
function c10027.atkcon(e)
	local ec=e:GetHandler():GetEquipTarget()
	if not ec:IsRelateToBattle() then return end
	local bc=ec:GetBattleTarget()
	return Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL and bc
		and bc:IsAttribute(ATTRIBUTE_DEVINE)
end
function c10027.atkval(e,c)
	return c:GetAttack()
end
