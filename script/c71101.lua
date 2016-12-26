--N0 Name 逆回十六夜
function c71101.initial_effect(c)
    c:SetUniqueOnField(1,0,71101)
	c:EnableReviveLimit()
	--redirect 战破除外
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCondition(c71101.spcon)
	e4:SetCode(EFFECT_BATTLE_DESTROY_REDIRECT)
	e4:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e4)
	--pierce
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCondition(c71101.spcon)
	e5:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e5)
	--remove 除外
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e2:SetCondition(c71101.spcon)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e2)
	--negate 战阶
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71101,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(TIMING_BATTLE_START,0)
	e1:SetCondition(c71101.negcon)
	e1:SetTarget(c71101.negtg)
	e1:SetOperation(c71101.negop)
	c:RegisterEffect(e1)
	end
function c71101.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_RITUAL
end
function c71101.filter1(c)
	return c:IsFaceup() and not c:IsDisabled() and c:IsType(TYPE_MONSTER)
end
function c71101.tgvalue(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end
function c71101.negcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_REMOVED) and Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_BATTLE and not Duel.CheckPhaseActivity() and Duel.GetCurrentChain()==0
end
function c71101.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71101.filter1,tp,0,LOCATION_MZONE,1,nil) end
end
function c71101.negop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c71101.filter1,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	if not tc then return end
	local c=e:GetHandler()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,2)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,2)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
	local atk=Duel.GetMatchingGroupCount(Card.IsFaceup,tp,0,LOCATION_MZONE,c)*300
	if atk>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END,2)
		c:RegisterEffect(e1)
	end
end

