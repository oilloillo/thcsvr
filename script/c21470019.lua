 
--稻荷大人的听耳头巾
function c21470019.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c21470019.target)
	e1:SetOperation(c21470019.operation)
	c:RegisterEffect(e1)
	--atkdef
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(21470019,0))
	e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SSET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetOperation(c21470019.atkop)
	c:RegisterEffect(e3)
	--Equip limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EQUIP_LIMIT)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetValue(c21470019.eqlimit)
	c:RegisterEffect(e3)
end
function c21470019.eqlimit(e,c)
	return c:GetBaseAttack()<=2000 and c:GetBaseDefence()<=2000
end
function c21470019.filter(c)
	return c:IsFaceup() and c:GetBaseAttack()<=2000 and c:GetBaseDefence()<=2000
end
function c21470019.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() and c21470019.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c21470019.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c21470019.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c21470019.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function c21470019.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(400)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	ec:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_DEFENCE)
	e1:SetValue(400)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	ec:RegisterEffect(e1)
end