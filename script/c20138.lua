 
--最后的圣骑士✿歌莉娅人形
function c20138.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0x208),1)
	c:EnableReviveLimit()
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c20138.val)
	c:RegisterEffect(e1)
	--chain attack
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(20138,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLED)
	e2:SetCondition(c20138.atcon)
	e2:SetOperation(c20138.atop)
	c:RegisterEffect(e2)
	--cannot announce
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c20138.antarget)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e4:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e4:SetTarget(c20138.atlimit)
	e4:SetValue(1)
	c:RegisterEffect(e4)
end
function c20138.filter(c)
	return c:IsRace(RACE_MACHINE) and c:IsSetCard(0x186)
end
function c20138.val(e,c)
	return Duel.GetMatchingGroupCount(c20138.filter,c:GetControler(),LOCATION_GRAVE,0,nil)*300
end
function c20138.cfilter(c)
	return c:IsSetCard(0x300) and c:IsLevelAbove(5) and c:IsFaceup()
end
function c20138.atcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:IsStatus(STATUS_BATTLE_DESTROYED) and c:IsChainAttackable() and c:IsStatus(STATUS_OPPO_BATTLE)
	and Duel.IsExistingMatchingCard(c20138.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c20138.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToBattle() then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetLabelObject(e1)
	e2:SetOperation(aux.atrst)
	e2:SetReset(RESET_PHASE+PHASE_BATTLE)
	Duel.RegisterEffect(e2,tp)
end
function c20138.antarget(e,c)
	return c~=e:GetHandler()
end
function c20138.atlimit(e,c)
	return c~=e:GetHandler()
end
