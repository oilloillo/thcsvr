 
--魔法阵～魔法方形
function c15032.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c15032.target)
	e1:SetOperation(c15032.activate)
	c:RegisterEffect(e1)
end
function c15032.tgfilter(c)
	return c:IsSetCard(0x150) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c15032.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c15032.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c15032.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c15032.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(c15032.elimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,150000,RESET_PHASE+PHASE_END,0,1)
	Duel.RegisterFlagEffect(tp,150000,RESET_PHASE+PHASE_END,0,1)
end
function c15032.elimit(e,te,tp)
	return te:IsHasType(EFFECT_TYPE_ACTIVATE) and te:GetHandler():IsType(TYPE_SPELL)
end
