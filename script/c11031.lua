 
--死之天使 萨丽爱尔
function c11031.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0x208),2)
	c:EnableReviveLimit()
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21004,0))
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetTarget(c11031.lptg)
	e1:SetOperation(c11031.lpop)
	c:RegisterEffect(e1)
	--cant be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(0xff)
	e2:SetCountLimit(1)
	e2:SetCondition(c11031.condition)
	e2:SetOperation(c11031.operation)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetCondition(c11031.indcon)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--specialsummon & destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(11031,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN+CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCondition(c11031.descondition)
	e4:SetTarget(c11031.destarget)
	e4:SetOperation(c11031.desoperation)
	c:RegisterEffect(e4)
end
function c11031.lptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return ep~=tp and Duel.GetAttackTarget()==nil end
end
function c11031.lpop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(1-tp,Duel.GetLP(1-tp)/2)
end
function c11031.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL)
end
function c11031.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,11031,RESET_PHASE+PHASE_END,0,1)
	Duel.RegisterFlagEffect(1-tp,11031,RESET_PHASE+PHASE_END,0,1)
end
function c11031.indcon(e,tp)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFlagEffect(tp,11031)~=0
end
function c11031.descondition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c11031.destarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,11034,0,0x4011,4000,4000,10,RACE_ZOMBIE,ATTRIBUTE_DARK) end
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c11031.desoperation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,11034,0,0x4011,4000,4000,10,RACE_ZOMBIE,ATTRIBUTE_DARK) then return end
	local token=Duel.CreateToken(tp,11034)
	Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetOperation(c11031.adjustop)
	token:RegisterEffect(e1)
	Duel.SpecialSummonComplete()
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
	Duel.Destroy(g,REASON_EFFECT)
end
function c11031.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	e1:SetCode(EFFECT_UPDATE_DEFENCE)
	e1:SetValue(-500)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	c:RegisterEffect(e2)
end
