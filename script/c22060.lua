 
--红魔 恶魔之妹
function c22060.initial_effect(c)
	--Race
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_ADD_RACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(RACE_FIEND)
	c:RegisterEffect(e2)
	--cannot be battle target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x813))
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(22060,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_DESTROY)
	e4:SetRange(LOCATION_HAND)
	e4:SetCondition(c22060.spcon)
	e4:SetTarget(c22060.sptg)
	e4:SetOperation(c22060.spop)
	c:RegisterEffect(e4)
	local e6=e4:Clone()
	e6:SetRange(LOCATION_GRAVE)
	e6:SetCountLimit(1,22060+EFFECT_COUNT_CODE_DUEL)
	c:RegisterEffect(e6)
	--maintain
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e5:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetOperation(c22060.mtop)
	c:RegisterEffect(e5)
end
c22060.DescSetName = 0xa3
function c22060.spfilter(c,tp)
	return c:IsSetCard(0x813) and c:IsType(TYPE_MONSTER) and c:GetControler()==tp and bit.band(c:GetReason(),0x41)==0x41
end
function c22060.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c22060.spfilter,1,nil,e:GetHandler():GetControler())
end
function c22060.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c22060.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c22060.mtop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()~=tp then return end
	if Duel.GetLP(tp)>1000 and Duel.SelectYesNo(tp,aux.Stringid(22060,1)) then
		Duel.PayLPCost(tp,1000)
	else
		Duel.Destroy(e:GetHandler(),REASON_RULE)
	end
end
