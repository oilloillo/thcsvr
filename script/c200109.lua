--天候-天気雨
function c200109.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--defdown
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_DEFENCE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsPosition,POS_DEFENCE))
	e3:SetValue(-500)
	c:RegisterEffect(e3)
	--des
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_F)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c200109.tg)
	e2:SetOperation(c200109.op)
	c:RegisterEffect(e2)
end
function c200109.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.GetAttacker()
	local at=Duel.GetAttackTarget()
	if chk==0 then return Duel.GetTurnPlayer()==tp and at and at:IsPosition(POS_FACEUP_DEFENCE) and a:GetAttack()>at:GetDefence() end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,at,1,0,0)
end
function c200109.op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsOnField() then return end
	local at=Duel.GetAttackTarget()
	if at and at:IsPosition(POS_FACEUP_DEFENCE) then Duel.Destroy(at,REASON_EFFECT)	end
end