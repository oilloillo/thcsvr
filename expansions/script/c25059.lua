--无名之丘
function c25059.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_NO_TURN_RESET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_RELEASE)
	e2:SetCountLimit(1)
	e2:SetCondition(c25059.condition)
	e2:SetOperation(c25059.operation)
	c:RegisterEffect(e2)
	--Atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTarget(c25059.tg)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetValue(400)
	--c:RegisterEffect(e3)
	--Def
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_UPDATE_DEFENCE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTarget(c25059.tg)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetValue(400)
	--c:RegisterEffect(e4)
	--spell set
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(25059,0))
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_NO_TURN_RESET)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetCountLimit(1)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTarget(c25059.stg)
	e5:SetOperation(c25059.sop)
	c:RegisterEffect(e5)
	--cant be target
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e6:SetCondition(c25059.indcon)
	e6:SetValue(1)
	c:RegisterEffect(e6)
end
function c25059.cfilter(c)
	return c:IsSetCard(0x208) and c:IsAttribute(ATTRIBUTE_DARK)
end
function c25059.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c25059.cfilter,1,nil)
end
function c25059.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,25059)
	Duel.Draw(tp,1,REASON_EFFECT)
end
function c25059.tg(e,c)
	return c:IsAttribute(ATTRIBUTE_DARK)
end
function c25059.filter(c)
	return (bit.band(c:GetReason(),REASON_DISCARD)~=0 or bit.band(c:GetReason(),REASON_RELEASE)~=0)
		and c:IsSetCard(0x208) and c:IsAbleToHand() and c:IsAttribute(ATTRIBUTE_WATER)
end
function c25059.stg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c25059.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c25059.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectTarget(tp,c25059.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c25059.sop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
    end
end
function c25059.ifilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WIND)
end
function c25059.indcon(e)
	return Duel.IsExistingMatchingCard(c25059.ifilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
end
