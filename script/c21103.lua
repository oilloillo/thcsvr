 
--永夜返 -上弦月-
function c21103.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetTarget(c21103.target)
	e1:SetOperation(c21103.activate)
	c:RegisterEffect(e1)
end
function c21103.sfilter(c)
	return c:IsSetCard(0x257) and c:IsSSetable()
end
function c21103.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>3 end
end
function c21103.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.ConfirmDecktop(tp,4)
	local g=Duel.GetDecktopGroup(tp,4)
	if g:GetCount()>0 then
		local gc=g:FilterCount(Card.IsSetCard,nil,0x257)
		if g:IsExists(c21103.sfilter,1,nil) then
			local sg=g:FilterSelect(tp,c21103.sfilter,1,1,nil)
			local tg=sg:GetFirst()
			Duel.SSet(tp,tg)
			Duel.ConfirmCards(1-tp,tg)
			g:RemoveCard(tg)
			Duel.SendtoGrave(g,REASON_EFFECT)
		else
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
		local ph=Duel.GetCurrentPhase()
		if Duel.GetTurnPlayer()~=tp and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2) then
			Duel.Hint(HINT_NUMBER,tp,gc)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_MSET)
			e1:SetReset(RESET_PHASE+PHASE_END)
			e1:SetOperation(c21103.operation)
			e1:SetLabel(gc)
			e1:SetLabelObject(e1)
			Duel.RegisterEffect(e1,tp)
			local e2=e1:Clone()
			e2:SetCode(EVENT_SSET)
			e2:SetLabelObject(e1)
			Duel.RegisterEffect(e2,tp)
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e3:SetCode(EVENT_PHASE+PHASE_END)
			e3:SetCountLimit(1)
			e3:SetReset(RESET_PHASE+PHASE_END)
			e3:SetCondition(c21103.discon)
			e3:SetOperation(c21103.disop)
			e3:SetLabelObject(e1)
			Duel.RegisterEffect(e3,tp)
		end
	end
end
function c21103.operation(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp then return end
	local tempe = e:GetLabelObject()
	local gc=tempe:GetLabel()
	tempe:SetLabel(gc-1)
end
function c21103.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and e:GetLabelObject():GetLabel()>0
end
function c21103.disop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	local ct=math.floor(g:GetCount()/2)
	local sg=g:RandomSelect(tp,ct)
	Duel.SendtoGrave(sg,REASON_EFFECT)
end
