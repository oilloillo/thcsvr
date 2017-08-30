--下端警戒✿犬走椛
function c23123.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(23123,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(c23123.spcon)
	e1:SetTarget(c23123.sptg)
	e1:SetOperation(c23123.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCondition(c23123.spcon2)
	e3:SetCountLimit(1,23123)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetRange(LOCATION_GRAVE)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetRange(LOCATION_GRAVE)
	c:RegisterEffect(e6)
end
function c23123.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ec=eg:GetFirst()
	return ec:GetSummonPlayer()==tp and ec:IsSetCard(0x824)
end
function c23123.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c23123.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
	end
end
function c23123.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local ec=eg:GetFirst()
	return ec:GetSummonPlayer()~=tp
end
