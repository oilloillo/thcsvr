 
--神玉
function c11007.initial_effect(c)
	--effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11007,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c11007.tg)
	e1:SetOperation(c11007.op)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--ritual level
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_RITUAL_LEVEL)
	e3:SetValue(c11007.rlevel)
	c:RegisterEffect(e3)
end
function c11007.filter(c)
	return c:IsType(TYPE_RITUAL) and c:IsAbleToHand()
end
function c11007.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11007.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c11007.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c11007.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c11007.rlevel(e,c)
	local lv=e:GetHandler():GetLevel()
	if c:IsSetCard(0x208) then
		local clv=c:GetLevel()
		return lv*65536+clv
	else return lv end
end
