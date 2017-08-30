 
--生命游戏-Life Game-
function c21041.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RECOVER+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c21041.condition)
	e1:SetTarget(c21041.target)
	e1:SetOperation(c21041.activate)
	c:RegisterEffect(e1)
end
function c21041.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x208)
end
function c21041.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c21041.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c21041.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,300)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,300)
end
function c21041.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,300,REASON_EFFECT)
	Duel.Damage(1-tp,300,REASON_EFFECT)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SET_SUMMON_COUNT_LIMIT)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(2)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
