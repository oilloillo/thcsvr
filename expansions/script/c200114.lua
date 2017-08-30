--天候-台风
function c200114.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c200114.target)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_BATTLE_START)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c200114.tg)
	e2:SetOperation(c200114.op)
	c:RegisterEffect(e2)
end
function c200114.target(e,c)
	local x=c:GetOriginalCode()
	return c:IsPosition(POS_FACEUP_ATTACK) and ((x>=200001 and x<=200020) or (x==25016))
end
function c200114.filter(c)
	local x=c:GetOriginalCode()
	return c:IsPosition(POS_FACEUP_ATTACK) and ((x>=200001 and x<=200020) or (x==25016))
end
function c200114.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.GetAttacker()
	if tp~=Duel.GetTurnPlayer() then a=Duel.GetAttackTarget() end
	if chk==0 then return Duel.GetAttackTarget() and a and c200114.filter(a) end
end
function c200114.op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsOnField() then return end
	local c=e:GetHandler()
	local a=Duel.GetAttacker()
	local at=Duel.GetAttackTarget()
	if a:IsAttackable() and a:IsFaceup() and at then
		if Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil)  
		and Duel.SelectYesNo(tp,aux.Stringid(200114,0)) then
			Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_EFFECT+REASON_DISCARD)
		else
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetCode(EFFECT_DISABLE)
			e2:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
			e2:SetTarget(c200114.bantg)
			e2:SetLabelObject(c)
			e2:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e2,tp)
		end
	end
end
function c200114.bantg(e,c)
	return c==e:GetLabelObject()
end