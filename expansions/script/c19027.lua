--不自然的冷气✿灵乌路空
function c19027.initial_effect(c)

	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsSetCard,0x666),aux.FilterBoolFunction(Card.IsSetCard,0x9999),true)

		--ban le ni ge gua b
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(19027,0))
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
		e1:SetCode(EVENT_SPSUMMON_SUCCESS)
		e1:SetCondition(c19027.cgcon)
		e1:SetTarget(c19027.destg)
		e1:SetOperation(c19027.desop)
		c:RegisterEffect(e1)

		--spsummon
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(19027,1))
		e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
		e2:SetCode(EVENT_TO_GRAVE)
		e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
		e2:SetRange(LOCATION_GRAVE)
		e2:SetCountLimit(1,19027)
		e2:SetCondition(c19027.spcon)
		e2:SetTarget(c19027.sptg)
		e2:SetOperation(c19027.spop)
		c:RegisterEffect(e2)

end


function c19027.cgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_FUSION
end


function c19027.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
end


function c19027.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetCode(EFFECT_FORBIDDEN)
		e1:SetReset(RESET_EVENT+0x1fc0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetReset(RESET_EVENT+0x1fc0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
end


function c19027.cfilter(c,tp)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:GetAttack()<=2000 and c:IsSetCard(0x208)
end


function c19027.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c19027.cfilter,1,nil,tp)
end


function c19027.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
		and c:IsLocation(LOCATION_GRAVE)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end


function c19027.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end

