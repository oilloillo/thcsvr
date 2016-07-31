 
--永夜返 -初月-
function c21101.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c21101.cost)
	e1:SetTarget(c21101.target)
	e1:SetOperation(c21101.operation)
	c:RegisterEffect(e1)
end
function c21101.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,21101)==0 end
	Duel.RegisterFlagEffect(tp,21101,RESET_PHASE+PHASE_END,0,1)
end
function c21101.sfilter(c)
	return c:IsSetCard(0x257) and c:IsSSetable() and not c:IsCode(21101)
end
function c21101.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c21101.sfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c21101.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c21101.sfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
		Duel.ConfirmCards(1-tp,g)
		if g:GetFirst():IsType(TYPE_TRAP) then
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			g:GetFirst():RegisterEffect(e3)
			g:GetFirst():RegisterFlagEffect(21101,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
		end
	end
end
