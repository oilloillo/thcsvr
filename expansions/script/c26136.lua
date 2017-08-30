--大喝『守旧尊老之怒眼』
function c26136.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetCondition(c26136.condition)
	e1:SetTarget(c26136.damtg)
	e1:SetOperation(c26136.activate)
	c:RegisterEffect(e1)
end
function c26136.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x251b)
end
function c26136.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c26136.filter,tp,LOCATION_ONFIELD+LOCATION_EXTRA,0,1,nil)
end
function c26136.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(500)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
end
function c26136.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
	local count = Duel.GetTurnPlayer()==tp and 1 or 2
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,count)
	e1:SetTargetRange(1,1)
	Duel.RegisterEffect(e1,tp)
end
