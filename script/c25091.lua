 
--灵面-小面
function c25091.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c25091.target)
	e1:SetOperation(c25091.operation)
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
	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_EQUIP)
	e4:SetRange(LOCATION_SZONE)
	e4:SetOperation(c25091.op)
	c:RegisterEffect(e4)
	--destroy
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetOperation(c25091.dsop)
	c:RegisterEffect(e5)
end
function c25091.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c25091.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function c25091.op(e,tp,eg,ep,ev,re,r,rp)
	if eg:GetFirst()~=e:GetHandler() then return end
	local tc=e:GetHandler():GetEquipTarget()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(25091,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetLabelObject(e:GetHandler())
	e1:SetCondition(c25091.thcon)
	e1:SetTarget(c25091.thtg)
	e1:SetOperation(c25091.thop)
	tc:RegisterEffect(e1)
	if e1:GetHandler()==nil then return end
	--reset
	local e0=Effect.CreateEffect(e:GetHandler())
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_ADJUST)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCondition(c25091.thcon2)
	e0:SetOperation(c25091.dsop2)
	e0:SetLabelObject(e1)
	Duel.RegisterEffect(e0,tp)
end
function c25091.thcon(e)
	local g=e:GetHandler():GetEquipGroup()
	if g:IsContains(e:GetLabelObject()) then
		return not e:GetLabelObject():IsDisabled()
	else return false
	end
end
function c25091.filter1(c)
	return c:IsFaceup() and c:IsAbleToHand() and c:IsType(TYPE_EQUIP) and not c:IsCode(25091)
end
function c25091.filter2(c)
	return c:IsFaceup() and c:IsAbleToHand()
end
function c25091.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c25091.filter1,tp,LOCATION_ONFIELD,0,1,nil)
		and Duel.IsExistingTarget(c25091.filter2,tp,0,LOCATION_ONFIELD,1,nil) end
		Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g1=Duel.SelectTarget(tp,c25091.filter1,tp,LOCATION_ONFIELD,0,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g2=Duel.SelectTarget(tp,c25091.filter2,tp,0,LOCATION_ONFIELD,1,1,nil)
		g1:Merge(g2)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,2,0,0)
end
function c25091.hfilter(c,e)
	return c:IsRelateToEffect(e) and c:IsFaceup()
end
function c25091.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not g then return end
	g=g:Filter(c25091.hfilter,nil,e)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
function c25091.dsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetHandler():GetEquipTarget()
	if tc then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c25091.thcon2(e)
	local e1=e:GetLabelObject()
	local g=e1:GetHandler():GetEquipGroup()
	return g and not g:IsContains(e1:GetLabelObject())
end
function c25091.dsop2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabelObject() then
		e:GetLabelObject():Reset()
		e:Reset()
	end
end
