--禁弹『星弧破碎』
function c999403.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c999403.target)
	e1:SetOperation(c999403.activate)
	c:RegisterEffect(e1)
	--lvdown
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(999403,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,0x1c0)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c999403.lvcost)
	e2:SetCondition(c999403.lvcon)
	e2:SetOperation(c999403.lvop)
	c:RegisterEffect(e2)
end
c999403.DescSetName = 0xa3 

function c999403.filter(c)
	return not c:IsPosition(POS_FACEUP_DEFENCE)
end
function c999403.deffilter(c)
	return c:GetDefence()>0 and c:IsFaceup()
end
function c999403.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c999403.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c999403.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function c999403.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c999403.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.ChangePosition(g,POS_FACEUP_DEFENCE)

	if Duel.IsExistingMatchingCard(c999403.thfilter,tp,LOCATION_MZONE,0,1,nil) then
		Duel.BreakEffect()
		local defg = Duel.GetMatchingGroup(c999403.deffilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		if defg:GetCount()>0 then
			local tc=defg:GetFirst()
			while tc do
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_SET_DEFENCE)
				e1:SetValue(0)
				e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e1)
				tc=defg:GetNext()
			end
		end
	end
end

function c999403.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end

function c999403.thfilter(c)
	return c:IsSetCard(0x815)
end

function c999403.lvcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsType, tp, LOCATION_MZONE+LOCATION_HAND, LOCATION_MZONE, 1, nil, TYPE_MONSTER)
end

function c999403.costfilter(c)
	return c:IsCode(999403) and c:IsAbleToRemoveAsCost()
end

function c999403.lvcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c999403.costfilter, tp, LOCATION_GRAVE, 0, nil)
	local rep = Duel.GetFlagEffect(tp, 999410)
	local num = 2 - rep
	if num < 1 then num = 1 end
	if chk==0 then return g:GetCount()>=num end
	local rg=g:RandomSelect(tp,num)
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
	Duel.ResetFlagEffect(tp, 999410)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
end

function c999403.lvop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_LEVEL)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,LOCATION_HAND+LOCATION_MZONE)
	e1:SetValue(-2)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end