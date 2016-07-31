 
--红魔器-冈格尼尔
function c22110.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c22110.target)
	e1:SetOperation(c22110.operation)
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
	e3:SetValue(c22110.eqlimit)
	c:RegisterEffect(e3)
	--unaffectable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetValue(c22110.efilter)
	c:RegisterEffect(e4)
	--Pierce
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_EQUIP)
	e5:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e5)
	--draw
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(22110,0))
	e6:SetCategory(CATEGORY_DRAW)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_DAMAGE)
	e6:SetRange(LOCATION_SZONE)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetCondition(c22110.drcon)
	e6:SetTarget(c22110.drtg)
	e6:SetOperation(c22110.drop)
	c:RegisterEffect(e6)
end
function c22110.eqlimit(e,c)
	return c:IsSetCard(0x814) or c:IsCode(93483212)
end
function c22110.filter(c)
	return c:IsFaceup() and (c:IsSetCard(0x814) or c:IsCode(93483212))
end
function c22110.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c22110.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c22110.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c22110.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c22110.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
    end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_SZONE)
	e1:SetProperty(EFFECT_FLAG_REPEAT)
	e1:SetCountLimit(1)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetOperation(c22110.tgop)
	e:GetHandler():RegisterEffect(e1)
end
function c22110.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() then
		Duel.SendtoGrave(c,REASON_EFFECT)
	end
end
function c22110.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c22110.drcon(e,tp,eg,ep,ev,re,r,rp,chk)
	if r==REASON_BATTLE then 
	return ep~=tp and eg:GetFirst()==e:GetHandler():GetEquipTarget()
	else return ep~=tp and re:GetHandler()==e:GetHandler():GetEquipTarget()
	end
end
function c22110.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c22110.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
