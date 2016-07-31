 
--圣精灵-格奥基乌斯
function c40028.initial_effect(c)
	c:SetUniqueOnField(1,0,40028)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40028,0))
	e1:SetProperty(EFFECT_FLAG_REPEAT)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_HAND)
	e1:SetTarget(c40028.sptg)
	e1:SetOperation(c40028.spop)
	c:RegisterEffect(e1)
	--self destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_SELF_DESTROY)
	e2:SetCondition(c40028.sdcon)
	c:RegisterEffect(e2)
	--disable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_CHAIN_ACTIVATING)
	e3:SetOperation(c40028.disop)
	c:RegisterEffect(e3)
end
function c40028.spfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x430) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c40028.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false) 
		and Duel.IsExistingMatchingCard(c40028.spfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c40028.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
	end
end
function c40028.sdfilter(c)
	return c:IsFaceup() and c:IsCode(40006)
end
function c40028.sdcon(e)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and bit.band(Duel.GetCurrentPhase(),0x38)==Duel.GetCurrentPhase()
		and not Duel.IsExistingMatchingCard(c40028.sdfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function c40028.disop(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	if (ph==PHASE_MAIN1 or ph==PHASE_MAIN2) and re:IsActiveType(TYPE_MONSTER)
		and re:GetHandler():IsAttribute(ATTRIBUTE_DARK) then
		Duel.NegateEffect(ev)
	end
end
