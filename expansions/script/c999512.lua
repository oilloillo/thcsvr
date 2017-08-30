--寒符『延长的冬日』
function c999512.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c999512.target)
	e1:SetCountLimit(1,999512)
	e1:SetOperation(c999512.activate)
	c:RegisterEffect(e1)

	if c999512.tag_mode_fix==nil then
		c999512.tag_mode_fix = (Duel.GetLP(0)~=8000)
	end
end

function c999512.filter(c)
	return c:IsSetCard(0xaa4) and c:IsAbleToHand()
end

function c999512.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end

function c999512.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp, aux.Stringid(999512,0)) 
		and Duel.IsExistingMatchingCard(c999512.filter,tp,LOCATION_DECK,0,1,nil)then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c999512.filter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end

	if c999512.tag_mode_fix==true then 
		Duel.SelectOption(tp,aux.Stringid(999512,1))
		return 
	end

	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_SKIP_TURN)
	e1:SetTargetRange(0,1)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
	Duel.RegisterEffect(e2,1-tp)
end
