--山彦『山彦的本领发挥回音』
function c27148.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(c27148.condition)
	e1:SetTarget(c27148.target)
	e1:SetOperation(c27148.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e3:SetCondition(c27148.handcon)
	c:RegisterEffect(e3)
end
function c27148.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function c27148.filter(c)
	return c:IsDestructable()
end
function c27148.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Duel.GetAttacker()
	if chk==0 then return tg:IsOnField() and Duel.IsExistingMatchingCard(c27148.filter,tp,0,LOCATION_MZONE,1,tg) end
	local g=Duel.GetMatchingGroup(c27148.filter,tp,0,LOCATION_MZONE,tg)
	Duel.SetTargetCard(tg)
	local dam=tg:GetAttack()/2
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c27148.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local g=Duel.GetMatchingGroup(c27148.filter,tp,0,LOCATION_MZONE,tc)
	if tc:IsRelateToEffect(e) and g:GetCount()>0 then
		if Duel.Destroy(g,REASON_EFFECT)>0 then
			Duel.Damage(1-tp,tc:GetAttack()/2,REASON_EFFECT)
		end
	end
end
function c27148.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x527)
end
function c27148.handcon(e)
	return Duel.GetMatchingGroupCount(c27148.cfilter,e:GetHandler():GetControler(),LOCATION_MZONE,0,nil)>0
end
