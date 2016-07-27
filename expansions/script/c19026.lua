--✿芙兰朵露
function c19026.initial_effect(c)

	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsSetCard,0x815),aux.FilterBoolFunction(Card.IsSetCard,0x276),true)

		--Activate
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(19026,0))
		e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
		e1:SetCode(EVENT_SPSUMMON_SUCCESS)
		e1:SetCondition(c19026.cgcon)
		e1:SetCost(c19026.cost)
		e1:SetTarget(c19026.target)
		e1:SetOperation(c19026.operation)
		c:RegisterEffect(e1)

			--destroy1
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
			e2:SetCode(EVENT_LEAVE_FIELD)
			e2:SetOperation(c19026.desop)
			c:RegisterEffect(e2)

		--destroy2
		local e3=Effect.CreateEffect(c)
		e3:SetDescription(aux.Stringid(19026,1))
		e3:SetCategory(CATEGORY_DESTROY)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
		e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e3:SetRange(LOCATION_MZONE)
		e3:SetCountLimit(1)
		e3:SetCondition(c19026.rmcon)
		e3:SetTarget(c19026.rmtg)
		e3:SetOperation(c19026.rmop)
		c:RegisterEffect(e3)

end


function c19026.cgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_FUSION
end


function c19026.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end


function c19026.filter(c,e,tp)
	return bit.band(c:GetReason(),REASON_DESTROY)~=0 and c:GetReasonPlayer()~=c:GetControler() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end


function c19026.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c19026.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end


function c19026.operation(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c19026.filter,tp,LOCATION_GRAVE,0,ft,ft,nil,e,tp)
	local tc=g:GetFirst()
	while tc do
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		c:SetCardTarget(tc)
		tc=g:GetNext()
	end
	Duel.SpecialSummonComplete()
end


function c19026.desfilter(c,rc)
	return rc:IsHasCardTarget(c)
end


function c19026.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c19026.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e:GetHandler())
	Duel.Destroy(g,REASON_EFFECT)
end


function c19026.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end


function c19026.filter1(c)
	return c:IsDestructable()
end


function c19026.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c19026.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
end


function c19026.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c19026.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	local sg=g:RandomSelect(tp,1)
	Duel.HintSelection(sg)
	Duel.Destroy(sg,REASON_EFFECT)
end

