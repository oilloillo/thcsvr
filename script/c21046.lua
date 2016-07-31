 
--月之都 -真实之月-
function c21046.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x132))
	e2:SetValue(500)
	c:RegisterEffect(e2)
	--negate
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_BE_BATTLE_TARGET)
	e4:SetCondition(c21046.negcon)
	e4:SetOperation(c21046.negop)
	c:RegisterEffect(e4)
end

c21046.DescSetName=0x258

function c21046.negcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local code=tc:GetOriginalCode()
	local mt=_G["c" .. code]
	return mt and tc:IsFaceup() and mt.DescSetName == 0x258 and tc:IsControler(tp) and tc:IsLocation(LOCATION_MZONE) and tc:IsAbleToRemove()
end
function c21046.negop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if not e:GetHandler():IsRelateToEffect(e) or not tc:IsRelateToBattle() then return end
	Duel.NegateAttack()
	Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
end
