 
--莱瓦汀
function c22111.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c22111.target)
	e1:SetOperation(c22111.operation)
	c:RegisterEffect(e1)
	--Atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(600)
	c:RegisterEffect(e2)
	--Equip limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EQUIP_LIMIT)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetValue(c22111.eqlimit)
	c:RegisterEffect(e3)
	--unaffectable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetValue(c22111.efilter)
	c:RegisterEffect(e4)
	--damage
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(22111,0))
	e6:SetCategory(CATEGORY_DAMAGE)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_DAMAGE)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCondition(c22111.damcon)
	e6:SetTarget(c22111.damtg)
	e6:SetOperation(c22111.damop)
	c:RegisterEffect(e6)
end
c22111.DescSetName = 0xa3
function c22111.eqlimit(e,c)
	return c:IsSetCard(0x815) and c:IsType(TYPE_MONSTER)
end
function c22111.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x815) and c:IsType(TYPE_MONSTER)
end
function c22111.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c22111.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c22111.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c22111.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function c22111.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
    end
end
function c22111.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() then
		Duel.SendtoGrave(c,REASON_EFFECT)
	end
end
function c22111.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c22111.damcon(e,tp,eg,ep,ev,re,r,rp)
	if r==REASON_BATTLE then 
	return ep~=tp and eg:GetFirst()==e:GetHandler():GetEquipTarget()
	else return ep~=tp and re:GetHandler()==e:GetHandler():GetEquipTarget()
	end
end
function c22111.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local rt=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)*300
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(rt)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,rt)
end
function c22111.damop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local rt=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)*300
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Damage(p,rt,REASON_EFFECT)
end
