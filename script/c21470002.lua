 
--妖魔书收藏家✿本居小铃
function c21470002.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21470002,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c21470002.spcost)
	e1:SetTarget(c21470002.sptg)
	e1:SetOperation(c21470002.spop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21470002,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCost(c21470002.cost)
	e2:SetTarget(c21470002.target)
	e2:SetOperation(c21470002.operation)
	c:RegisterEffect(e2)
	--set
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(21470002,2))
	e3:SetCategory(CATEGORY_POSITION+CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1)
	e3:SetTarget(c21470002.settg)
	e3:SetOperation(c21470002.setop)
	c:RegisterEffect(e3)
end
function c21470002.cffilter(c)
	return c:IsSetCard(0x742) and not c:IsPublic()-- and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c21470002.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21470002.cffilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c21470002.cffilter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c21470002.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c21470002.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c21470002.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c21470002.filter(c)
	return c:GetOriginalCode()==(21470001) and c:IsAbleToHand()
end
function c21470002.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21470002.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c21470002.operation(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetFirstMatchingCard(c21470002.filter,tp,LOCATION_DECK,0,nil)
	if tg then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
		Duel.ShuffleHand(tp)
	end
end
function c21470002.setfilter(c)
	return c:IsSetCard(0x742) and c:IsCanTurnSet() and c:IsFaceup()
end
function c21470002.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and c21470002.setfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c21470002.setfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c21470002.setfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	if g:GetFirst():IsType(TYPE_MONSTER) then Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0) end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
end
function c21470002.setop(e,tp,eg,ep,ev,re,r,rp)
	tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		if c21470002.setfilter(tc) then 
			if tc:IsType(TYPE_MONSTER) then 
				if tc:IsType(TYPE_TRAPMONSTER) then 
					Duel.ChangePosition(tc,POS_FACEDOWN_DEFENCE) 
					tc:RegisterFlagEffect(21470020,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
				else Duel.ChangePosition(tc,POS_FACEDOWN_DEFENCE) end
			else 
				Duel.ChangePosition(tc,POS_FACEDOWN)
				Duel.RaiseEvent(tc,EVENT_SSET,e,REASON_EFFECT,tp,tc:GetControler(),0) 
				tc:RegisterFlagEffect(21470020,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
			end
			Duel.Recover(tp,1000,REASON_EFFECT)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetCode(EFFECT_CANNOT_ACTIVATE)
			e1:SetTargetRange(1,0)
			e1:SetValue(c21470002.aclimit)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)--[[
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_TRIGGER)
			e1:SetReset(RESET_PHASE+PHASE_END)
			e1:SetValue(1)
			tc:RegisterEffect(e1)]]
		end
		--[[
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetOperation(c21470002.set)
		Duel.RegisterEffect(e1,tp)
		]]
	end
end
function c21470002.aclimit(e,re,tp)
	return not re:GetHandler():IsSetCard(0x742)
end
--[[
function c21470002.set(e,tp,eg,ep,ev,re,r,rp)
	if tc:IsFaceup() then 
		if tc:IsAbleToHand() then 
			Duel.SendtoHand(tc,nil,REASON_EFFECT)	
			if tc:IsLocation(LOCATION_HAND) then
				if tc:IsSSetable() then Duel.SSet(tp,tc) end
					Duel.BreakEffect()
					Duel.Recover(tp,500,REASON_EFFECT)
--				else Duel.SendtoGrave(tc,REASON_RULE) end
			end
		end
	end
end]]