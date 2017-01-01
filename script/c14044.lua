--梦幻馆 埋葬之果✿艾丽
function c14044.initial_effect(c)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_ATKCHANGE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetTarget(c14044.thtg)
	e3:SetOperation(c14044.thop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(c14044.condition)
	c:RegisterEffect(e4)
	--double tribute
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_DOUBLE_TRIBUTE)
	e5:SetValue(c14044.tricon)
	c:RegisterEffect(e5)
end
function c14044.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_PENDULUM
end
function c14044.ffilter(c)
	return c:IsCode(14035) and c:IsAbleToGrave()
end
function c14044.mfilter(c)
	return c:IsSetCard(0x138) and c:IsLevelBelow(10) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c14044.tfilter(c)
	return (c:IsCode(14023) or c:IsCode(14028)) and c:IsAbleToHand()
end
function c14044.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c14044.ffilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsExistingMatchingCard(c14044.mfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,tp,LOCATION_DECK)
end
function c14044.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,c14044.ffilter,tp,LOCATION_DECK,0,1,1,nil)
	local g2=Duel.SelectMatchingCard(tp,c14044.mfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g1:GetCount()>0 and g2:GetCount()>0 then
		g1:Merge(g2)
		if Duel.SendtoGrave(g1,REASON_EFFECT)>0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(400)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		e:GetHandler():RegisterEffect(e1)
			if Duel.IsExistingMatchingCard(c14044.tfilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(14044,0)) then
				local g=Duel.SelectMatchingCard(tp,c14044.tfilter,tp,LOCATION_DECK,0,1,1,nil)
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end
		end
	end
end
function c14044.tricon(e,c)
	return c:IsSetCard(0x3208)
end
