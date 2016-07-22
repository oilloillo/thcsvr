--天候-浓雾
function c200107.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetCode(EVENT_DAMAGE_STEP_END)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c200107.target)
	e2:SetOperation(c200107.operation)
	c:RegisterEffect(e2)
	--lp
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(200107,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c200107.con)
	e1:SetOperation(c200107.op)
	c:RegisterEffect(e1)
end
function c200107.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.GetAttacker()
	local at=Duel.GetAttackTarget()
	local g=Group.CreateGroup()
	if a:IsLocation(LOCATION_MZONE) and not a:IsStatus(STATUS_DESTROY_CONFIRMED) then g:AddCard(a) end
	if at and at:IsLocation(LOCATION_MZONE) and not at:IsStatus(STATUS_DESTROY_CONFIRMED) then g:AddCard(at) end
	if chk==0 then return g:GetCount()>0 end
end
function c200107.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsOnField() then return end
	local a=Duel.GetAttacker()
	local at=Duel.GetAttackTarget()
	local g=Group.CreateGroup()
	if a:IsLocation(LOCATION_MZONE) and not a:IsStatus(STATUS_DESTROY_CONFIRMED) then g:AddCard(a) end
	if at and at:IsLocation(LOCATION_MZONE) and not at:IsStatus(STATUS_DESTROY_CONFIRMED) then g:AddCard(at) end
	local sg=g:Filter(Card.IsRelateToBattle,nil)
	if sg:GetCount()>0 then 
		local tc=sg:GetFirst()
		while tc do 
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			e2:SetValue(500)
			tc:RegisterEffect(e2)
			tc=sg:GetNext()
		end
	end
end
function c200107.filter(c)
	return c:IsFaceup() and c:GetAttack()>c:GetBaseAttack() and not (c:GetAttack()==0)
end
function c200107.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c200107.filter,tp,LOCATION_MZONE,0,1,nil)
end
function c200107.op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsOnField() then return end
	local g=Duel.GetMatchingGroup(c200107.filter,tp,LOCATION_MZONE,0,nil)
	if g:GetCount()>0 then
		local lp=0
		local atk=0
		local newatk=0
		local tc=g:GetFirst()
		while tc do
			atk=tc:GetAttack()
			newatk=tc:GetBaseAttack()
			if newatk<0 then newatk=0 end
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(newatk)
			tc:RegisterEffect(e1)
			lp=lp+atk-newatk
			tc=g:GetNext()
		end
		if lp>3000 then lp=3000 end
		Duel.Recover(tp,lp,REASON_EFFECT)
		Duel.Remove(e:GetHandler(),POSITION_FACEUP,REASON_EFFECT)
	end
end