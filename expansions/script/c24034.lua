 
--废狱「Subterranean Rose」
function c24034.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c24034.activate)
	c:RegisterEffect(e1)
end
function c24034.cfilter(c)
	return not c:IsPublic() and c:IsType(TYPE_TRAP)
end
function c24034.activate(e,tp,eg,ep,ev,re,r,rp)
	local dis=false
	if Duel.IsChainDisablable(0) then
		local g=Duel.GetMatchingGroup(c24034.cfilter,tp,0,LOCATION_HAND,nil)
		if g:GetCount()>0 and Duel.SelectYesNo(1-tp,aux.Stringid(24034,0)) then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_CONFIRM)
			local sg=g:Select(1-tp,1,1,nil)
			Duel.ConfirmCards(tp,sg)
			Duel.ShuffleHand(1-tp)
			dis=true
		end
	end
	if not dis then 
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetTarget(c24034.tg)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetValue(1)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetTarget(c24034.tg)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetValue(1)
	--Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetTarget(c24034.tg)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetValue(1)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
	local e4=Effect.CreateEffect(e:GetHandler())
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,0)
	e4:SetValue(1)
	e4:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e4,tp)
	end
end
function c24034.tg(e,c)
	return c:IsSetCard(0x625)
end
