 
--pururut
function c70023.initial_effect(c)
	--sol
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(70023,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetTarget(c70023.stg)
	e1:SetOperation(c70023.sop)
	c:RegisterEffect(e1)
end
function c70023.filter(c)
	return c:IsSetCard(0x149) and c:IsAbleToHand() and not c:IsCode(70023)
end
function c70023.stg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:GetControler()==tp and c70023.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c70023.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c70023.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,0,0)
end
function c70023.sop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 and Duel.GetMatchingGroupCount(c70023.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)>0 then
			Duel.BreakEffect()
			g=Duel.SelectMatchingCard(tp,c70023.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
			local sg=g:GetFirst()
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
		end
	end
end
function c70023.desfilter(c)
	return c:IsAbleToHand() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
