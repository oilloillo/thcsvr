--丰符「大年收获者」
function c999305.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetDescription(aux.Stringid(999305,0))
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_RECOVER)
	e1:SetCost(c999305.cost)
	e1:SetTarget(c999305.tg)
	e1:SetOperation(c999305.op)
	c:RegisterEffect(e1)
	-- 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetDescription(aux.Stringid(999305,1))	
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsCode,999300))
	e2:SetValue(600)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENCE)
	c:RegisterEffect(e3)
end

c999305.DescSetName=0xa2

function c999305.filter(c)
	return c:IsRace(RACE_PLANT) and c:IsFaceup()
end

function c999305.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,800) 
		and Duel.IsExistingMatchingCard(c999305.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.PayLPCost(tp,800)
end

function c999305.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,PLAYER_ALL,1600)
end

function c999305.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,1600,REASON_EFFECT)
	Duel.Recover(1-tp,1600,REASON_EFFECT)
	local g = Duel.GetMatchingGroup(c999305.filter,tp,LOCATION_MZONE,0,nil)
	if g:GetCount()>0 then
		Duel.BreakEffect()
		local tc=g:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(600)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENCE)
			tc:RegisterEffect(e2)
			tc=g:GetNext()
		end
	end
end