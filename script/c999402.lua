--禁弹『折反射』
--require "expansions/nef/nef"
function c999402.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetDescription(aux.Stringid(999402,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetCondition(c999402.con)
	e1:SetCost(c999402.cost)
	e1:SetOperation(c999402.activate)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(999402,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_DAMAGE)
	e2:SetCondition(c999402.condition)
	e2:SetTarget(c999402.target)
	e2:SetOperation(c999402.operation)
	c:RegisterEffect(e2)
end

c999402.DescSetName = 0xa3 

function c999402.costfilter(c)
	return c:IsSetCard(0x815)
end

function c999402.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c999402.costfilter,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,c999402.costfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
	e:SetLabel(g:GetFirst():GetAttack())
end

function c999402.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(Card.IsType,tp,0,LOCATION_MZONE,nil,TYPE_MONSTER)>0
end

function c999402.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local atk=e:GetLabel()
	while atk>=400 do
		local random = math.random(1,2)
		local mg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
		if random==2 and mg:GetCount()>0 then
			local tc=mg:RandomSelect(tp, 1):GetFirst()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(-800)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENCE)
			tc:RegisterEffect(e2)
			if tc:GetDefence()<=0 or tc:GetAttack()<=0 then
				Duel.Destroy(tc, REASON_EFFECT)
			end
		else
			Duel.Damage(1-tp, 500, REASON_EFFECT)
		end
		atk = atk - 400
	end
end

function c999402.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end

function c999402.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0)
end

function c999402.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		Duel.Damage(1-tp,1000,REASON_EFFECT)
	end
end