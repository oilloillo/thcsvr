 
--精灵矿石
function c40032.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40032,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c40032.target)
	e1:SetOperation(c40032.activate)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40032,1))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetTarget(c40032.rmtg)
	e2:SetOperation(c40032.rmop)
	c:RegisterEffect(e2)
end
function c40032.filter(c)
	return (c:IsSetCard(0x417)) and c:IsAbleToHand()
end
function c40032.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40032.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c40032.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c40032.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c40032.rfilter(c)
	return c:IsSetCard(0x413) and c:IsAbleToRemove() and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c40032.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40032.rfilter,tp,0x11,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,0x11)
end
function c40032.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=Duel.SelectMatchingCard(tp,c40032.rfilter,tp,0x11,0,1,1,nil):GetFirst()
	if tc then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		tc:RegisterFlagEffect(40032,RESET_EVENT+0x1fe0000,0,0)
		e:SetLabelObject(tc)
		Duel.BreakEffect()
		c:CancelToGrave()
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(40032,2))
		e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e1:SetCode(EVENT_LEAVE_FIELD)
		e1:SetCondition(c40032.spcon)
		e1:SetTarget(c40032.sptg)
		e1:SetOperation(c40032.spop)
		c:RegisterEffect(e1)
		e1:SetLabelObject(tc)
	end
end
function c40032.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	return tc and c:IsPreviousPosition(POS_FACEUP)
end
function c40032.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetLabelObject():GetFlagEffect(40032)~=0
		and e:GetLabelObject():GetReasonEffect():GetHandler()==e:GetHandler() end
	Duel.SetTargetCard(e:GetLabelObject())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetLabelObject(),1,0,0)
end
function c40032.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
