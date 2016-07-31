 
--歌莉娅人形✿试验模式
function c20073.initial_effect(c)
	--atklimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetCondition(c20073.atkcon)
	c:RegisterEffect(e1)
	--self destroy
    local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(20073,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetProperty(EFFECT_FLAG_REPEAT)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c20073.tdcon)
	e2:SetTarget(c20073.tdtg)
	e2:SetOperation(c20073.tdop)
	c:RegisterEffect(e2)
	--cannot be battle target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e3:SetTarget(c20073.tg)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--cannot destroy
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(c20073.efilter)
	c:RegisterEffect(e5)
end
function c20073.afilter(c)
	return c:IsFaceup() and c:IsSetCard(0x300) and c:IsLevelAbove(5)
end
function c20073.atkcon(e)
	return not Duel.IsExistingMatchingCard(c20073.afilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
end
function c20073.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c20073.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c20073.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.Destroy(c,REASON_RULE)
	end
end
function c20073.tg(e,c)
	return c~=e:GetHandler() and (c:IsSetCard(0x186) or c:IsSetCard(0x300))
end
function c20073.efilter(e,re,rp,c)
	return re:GetHandler()~=c
end
