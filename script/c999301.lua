--秋之神明✿秋静叶
function c999301.initial_effect(c)
	-- search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(999301,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetTarget(c999301.thtg)
	e1:SetOperation(c999301.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	-- remove and act
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(999301,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1)
	e3:SetHintTiming(0,0x1e1)
	e3:SetCost(c999301.cost)
	e3:SetTarget(c999301.target)
	e3:SetOperation(c999301.operation)
	c:RegisterEffect(e3)
end

c999301.DescSetName=0xa2

function c999301.filter(c)
	return c:GetLevel()==2 and c:IsRace(RACE_PLANT) and c:IsSetCard(0x208) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end

function c999301.filter2(c)
	return c:IsFaceup() and not c:IsRace(RACE_PLANT) 
end

function c999301.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c999301.filter,tp,LOCATION_DECK,0,1,nil) 
		and not Duel.IsExistingMatchingCard(c999301.filter2,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function c999301.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c999301.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function c999301.filter1(c)
	local code=c:GetOriginalCode()
	local mt=_G["c" .. code]
	return mt and mt.DescSetName == 0xa2 and c:IsType(TYPE_SPELL) and not c:IsType(TYPE_CONTINUOUS)
		and c:IsAbleToRemoveAsCost() and c:CheckActivateEffect(false,true,false)~=nil
end

function c999301.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then 
		return Duel.IsExistingMatchingCard(c999301.filter1,tp,LOCATION_GRAVE,0,1,nil)
		-- local flag1 = Duel.IsExistingMatchingCard(c999301.filter1,tp,LOCATION_GRAVE,0,1,nil)
		-- local flag2 = Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) 
		-- if Duel.GetTurnPlayer()==tp then
		-- 	return flag1
		-- else
		-- 	return flag1 and flag2
		-- end 
	end

	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(999301,1))
	local g=Duel.SelectMatchingCard(tp,c999301.filter1,tp,LOCATION_GRAVE,0,1,1,nil)
	local te=g:GetFirst():CheckActivateEffect(false,true,true)
	Duel.Remove(g,POS_FACEUP,REASON_COST)

	-- if Duel.GetTurnPlayer()~=tp then
	-- 	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
	-- end

	c999301[Duel.GetCurrentChain()]=te
end

function c999301.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local te=c999301[Duel.GetCurrentChain()]
	if chkc then
		local tg=te:GetTarget()
		return tg(e,tp,eg,ep,ev,re,r,rp,0,true)
	end
	if chk==0 then return true end
	if not te then return end
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
end

function c999301.operation(e,tp,eg,ep,ev,re,r,rp)
	local te=c999301[Duel.GetCurrentChain()]
	if not te then return end 
	local cost=te:GetCost()
	if cost then 
		if cost(e,tp,eg,ep,ev,re,r,rp,0)==false then return end
		cost(e,tp,eg,ep,ev,re,r,rp,chk) 
	end
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end