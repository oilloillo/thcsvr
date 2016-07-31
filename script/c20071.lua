 
--伦敦人形
function c20071.initial_effect(c)
	--c:SetUniqueOnField(1,1,20071)
	--atk down
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCondition(c20071.con)
	e1:SetTarget(c20071.tg)
	e1:SetOperation(c20071.op)
	c:RegisterEffect(e1)
	--recover
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c20071.condition)
	e2:SetOperation(c20071.operation)
	c:RegisterEffect(e2)
end
function c20071.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsSetCard(0x186)
end
function c20071.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(e:GetHandlerPlayer(),800,REASON_EFFECT)
end
function c20071.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c20071.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
end
function c20071.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		local sc=g:GetFirst()
		while sc do	
		    local e1=Effect.CreateEffect(e:GetHandler())
		    e1:SetType(EFFECT_TYPE_SINGLE)
		    e1:SetCode(EFFECT_UPDATE_ATTACK)
		    e1:SetReset(RESET_EVENT+0x1fe0000)
		    e1:SetValue(-800)
		    sc:RegisterEffect(e1)
		    local e2=e1:Clone()
		    e2:SetCode(EFFECT_UPDATE_DEFENCE)
		    sc:RegisterEffect(e2)
		    sc=g:GetNext()
		end
	end
end
