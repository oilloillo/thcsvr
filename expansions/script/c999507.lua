--扎克✿蕾蒂
function c999507.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetDescription(aux.Stringid(999507,1))
	e2:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e2:SetCountLimit(1)
	e2:SetTarget(c999507.protg)
	e2:SetValue(c999507.provalue)
	e2:SetOperation(c999507.proop)
	c:RegisterEffect(e2)
	--destroy
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(999507,0))
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_TO_GRAVE)
	e7:SetCategory(CATEGORY_DESTROY)
	e7:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e7:SetCost(c999507.descost)
	e7:SetCondition(c999507.descon)
	e7:SetTarget(c999507.destg)
	e7:SetOperation(c999507.desop)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e8)
	local e9=e7:Clone()
	e9:SetCode(EVENT_TO_DECK)
	c:RegisterEffect(e9)
end

function c999507.profilter(c,tp)
	return c:GetControler()==tp and c:IsLocation(LOCATION_ONFIELD) and c:IsReason(REASON_EFFECT)
end

function c999507.protg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local descount=eg:FilterCount(c999507.profilter,nil,tp)
		local selfcount=Duel.GetFieldGroupCount(tp, LOCATION_ONFIELD, 0)
		return descount>0 and selfcount>0 and descount==selfcount
	end
	return Duel.SelectYesNo(tp,aux.Stringid(999507,1))
end

function c999507.provalue(e,c)
	return c999507.profilter(c,e:GetHandlerPlayer())
end

function c999507.proop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
end

function c999507.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end

function c999507.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) 
		and bit.band(r,0x40)==0x40 and rp~=tp and c:GetPreviousControler()==tp
end

function c999507.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() and chkc:IsDestructable() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end

function c999507.tgfilter(c)
	return c:IsSetCard(0x999) and c:IsAbleToGrave()
end

function c999507.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end

	if Duel.IsExistingMatchingCard(c999507.tgfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil) and Duel.SelectYesNo(tp, aux.Stringid(999507,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c999507.tgfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end