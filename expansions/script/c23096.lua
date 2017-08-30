--河中的便利屋✿河城荷取
function c23096.initial_effect(c)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(23096,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c23096.setcost)
	e2:SetTarget(c23096.settg)
	e2:SetOperation(c23096.setop)
	c:RegisterEffect(e2)
end
function c23096.cfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGraveAsCost()
end
function c23096.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c23096.cfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c23096.cfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
	if g:GetFirst():IsSetCard(0x820) then
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
end
function c23096.filter(c)
	return c:IsSetCard(0x820) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable(true)
end
function c23096.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>-1
		and Duel.IsExistingMatchingCard(c23096.filter,tp,LOCATION_DECK,0,1,nil) end
end
function c23096.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c23096.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		Duel.SSet(tp,tc)
		Duel.ConfirmCards(1-tp,tc)
		local t=e:GetLabel()
		if t==1 and tc:IsType(TYPE_TRAP) then
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			tc:RegisterEffect(e3)
		elseif t==0 then
			local e5=Effect.CreateEffect(e:GetHandler())
			e5:SetType(EFFECT_TYPE_SINGLE)
			e5:SetCode(EFFECT_CANNOT_ACTIVATE)
			e5:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			e5:SetValue(1)
			tc:RegisterEffect(e5)
		end
	end
end
