 
--绯想✿射命丸文
function c200011.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0x208),1)
	c:EnableReviveLimit()
	--field
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetOperation(c200011.fop)
	c:RegisterEffect(e4)
	--direct attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e1)
	--cant act
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(c200011.acon)
	e1:SetOperation(c200011.aop)
	c:RegisterEffect(e1)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetCountLimit(1)
--	e1:SetCost(c200011.scost)
	e1:SetTarget(c200011.stg)
	e1:SetOperation(c200011.sop)
	c:RegisterEffect(e1)
end
function c200011.fop(e,tp,eg,ep,ev,re,r,rp)
	local token=Duel.CreateToken(tp,200111)
	Duel.MoveToField(token,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
--	Duel.RaiseEvent(token,EVENT_CHAIN_SOLVED,token:GetActivateEffect(),0,tp,tp,Duel.GetCurrentChain())
end
function c200011.acon(e)
	return Duel.GetAttackTarget()==nil
end
function c200011.aop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c200011.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,tp)
end
function c200011.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP+TYPE_MONSTER)
end
function c200011.scost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c200011.filter(c)
	return c:IsCode(200211) and c:IsAbleToHand()
end
function c200011.stg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return ep~=tp and
	Duel.GetAttacker()==e:GetHandler() and Duel.GetAttackTarget()==nil and 
	e:GetHandler():GetAttack()>=500 and
	Duel.IsExistingMatchingCard(c200011.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c200011.sop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c200011.filter,tp,LOCATION_DECK,0,1,nil) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(-500)
		e:GetHandler():RegisterEffect(e1)
		local g=Duel.GetFirstMatchingCard(c200011.filter,tp,LOCATION_DECK,0,nil)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end