--司掌宇宙的全能道士✿丰聪耳神子
function c27082.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(c27082.synfilter),1)
	c:EnableReviveLimit()
	--wash floor
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetDescription(aux.Stringid(27082,0))
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c27082.cost)
	e3:SetTarget(c27082.target)
	e3:SetOperation(c27082.operation)
	c:RegisterEffect(e3)
	--Special Summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(27082,1))
	e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCondition(c27082.con)
	e4:SetTarget(c27082.tg)
	e4:SetOperation(c27082.op)
	c:RegisterEffect(e4)
end
function c27082.synfilter(c)
	return c:IsType(TYPE_RITUAL) and c:IsSetCard(0x208)
end
function c27082.cfilter(c)
	return c:IsAbleToRemoveAsCost() and (c:IsLocation(LOCATION_HAND) or (c:IsLocation(LOCATION_SZONE) and (c:GetSequence()==6 or c:GetSequence()==7)))
end
function c27082.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetAttackAnnouncedCount()==0
		and Duel.IsExistingMatchingCard(c27082.cfilter,tp,LOCATION_HAND+LOCATION_SZONE,0,2,e:GetHandler()) end
	local g=Duel.SelectMatchingCard(tp,c27082.cfilter,tp,LOCATION_HAND+LOCATION_SZONE,0,2,2,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1,true)
end
function c27082.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) end
	local sg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,sg,sg:GetCount(),0,0)
end
function c27082.operation(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
end
function c27082.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP)
end
function c27082.filter(c)
	return c:IsAbleToHand()
end
function c27082.spfilter(c,e,tp)
	return c:GetCode()==27079 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c27082.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c27082.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c27082.filter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c27082.filter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c27082.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
		if Duel.IsExistingMatchingCard(c27082.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(27082,0)) then
			local g=Duel.SelectMatchingCard(tp,c27082.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
