 
--Blanc
function c70013.initial_effect(c)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(70013,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CHAIN_UNIQUE)
	e4:SetCode(EVENT_DESTROY)
	e4:SetRange(LOCATION_HAND)
	e4:SetCondition(c70013.spcon)
	e4:SetTarget(c70013.sptg)
	e4:SetOperation(c70013.spop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetRange(LOCATION_GRAVE)
	c:RegisterEffect(e5)
end
function c70013.spfilter(c,tp)
	return c:IsSetCard(0x4149) and c:GetPreviousControler()==tp and c:GetReasonPlayer()==1-tp
end
function c70013.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c70013.spfilter,1,nil,tp)
end
function c70013.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c70013.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
