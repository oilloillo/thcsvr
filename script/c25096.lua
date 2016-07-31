 
--灵面-火男
function c25096.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c25096.target)
	e1:SetOperation(c25096.operation)
	c:RegisterEffect(e1)
	--atk,def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(-800)
	c:RegisterEffect(e2)
	--equip limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EQUIP_LIMIT)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--draw
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_EQUIP)
	e4:SetRange(LOCATION_SZONE)
	--e4:SetReset(RESET_EVENT+0xde0000)
	e4:SetOperation(c25096.op)
	c:RegisterEffect(e4)
	--destroy
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetOperation(c25096.dsop)
	c:RegisterEffect(e5)
end
function c25096.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c25096.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function c25096.op(e,tp,eg,ep,ev,re,r,rp)
	if eg:GetFirst()~=e:GetHandler() then return end
	local tc=e:GetHandler():GetEquipTarget()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(25096,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	--e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetLabelObject(e:GetHandler())
	e1:SetCondition(c25096.thcon)
	e1:SetTarget(c25096.thtg)
	e1:SetOperation(c25096.thop)
	tc:RegisterEffect(e1)
	if e1:GetHandler()==nil then return end
	--reset
	local e0=Effect.CreateEffect(e:GetHandler())
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_ADJUST)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCondition(c25096.thcon2)
	e0:SetOperation(c25096.dsop2)
	e0:SetLabelObject(e1)
	Duel.RegisterEffect(e0,tp)
end
function c25096.thcon(e)
	local g=e:GetHandler():GetEquipGroup()
	if g:IsContains(e:GetLabelObject()) then
		return not e:GetLabelObject():IsDisabled()
	else return false
	end
end
function c25096.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c25096.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
end
function c25096.dsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetHandler():GetEquipTarget()
	if tc then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
	end
end
function c25096.thcon2(e)
	local e1=e:GetLabelObject()
	local g=e1:GetHandler():GetEquipGroup()
	return not e1:GetHandler():IsImmuneToEffect(e) and g and not g:IsContains(e1:GetLabelObject())
end
function c25096.dsop2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabelObject() then
		e:GetLabelObject():Reset()
		e:Reset()
	end
end