--秋符『秋季的天空』
function c999309.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	-- draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(999309,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetCountLimit(1, EFFECT_COUNT_CODE_SINGLE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCost(c999309.cost)
	e2:SetTarget(c999309.tg1)
	e2:SetOperation(c999309.op1)
	c:RegisterEffect(e2)
	-- sp
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(999309,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1, EFFECT_COUNT_CODE_SINGLE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCost(c999309.cost)
	e3:SetTarget(c999309.tg2)
	e3:SetOperation(c999309.op2)
	c:RegisterEffect(e3)
	-- set
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(999309,2))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCountLimit(1,999309)
	e4:SetRange(LOCATION_SZONE+LOCATION_GRAVE)
	e4:SetCost(c999309.cost2)
	e4:SetTarget(c999309.tg3)
	e4:SetOperation(c999309.op3)
	c:RegisterEffect(e4)
end

c999309.DescSetName=0xa2

function c999309.filter(c)
	return c:IsRace(RACE_PLANT) and c:IsFaceup()
end

function c999309.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,800) 
		and Duel.IsExistingMatchingCard(c999309.filter,tp,LOCATION_MZONE,0,1,nil) 
		and e:GetHandler():GetFlagEffect(999309)==0 end
	Duel.PayLPCost(tp,800)
	e:GetHandler():RegisterFlagEffect(999309, RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end

function c999309.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp, 1) 
		and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end

function c999309.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	local g=Duel.GetMatchingGroup(Card.IsDiscardable, p, LOCATION_HAND, 0, nil)
	if g:GetCount()>0 then
		local sg=g:RandomSelect(p,1)
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
		Duel.Draw(p,d,REASON_EFFECT)
	end
end

function c999309.spfilter(c,e,tp)
	return c:GetLevel()<=2 and c:IsRace(RACE_PLANT) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function c999309.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c999309.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end

function c999309.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c999309.spfilter, tp, LOCATION_HAND, 0, nil, e, tp)
	if g:GetCount()<1 then return end 
	local sg=g:RandomSelect(tp,1)
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
end

function c999309.tdfilter(c)
	local code=c:GetOriginalCode()
	local mt=_G["c" .. code]
	return mt and mt.DescSetName == 0xa2 and (c:IsAbleToDeckAsCost() or c:IsAbleToExtraAsCost()) and c:IsFaceup()
end

function c999309.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroupCount(c999309.tdfilter, tp, LOCATION_GRAVE+LOCATION_REMOVED, 0, e:GetHandler())>=5 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp, c999309.tdfilter, tp, LOCATION_GRAVE+LOCATION_REMOVED, 0, 5, 5, e:GetHandler())
	Duel.SendtoDeck(g, nil, 1, REASON_COST)
	Duel.ShuffleDeck(tp)
end

function c999309.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then 
		if c:IsLocation(LOCATION_GRAVE) then 
			return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and c:IsSSetable()
		elseif c:IsLocation(LOCATION_SZONE) then
			return c:IsSSetable()
		end
	end
end

function c999309.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if c:IsLocation(LOCATION_GRAVE) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and c:IsSSetable() then 
		Duel.SSet(tp,c)
	elseif c:IsLocation(LOCATION_SZONE) and c:IsSSetable() then
		Duel.ChangePosition(c,POS_FACEDOWN)
		Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	end
end